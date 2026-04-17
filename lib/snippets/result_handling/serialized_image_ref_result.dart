import 'dart:typed_data';

import 'package:barcode_scanner/scanbot_barcode_sdk.dart';
import 'package:flutter/material.dart';
import 'package:scanbot_barcode_sdk_example/utility/utils.dart';

Future<List<Uint8List?>> handleScanningResultWithSerializedImageRef(
    BuildContext context) async {
  // Configure scanner to return image refs
  var config = BarcodeScannerScreenConfiguration();
  config.scannerConfiguration.returnBarcodeImage = true;

  // This will hold the serialized result outside autorelease
  Map<String, dynamic>? serializedResult;

  // First autorelease block: serialize the scanning result
  await autorelease(() async {
    final scanningResult = await ScanbotBarcodeSdk.barcode.startScanner(config);
    if (scanningResult is Ok<BarcodeScannerUiResult>) {
      // Serialized the scanned result in order to move the data outside the autorelease block
      serializedResult = await scanningResult.value.toJson();
    } else {
      await showAlertDialog(context, title: "Info", scanningResult.toString());
    }
  });

  List<Uint8List?> imageBuffers = [];

  // In another part of the app utilize the serialized result
  await autorelease(() async {
    final barcodeResult = BarcodeScannerUiResult.fromJson(serializedResult!);

    for (final item in barcodeResult.items) {
      final sourceImage = item.barcode.sourceImage;
      if (sourceImage != null) {
        // Saves the stored image at path with the given options
        final path = '/your_custom_path/my_file.jpg';
        sourceImage.saveImage(path, options: SaveImageOptions());

        // Get the image buffer (as Uint8List)
        final buffer = sourceImage.encodeImage(options: EncodeImageOptions());
        imageBuffers.add(buffer);
      }
    }
  });

  return imageBuffers;
}
