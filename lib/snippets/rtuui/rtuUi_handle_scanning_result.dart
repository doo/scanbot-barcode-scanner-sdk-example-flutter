import 'package:barcode_scanner/scanbot_barcode_sdk.dart';
import 'package:flutter/material.dart';
import 'package:scanbot_barcode_sdk_example/utility/utils.dart';

Future<List<BarcodeItem>> handleScanningResult(BuildContext context) async {
  // Start the barcode RTU UI with default configuration
  final scanningResult = await ScanbotBarcodeSdk.barcode
      .startScanner(BarcodeScannerScreenConfiguration());
  switch (scanningResult) {
    case Ok():
      // Extract the list of BarcodeItem from the scanning result
      final barcodes =
          scanningResult.value.items.map((item) => item.barcode).toList();

      return barcodes;
    case Error():
      await showAlertDialog(
          context, title: "Error", scanningResult.error.message);
    case Cancel():
      // Handle the cancellation here if needed
      print("Operation was canceled");
  }
  return [];
}
