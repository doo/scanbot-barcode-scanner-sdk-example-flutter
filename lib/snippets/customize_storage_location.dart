import 'dart:io';
import 'package:barcode_scanner/scanbot_barcode_sdk.dart';
import 'package:path_provider/path_provider.dart';

Future<String> getCustomStorageBaseDirectoryLocation() async {
  Directory? storageDirectory;

  // Determine the appropriate storage directory based on the platform
  if (Platform.isAndroid) {
    storageDirectory = await getExternalStorageDirectory();
  } else if (Platform.isIOS) {
    storageDirectory = await getApplicationDocumentsDirectory();
  }

  // Note: The methods `getExternalStorageDirectory()` and `getApplicationDocumentsDirectory()`
  // are provided by the "path_provider" package, a third-party plugin.

  return "${storageDirectory?.path}/my_custom_storage";
}

Future<void> initalizeSdk() async {
  var customStorageBaseDirectory =
      await getCustomStorageBaseDirectoryLocation();

  var config = ScanbotSdkConfig(
    storageBaseDirectory: customStorageBaseDirectory,
    // Additional configuration options...
  );

  // Initialize the Scanbot SDK with the specified configuration
  await ScanbotBarcodeSdk.initScanbotSdk(config);
}
