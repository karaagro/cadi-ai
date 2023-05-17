from flask import Flask, jsonify, request
import torch
import sys
import os
import re


app = Flask(__name__)
model = torch.hub.load("ultralytics/yolov5", "custom", path="./yolov5_exp11_best.pt",
                       force_reload=False)  # or yolov5n - yolov5x6, custom


@app.route('/', methods=['POST', 'GET'])
def index():
    if request.method == 'POST':
        data = request.json
        img = data['imagePath']

        # Inference
        results = model(img)

        # Checks Operating system
        if sys.platform.startswith('win'):
            img_short = img.split('\\')[-1]

        elif sys.platform.startswith('darwin'):
            img_short = img.split('/')[-1]

        elif sys.platform.startswith('linux'):
            img_short = img.split('/')[-1]

        img_folder = img_short.split('.')[0]


        img_name = re.sub(r'\..+$', '', img_short)
        # Results
        # or .show(), .save(), .crop(), .pandas(), .print() etc
        conditions = results.pandas().xyxy[0].to_json(orient = "records")

        results.save(save_dir=f'./{img_folder}/')
        if sys.platform.startswith('win'):
            path = f'{os.getcwd()}\{img_folder}\{img_short}'

        else:
            path = f'/{img_folder}/{img_short}'

        return jsonify({
            'status': "OK",
            'imagePath': path,
            'conditions': conditions
        })
    
    return({
        "status": "OK",
        "msg": "AI server is running"
    }) 


if __name__ == "__main__":
    app.run()
