import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

Future getLicenseInfo() async {
  var licenseInfoResult = await ScanbotBarcodeSdk.getLicenseInfo();
  if (licenseInfoResult is Ok<LicenseInfo>) {
    // handle a license status here
    print(licenseInfoResult.value);
  }
}
