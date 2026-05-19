import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

Future<void> initialize() async {
  var config = SdkConfiguration(
    licenseKey: "<YOUR_SCANBOT_SDK_LICENSE_KEY>",
    fileEncryptionPassword: 'SomeSecretPa\$\$w0rdForFileEncryption',
    fileEncryptionMode: FileEncryptionMode.AES256,
  );

  await ScanbotBarcodeSdk.initialize(config);
}
