import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

ImageInfo getImageInfo(ImageRef imageRef) {
  var imageInfo = imageRef.info();

  var width = imageInfo.width;
  var height = imageInfo.height;
  // size on disk or in memory depending on load mode
  var maxByteSize = imageInfo.maxByteSize;

  return imageInfo;
}
