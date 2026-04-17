import 'package:barcode_scanner/scanbot_barcode_sdk.dart';
import 'package:flutter/material.dart';

Widget buildBarcodeScannerCamera() {
  return BarcodeScannerCamera(
    configuration: BarcodeCameraConfiguration(
      scannerConfiguration: BarcodeClassicScannerConfiguration(
        engineMode: BarcodeScannerEngineMode.NEXT_GEN_FAR_DISTANCE,
      ),
      finder: FinderConfiguration(decoration: BoxDecoration()),
      cameraZoomFactor: 0.3,
    ),
    barcodeListener: (barcodeItems) async {
      // Handle barcode scanning results
      print(barcodeItems);
    },
  );
}
