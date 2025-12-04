from flask import Flask, jsonify, request
from ultralytics import YOLO
import sys
import os
import re
import json
import cv2
import numpy as np
from pathlib import Path
from typing import List, Dict, Tuple

app = Flask(__name__)
model = YOLO("best (7).pt")

def divide_image_into_crops(image: np.ndarray, grid_size: int = 2) -> List[Dict]:
    """
    Divide image into a grid of crops.
    
    Args:
        image: Input image as numpy array
        grid_size: Number of divisions in each dimension (default 2 for 2x2 grid)
    
    Returns:
        List of dictionaries containing crop info
    """
    height, width = image.shape[:2]
    crop_height = height // grid_size
    crop_width = width // grid_size
    
    crops = []
    crop_id = 0
    
    for row in range(grid_size):
        for col in range(grid_size):
            # Calculate crop coordinates
            x_start = col * crop_width
            y_start = row * crop_height
            
            # For the last column/row, extend to image edge
            x_end = width if col == grid_size - 1 else (col + 1) * crop_width
            y_end = height if row == grid_size - 1 else (row + 1) * crop_height
            
            # Extract crop
            crop = image[y_start:y_end, x_start:x_end]
            
            crops.append({
                'id': crop_id,
                'image': crop,
                'position': {
                    'x_offset': x_start,
                    'y_offset': y_start,
                    'width': x_end - x_start,
                    'height': y_end - y_start
                },
                'row': row,
                'col': col
            })
            crop_id += 1
    
    return crops

def adjust_detections_to_original(detections: List[Dict], crop_info: Dict) -> List[Dict]:
    """
    Adjust detection coordinates from crop space to original image space.
    
    Args:
        detections: List of detections in crop coordinates
        crop_info: Information about the crop position
    
    Returns:
        Adjusted detections in original image coordinates
    """
    adjusted_detections = []
    
    for detection in detections:
        adjusted_detection = detection.copy()
        
        # Adjust coordinates by adding crop offset
        adjusted_detection['xmin'] += crop_info['position']['x_offset']
        adjusted_detection['ymin'] += crop_info['position']['y_offset']
        adjusted_detection['xmax'] += crop_info['position']['x_offset']
        adjusted_detection['ymax'] += crop_info['position']['y_offset']
        
        adjusted_detections.append(adjusted_detection)
    
    return adjusted_detections

def calculate_iou(box1: Dict, box2: Dict) -> float:
    """
    Calculate Intersection over Union (IoU) between two bounding boxes.
    
    Args:
        box1, box2: Dictionaries with xmin, ymin, xmax, ymax keys
    
    Returns:
        IoU value between 0 and 1
    """
    # Calculate intersection coordinates
    x_left = max(box1['xmin'], box2['xmin'])
    y_top = max(box1['ymin'], box2['ymin'])
    x_right = min(box1['xmax'], box2['xmax'])
    y_bottom = min(box1['ymax'], box2['ymax'])
    
    # Check if there is an intersection
    if x_right < x_left or y_bottom < y_top:
        return 0.0
    
    # Calculate intersection area
    intersection_area = (x_right - x_left) * (y_bottom - y_top)
    
    # Calculate areas of both boxes
    box1_area = (box1['xmax'] - box1['xmin']) * (box1['ymax'] - box1['ymin'])
    box2_area = (box2['xmax'] - box2['xmin']) * (box2['ymax'] - box2['ymin'])
    
    # Calculate union area
    union_area = box1_area + box2_area - intersection_area
    
    # Calculate IoU
    if union_area == 0:
        return 0.0
    
    return intersection_area / union_area

def non_max_suppression_merge(detections: List[Dict], iou_threshold: float = 0.3) -> List[Dict]:
    """
    Apply Non-Maximum Suppression to merge overlapping detections from different crops.
    
    Args:
        detections: List of all detections from all crops
        iou_threshold: IoU threshold for merging (lower = more aggressive merging)
    
    Returns:
        Filtered list of detections after NMS
    """
    if not detections:
        return []
    
    # Sort detections by confidence score (descending)
    sorted_detections = sorted(detections, key=lambda x: x['confidence'], reverse=True)
    
    kept_detections = []
    
    while sorted_detections:
        # Take the detection with highest confidence
        best_detection = sorted_detections.pop(0)
        kept_detections.append(best_detection)
        
        # Remove all detections with high IoU with the best detection
        sorted_detections = [
            det for det in sorted_detections
            if calculate_iou(best_detection, det) < iou_threshold or 
            det['class'] != best_detection['class']  # Don't merge different classes
        ]
    
    return kept_detections

def run_inference_on_crops(image_path: str, grid_size: int = 2, 
                          iou_threshold: float = 0.3, 
                          confidence_threshold: float = 0.25) -> Tuple[List[Dict], np.ndarray]:
    """
    Run YOLO inference on image crops and merge results.
    
    Args:
        image_path: Path to the input image
        grid_size: Grid division size (default 2 for 2x2)
        iou_threshold: IoU threshold for NMS (default 0.3)
        confidence_threshold: Confidence threshold for detections (default 0.25)
    
    Returns:
        Tuple of (merged detections, annotated image)
    """
    # Read the original image
    image = cv2.imread(image_path)
    if image is None:
        raise ValueError(f"Could not read image: {image_path}")
    
    original_height, original_width = image.shape[:2]
    
    # Divide image into crops
    crops = divide_image_into_crops(image, grid_size)
    print(f"Divided image into {len(crops)} crops ({grid_size}x{grid_size} grid)")
    
    all_detections = []
    
    # Run inference on each crop
    for crop_info in crops:
        crop_image = crop_info['image']
        
        # Run YOLO on the crop
        results = model(crop_image, conf=confidence_threshold, verbose=False)
        
        # Extract detections from this crop
        crop_detections = []
        if len(results) > 0:
            result = results[0]
            
            if result.boxes is not None:
                boxes = result.boxes.xyxy.cpu().numpy()
                confidences = result.boxes.conf.cpu().numpy()
                classes = result.boxes.cls.cpu().numpy()
                
                for i in range(len(boxes)):
                    detection = {
                        'xmin': float(boxes[i][0]),
                        'ymin': float(boxes[i][1]),
                        'xmax': float(boxes[i][2]),
                        'ymax': float(boxes[i][3]),
                        'confidence': float(confidences[i]),
                        'class': int(classes[i]),
                        'name': result.names[int(classes[i])] if result.names else f"class_{int(classes[i])}"
                    }
                    crop_detections.append(detection)
        
        # Adjust detections to original image coordinates
        adjusted_detections = adjust_detections_to_original(crop_detections, crop_info)
        all_detections.extend(adjusted_detections)
        
        print(f"  Crop {crop_info['id']} (row={crop_info['row']}, col={crop_info['col']}): "
              f"{len(crop_detections)} detections")
    
    print(f"Total detections before NMS: {len(all_detections)}")
    
    # Apply NMS to merge overlapping detections
    merged_detections = non_max_suppression_merge(all_detections, iou_threshold)
    
    print(f"Total detections after NMS: {len(merged_detections)}")
    
    # Draw the merged detections on the original image
    annotated_image = image.copy()
    
    # Define colors for different classes
    colors = [
        (255, 0, 0),    # Blue
        (0, 255, 0),    # Green
        (0, 0, 255),    # Red
        (255, 255, 0),  # Cyan
        (255, 0, 255),  # Magenta
        (0, 255, 255),  # Yellow
    ]
    
    # Draw detections
    for det in merged_detections:
        x1, y1 = int(det['xmin']), int(det['ymin'])
        x2, y2 = int(det['xmax']), int(det['ymax'])
        
        # Get color based on class
        color = colors[det['class'] % len(colors)]
        
        # Draw bounding box
        cv2.rectangle(annotated_image, (x1, y1), (x2, y2), color, 2)
        
        # Draw label
        label = f"{det['name']}: {det['confidence']:.2f}"
        label_size, _ = cv2.getTextSize(label, cv2.FONT_HERSHEY_SIMPLEX, 0.5, 1)
        
        # Draw label background
        cv2.rectangle(annotated_image, 
                     (x1, y1 - label_size[1] - 4),
                     (x1 + label_size[0], y1),
                     color, -1)
        
        # Draw label text
        cv2.putText(annotated_image, label,
                   (x1, y1 - 2),
                   cv2.FONT_HERSHEY_SIMPLEX,
                   0.5, (255, 255, 255), 1)
    
    return merged_detections, annotated_image

@app.route('/', methods=['POST', 'GET'])
def index():
    if request.method == 'POST':
        try:
            data = request.json
            img_path = data['imagePath']
            
            # Optional parameters from request
            grid_size = data.get('gridSize', 2)  # Default 2x2 grid
            iou_threshold = data.get('iouThreshold', 0.3)  # Default 0.3
            confidence_threshold = data.get('confidenceThreshold', 0.25)  # Default 0.25
            use_crop_merge = data.get('useCropMerge', True)  # Default to use crop-merge strategy
            
            # Validate image path exists
            if not os.path.exists(img_path):
                return jsonify({
                    'status': "ERROR",
                    'message': f"Image file not found: {img_path}"
                }), 400

            # Extract image name using old method's logic
            if sys.platform.startswith('win'):
                img_short = img_path.split('\\')[-1]
            elif sys.platform.startswith('darwin'):
                img_short = img_path.split('/')[-1]
            elif sys.platform.startswith('linux'):
                img_short = img_path.split('/')[-1]
            
            # Get folder name (image name without extension)
            img_folder = img_short.split('.')[0]
            img_name = re.sub(r'\..+$', '', img_short)
            
            # Create output directory (same as old method)
            os.makedirs(f'./{img_folder}/', exist_ok=True)

            print(f"Processing image: {img_path}")
            
            if use_crop_merge:
                # Use crop-and-merge strategy
                print(f"Using crop-and-merge strategy with {grid_size}x{grid_size} grid")
                detections, annotated_image = run_inference_on_crops(
                    img_path, 
                    grid_size=grid_size,
                    iou_threshold=iou_threshold,
                    confidence_threshold=confidence_threshold
                )
                
                # Save annotated image to folder (same as old method)
                save_path = f'./{img_folder}/{img_short}'
                cv2.imwrite(save_path, annotated_image)
                
            else:
                # Use standard single-image inference (original method)
                print("Using standard single-image inference")
                results = model(img_path, conf=confidence_threshold)
                
                # Extract detection results
                detections = []
                if len(results) > 0:
                    result = results[0]
                    
                    if result.boxes is not None:
                        boxes = result.boxes.xyxy.cpu().numpy()
                        confidences = result.boxes.conf.cpu().numpy()
                        classes = result.boxes.cls.cpu().numpy()
                        
                        for i in range(len(boxes)):
                            detection = {
                                'xmin': float(boxes[i][0]),
                                'ymin': float(boxes[i][1]),
                                'xmax': float(boxes[i][2]),
                                'ymax': float(boxes[i][3]),
                                'confidence': float(confidences[i]),
                                'class': int(classes[i]),
                                'name': result.names[int(classes[i])] if result.names else f"class_{int(classes[i])}"
                            }
                            detections.append(detection)
                
                # Save annotated image (old method)
                results[0].save(save_dir=f'./{img_folder}/')
                save_path = f'./{img_folder}/{img_short}'
            
            # Convert detections to JSON string for compatibility
            conditions_json = json.dumps(detections)
            
            # Construct full path (same as old method)
            if sys.platform.startswith('win'):
                path = f'{os.getcwd()}\\{img_folder}\\{img_short}'
            else:
                path = f'{img_folder}/{img_short}'
            
            print(f"Results saved to: {path}")
            print(f"Found {len(detections)} detections")

            response_data = {
                'status': "OK",
                'imagePath': path,
                'conditions': conditions_json
            }
                
            return jsonify(response_data)
            
        except FileNotFoundError as e:
            return jsonify({
                'status': "ERROR",
                'message': f"File not found: {str(e)}"
            }), 404
            
        except Exception as e:
            print(f"Error processing request: {str(e)}")
            return jsonify({
                'status': "ERROR",
                'message': f"Processing failed: {str(e)}"
            }), 500
    
    # GET request
    return jsonify({
        "status": "OK",
        "message": "AI server is running with crop-merge capability",
        "model": "YOLO best (7).pt"
    })


if __name__ == "__main__":
    print("=" * 50)
    print("YOLO Inference Server with Crop-Merge Strategy")
    print("=" * 50)
    print("\nCapabilities:")
    print("• Standard single-image inference")
    print("• Crop-and-merge inference for better small object detection")
    print("• Configurable grid size (2x2, 3x3, etc.)")
    print("• Non-Maximum Suppression for merging overlapping detections")
    print("• Adjustable IoU and confidence thresholds")
    print("\nAPI Parameters (all optional):")
    print("• useCropMerge: bool (default: True)")
    print("• gridSize: int (default: 2 for 2x2 grid)")
    print("• iouThreshold: float (default: 0.3)")
    print("• confidenceThreshold: float (default: 0.25)")
    print("=" * 50)
    
    app.run()
