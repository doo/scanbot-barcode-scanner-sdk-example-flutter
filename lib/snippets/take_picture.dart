import 'package:barcode_scanner/scanbot_barcode_sdk.dart';
import 'package:flutter/material.dart';

BarcodeScannerCameraController cameraController =
    BarcodeScannerCameraController();

Widget buildCameraViewWithTakePictureButton() {
  return Stack(
    children: [
      BarcodeScannerCamera(
        controller: cameraController,
        configuration: BarcodeCameraConfiguration(
          scannerConfiguration: BarcodeClassicScannerConfiguration(),
          overlayConfiguration: SelectionOverlayScannerConfiguration(),
        ),
        onPictureTaken: (image) async {
          // Handle take picture event
        },
        barcodeListener: (barcodeItems) async {
          // Handle barcode scanning results
        },
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ShutterButtonView(
            onPressed: () {
              cameraController.takePicture();
            },
            primaryColor: Colors.pink,
            accentColor: Colors.white,
            animatedLineStrokeWidth: 2,
          ),
        ),
      )
    ],
  );
}
