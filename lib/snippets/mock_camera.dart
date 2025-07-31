import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

Future mockCamera() async {
  var config = MockCameraParams(imageFileUri: "{path to your image file}");

  /**
   * On Android, the MANAGE_EXTERNAL_STORAGE permission is required, and the image must have even values for both width and height.
   */
  await ScanbotBarcodeSdk.mockCamera(config);
}
