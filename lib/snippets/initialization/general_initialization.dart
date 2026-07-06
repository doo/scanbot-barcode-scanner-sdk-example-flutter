import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

Future<void> initialize() async {
  var config = SdkConfiguration(
    licenseKey: "<YOUR_SCANBOT_SDK_LICENSE_KEY>",
  );

  await ScanbotBarcodeSdk.initialize(config);
}
