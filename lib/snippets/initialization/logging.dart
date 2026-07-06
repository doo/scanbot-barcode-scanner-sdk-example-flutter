import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

Future<void> initialize() async {
  var config = SdkConfiguration(
    licenseKey: "<YOUR_SCANBOT_SDK_LICENSE_KEY>",
    loggingEnabled: true,
  );

  await ScanbotBarcodeSdk.initialize(config);
}
