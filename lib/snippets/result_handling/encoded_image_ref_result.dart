import 'dart:typed_data';

import 'package:barcode_scanner/scanbot_barcode_sdk.dart';
import 'package:flutter/material.dart';
import 'package:scanbot_barcode_sdk_example/utility/utils.dart';

Future<List<Uint8List>> handleScanningResultWithEncodedImageRef(
    BuildContext context) async {
  // Configure scanner to return barcode images
  var config = BarcodeScannerScreenConfiguration();
  config.scannerConfiguration.returnBarcodeImage = true;

  List<Uint8List> imageBuffers = [];

  await autorelease(() async {
    final scanningResult = await ScanbotBarcodeSdk.barcode.startScanner(config);
    if (scanningResult is Ok<BarcodeScannerUiResult>) {
      // Trigger encoding of all ImageRefs
      scanningResult.value.encodeImages();

      // Collect all image buffers
      for (final item in scanningResult.value.items) {
        final buffer = item.barcode.sourceImage?.buffer;
        if (buffer != null) {
          imageBuffers.add(buffer);
        }
      }
    } else {
      await showAlertDialog(context, title: "Info", scanningResult.toString());
    }
  });

  return imageBuffers;
}
