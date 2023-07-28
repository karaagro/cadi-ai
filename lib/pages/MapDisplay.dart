import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cadi_ai/controllers/MainController.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';
import 'package:get/get.dart';

class MapDisplay extends StatefulWidget {
  const MapDisplay({
    Key? key,
  }) : super(key: key);

  @override
  MapDisplayState createState() => MapDisplayState();
}

class MapDisplayState extends State<MapDisplay> {
  int mapType = 0;
  // ignore: non_constant_identifier_names
  final MAP_ZOOM_LIMIT = 22;
  final mainController = Get.find<MainController>();

  MapDisplayState({Key? key});

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      mainController.appState.allScansLatLong.listen((_) {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _gotoDefault() {
    mainController.appState.mapController.center = LatLng(
        mainController.appState.allScansLatLong[0].latitude,
        mainController.appState.allScansLatLong[0].longitude);
    setState(() {});
  }

  String? getMapUrl(
    x,
    y,
    z,
  ) {
    return {
      0: 'https://api.mapbox.com/styles/v1/drewthejedi/cl7ht68dw003h14p5mdx4xnia/tiles/512/$z/$x/$y@2x?access_token=pk.eyJ1IjoiZHJld3RoZWplZGkiLCJhIjoiY2w3aHRla20zMGh1MDN1c2FpcTBkZzNxbyJ9._phchIP2mPwilN7P-fmd7w',
      1: 'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425'
    }[mapType];
  }

  void onZoomIn() {
    if (mainController.appState.mapController.zoom + 0.5 <= MAP_ZOOM_LIMIT) {
      mainController.appState.mapController.zoom += 0.5;
      setState(() {});
    }
  }

  void onZoomOut() {
    mainController.appState.mapController.zoom -= 0.5;
    setState(() {});
  }

  void onSwitchMapType() {
    setState(() {
      mapType = mapType == 0 ? 1 : 0;
    });
  }

  Offset? _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;
    if (scaleDiff > 0 &&
        mainController.appState.mapController.zoom + 0.02 <= MAP_ZOOM_LIMIT) {
      mainController.appState.mapController.zoom += 0.02;
      setState(() {});
    } else if (scaleDiff < 0) {
      mainController.appState.mapController.zoom -= 0.02;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      mainController.appState.mapController.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  Widget _buildMarkerWidget(Offset pos, Color color,
      [IconData icon = Icons.location_on]) {
    final currentScanImageIndex =
        mainController.appState.selectedScanImageIndex.value;
    final currentLat = mainController
        .appState.allScansLatLong[currentScanImageIndex].latitude
        .toString()
        .substring(0, 8);
    final currentLong = mainController
        .appState.allScansLatLong[currentScanImageIndex].longitude
        .toString()
        .substring(0, 8);

    return Positioned(
      left: pos.dx - 24,
      top: pos.dy - 24,
      width: 48,
      height: 48,
      child: GestureDetector(
        child: Icon(
          icon,
          color: color,
          size: 24,
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text('Lat: $currentLat, Long: $currentLong'),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MapLayoutBuilder(
          controller: mainController.appState.mapController,
          builder: (context, transformer) {
            final markerPositions = mainController.appState.allScansLatLong
                .map(transformer.fromLatLngToXYCoords)
                .toList();

            final markerWidgets =
                markerPositions.asMap().entries.map((position) {
              return _buildMarkerWidget(
                  position.value,
                  mainController.appState.selectedScanImageIndex.value ==
                          position.key
                      ? Colors.red
                      : Colors.blue);
            });

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: _onScaleStart,
              onScaleUpdate: _onScaleUpdate,
              child: Listener(
                behavior: HitTestBehavior.opaque,
                onPointerSignal: (event) {
                  if (event is PointerScrollEvent) {
                    final delta = event.scrollDelta;
                    mainController.appState.mapController.zoom -=
                        delta.dy / 1000.0;
                    setState(() {});
                  }
                },
                child: Stack(
                  children: [
                    Map(
                      controller: mainController.appState.mapController,
                      builder: (context, x, y, z) {
                        return CachedNetworkImage(
                          imageUrl: getMapUrl(x, y, z)!,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    ...markerWidgets,
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Column(
                                verticalDirection: VerticalDirection.up,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 90),
                                    child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: () {
                                            onSwitchMapType();
                                          },
                                          child: Card(
                                              child: SizedBox(
                                                  width: 45,
                                                  height: 40,
                                                  child: Container(
                                                      constraints:
                                                          const BoxConstraints
                                                              .expand(),
                                                      decoration:
                                                          const BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image: AssetImage(
                                                                    'assets/satellite_map.jpeg'),
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5)))))),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10, right: 7),
                                    child: SizedBox(
                                      width: 40,
                                      height: 80,
                                      child: Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.white70,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: Column(
                                            children: [
                                              IconButton(
                                                onPressed: () => onZoomIn(),
                                                icon: const Icon(
                                                  Icons.add,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () => onZoomOut(),
                                                  icon: const Icon(
                                                    Icons.remove,
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          )),
                                    ),
                                  ),
                                ],
                              )),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white70,
        onPressed: _gotoDefault,
        tooltip: 'My Location',
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
