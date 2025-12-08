import 'dart:typed_data';

import 'package:barcode_scanner/barcode_sdk.dart';

Future<List<BarcodeItem>> handleScanningResultWithImageRef() async {
  // Start the barcode RTU UI with default configuration
  var config = BarcodeScannerScreenConfiguration();
  config.scannerConfiguration.returnBarcodeImage = true;

  // Autorelease executes the given block and releases native resources
  await autorelease(() async {
    final scanningResult = await ScanbotSdk.barcode.startScanner(config);
    if (scanningResult.status == OperationStatus.OK &&
        scanningResult.data != null) {
      scanningResult.data?.items.forEach((item) async {
        if (item.barcode.sourceImage != null) {
          // Saves the stored image at path with the given options
          final path = '/my_custom_path/my_file.jpg';
          await item.barcode.sourceImage
              ?.saveImage(path, options: SaveImageOptions());

          // Returns the stored image as Uint8List.
          final byteArray = await item.barcode.sourceImage
              ?.encodeImage(options: EncodeImageOptions());
        }
        ;
      });
    }
  });

  return [];
}

Future<List<Uint8List?>> handleScanningResultWithSerializedImageRef() async {
  // Configure scanner to return image refs
  var config = BarcodeScannerScreenConfiguration();
  config.scannerConfiguration.returnBarcodeImage = true;

  // This will hold the serialized result outside autorelease
  Map<String, dynamic>? serializedResult;

  // First autorelease block: serialize the scanning result
  await autorelease(() async {
    final scanningResult = await ScanbotSdk.barcode.startScanner(config);
    if (scanningResult.status == OperationStatus.OK &&
        scanningResult.data != null) {
      // Serialized the scanned result in order to move the data outside the autorelease block
      serializedResult = await scanningResult.data!.toJson();
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
        await sourceImage.saveImage(path, options: SaveImageOptions());

        // Get the image buffer (as Uint8List)
        final buffer =
            await sourceImage.encodeImage(options: EncodeImageOptions());
        imageBuffers.add(buffer);
      }
    }
  });

  return imageBuffers;
}

Future<List<Uint8List?>> handleScanningResultWithEncodedImageRef() async {
  // Configure scanner to return barcode images
  var config = BarcodeScannerScreenConfiguration();
  config.scannerConfiguration.returnBarcodeImage = true;

  List<Uint8List?> imageBuffers = [];

  await autorelease(() async {
    final scanningResult = await ScanbotSdk.barcode.startScanner(config);
    if (scanningResult.status == OperationStatus.OK &&
        scanningResult.data != null) {
      // Trigger encoding of all ImageRefs
      scanningResult.data!.encodeImages();

      // Collect all image buffers
      imageBuffers = scanningResult.data!.items
          .map((item) => item.barcode.sourceImage?.buffer)
          .toList();
    }
  });

  return imageBuffers;
}
