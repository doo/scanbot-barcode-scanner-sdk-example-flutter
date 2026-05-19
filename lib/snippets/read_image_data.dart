// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

Future readImageData(String imageFileUri) async {
  final result =
      await ScanbotBarcodeSdk.imageProcessor.readImageData(imageFileUri);

  if (result is Ok<String>) {
    Uint8List bytes = base64Decode(result.value);

    // use image widget to show preview
    final image = Image.memory(bytes);
  }
}
