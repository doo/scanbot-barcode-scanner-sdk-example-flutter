import 'dart:typed_data';

import 'package:barcode_scanner/scanbot_barcode_sdk.dart';
import 'package:flutter/material.dart';
import 'package:scanbot_barcode_sdk_example/utility/utils.dart';

Future<Uint8List?> handleScanningResultWithImageRef(
    BuildContext context) async {
  // Start the barcode RTU UI with default configuration
  var config = BarcodeScannerScreenConfiguration();
  config.scannerConfiguration.returnBarcodeImage = true;

  Uint8List? byteArray;

  // Autorelease executes the given block and releases native resources
  await autorelease(() async {
    final scanningResult = await ScanbotBarcodeSdk.barcode.startScanner(config);
    if (scanningResult is Ok<BarcodeScannerUiResult>) {
      scanningResult.value.items.forEach((item) async {
        if (item.barcode.sourceImage != null) {
          // Saves the stored image at path with the given options
          final path = '/my_custom_path/my_file.jpg';
          item.barcode.sourceImage
              ?.saveImage(path, options: SaveImageOptions());

          // Returns the stored image as Uint8List.
          byteArray = item.barcode.sourceImage
              ?.encodeImage(options: EncodeImageOptions());
        }
      });
    } else {
      await showAlertDialog(context, title: "Info", scanningResult.toString());
    }
  });

  return byteArray;
}
