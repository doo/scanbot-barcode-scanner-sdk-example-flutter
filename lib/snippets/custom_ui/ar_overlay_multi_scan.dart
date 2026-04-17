import 'package:barcode_scanner/scanbot_barcode_sdk.dart';
import 'package:flutter/material.dart';

Widget buildBarcodeScannerCamera() {
  return BarcodeScannerCamera(
    configuration: BarcodeCameraConfiguration(
      scannerConfiguration: BarcodeClassicScannerConfiguration(),
      overlayConfiguration: SelectionOverlayScannerConfiguration(
        overlayEnabled: true,
        textFormat: BarcodeOverlayTextFormat.CODE_AND_TYPE,
        polygonColor: Colors.green,
        textColor: Colors.white,
        textContainerColor: Colors.grey,
      ),
    ),
    barcodeListener: (barcodeItems) async {
      // Handle barcode scanning results
      print(barcodeItems);
    },
  );
}
