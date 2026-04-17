import 'package:barcode_scanner/scanbot_barcode_sdk.dart';
import 'package:flutter/material.dart';

Widget buildBarcodeScannerCamera() {
  return BarcodeScannerCamera(
    configuration: BarcodeCameraConfiguration(
      minFocusDistanceLock: true,
      scannerConfiguration: BarcodeClassicScannerConfiguration(),
      finder: FinderConfiguration(
          decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.white),
      )),
    ),
    barcodeListener: (barcodeItems) async {
      // Handle barcode scanning results
      print(barcodeItems);
    },
  );
}
