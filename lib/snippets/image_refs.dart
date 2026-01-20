import 'dart:math';
import 'dart:typed_data';

import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

void createImageRefFromPath(String imagePath) async {
  autorelease(() {
    // Create ImageRef from path
    var imageRef = ImageRef.fromPath(imagePath);

    // Create ImageRef from  path with options
    var imageRefWithOptions = ImageRef.fromPath(
      imagePath,
      options: PathImageLoadOptions(
        // Define crop rectangle
        cropRect: Rectangle<int>(0, 0, 200, 200),
        // Convert image to grayscale
        colorConversion: ColorConversion.GRAY,
        // Use lazy loading mode, image would be loaded into memory only when first used
        loadMode: PathLoadMode.LAZY_WITH_COPY,
        // handle encryption automatically based on global ImageRef/ScanbotSdk encryption settings
        encryptionMode: EncryptionMode.AUTO,
        // to disable decryption while reading for this specific file (in case its not encrypted with SDK encryption ON), use
        // encryptionMode: EncryptionMode.DISABLED,
      ),
    );
  });
}

void createImageRefFromEncodedBuffer(Uint8List bytes) async {
  autorelease(() {
    // Create ImageRef from buffer
    var imageRef = ImageRef.fromEncodedBuffer(bytes);

    // Create ImageRef from buffer with options
    var imageRefWithOptions = ImageRef.fromEncodedBuffer(
      bytes,
      options: BufferImageLoadOptions(
          // Define crop rectangle
          cropRect: Rectangle<int>(0, 0, 200, 200),
          // Convert image to grayscale
          colorConversion: ColorConversion.GRAY,
          // Use lazy loading mode, image would be loaded into memory only when first used
          loadMode: BufferLoadMode.LAZY),
    );
  });
}

ImageInfo getImageInfo(ImageRef imageRef) {
  return autorelease(() {
    var imageInfo = imageRef.info();

    var width = imageInfo.width;
    var height = imageInfo.height;
    // size on disk or in memory depending on load mode
    var maxByteSize = imageInfo.maxByteSize;

    return imageInfo;
  });
}

void saveImage(ImageRef imageRef, String destinationPath) {
  autorelease(() {
    imageRef.saveImage(
      destinationPath,
      options: SaveImageOptions(
        quality: 100, encryptionMode: EncryptionMode.AUTO,
        // to disable decryption while reading for this specific file (in case its not encrypted with SDK encryption ON), use
        // encryptionMode: EncryptionMode.DISABLED,
      ),
    );
  });
}
