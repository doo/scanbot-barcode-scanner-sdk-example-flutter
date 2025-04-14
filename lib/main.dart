import 'dart:async';
import 'dart:io';

import 'package:barcode_scanner/scanbot_barcode_sdk.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../ui/menu_item.dart';
import '../utility/utils.dart';

import 'barcode_use_cases.dart';
import 'classic_components/barcode_custom_ui.dart';

import 'ui/barcode_formats/selector.dart';
import 'ui/preview/barcodes_result_preview.dart';

bool shouldInitWithEncryption = false;

void main() => runApp(MyApp());

// TODO Add the Scanbot Barcode Scanner SDK license key here.
// Please note: The Scanbot Barcode Scanner SDK will run without a license key for one minute per session!
// After the trial period is over all Barcode SDK functions as well as the UI components will stop working.
// You can get an unrestricted "no-strings-attached" 30 day trial license key for free.
// Please submit the trial license form (https://scanbot.io/en/sdk/demo/trial) on our website by using
// the app identifier "io.scanbot.example.sdk.barcode.flutter" of this example app or of your app.
const BARCODE_SDK_LICENSE_KEY = "";

Future<void> _initScanbotSdk() async {
  // Consider adjusting this optional storageBaseDirectory - see the comments below.
  final customStorageBaseDirectory = await getDemoStorageBaseDirectory();

  var config = ScanbotSdkConfig(
    loggingEnabled: true,
    // Consider switching logging OFF in production. builds for security and performance reasons.
    licenseKey: BARCODE_SDK_LICENSE_KEY,
    // Uncomment to use custom storage directory
    // storageBaseDirectory: customStorageBaseDirectory,
  );

  if(shouldInitWithEncryption) {
    config.fileEncryptionPassword = 'SomeSecretPa\$\$w0rdForFileEncryption';
    config.fileEncryptionMode = FileEncryptionMode.AES256;
  }

  try {
    var statusLicenseResult = await ScanbotBarcodeSdk.initScanbotSdk(config);
    print(statusLicenseResult.licenseStatus);
  } catch (e) {
    print(e);
  }
}

Future<String> getDemoStorageBaseDirectory() async {
  Directory storageDirectory;
  if (Platform.isAndroid) {
    storageDirectory = (await getExternalStorageDirectory())!;
  } else if (Platform.isIOS) {
    storageDirectory = await getApplicationDocumentsDirectory();
  } else {
    throw ('Unsupported platform');
  }

  return '${storageDirectory.path}/my-custom-storage';
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
    _initScanbotSdk();
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPageWidget(),
      navigatorObservers: [ScanbotCamera.scanbotSdkRouteObserver],
    );
  }
}

class MainPageWidget extends StatefulWidget {
  @override
  _MainPageWidgetState createState() => _MainPageWidgetState();
}

class _MainPageWidgetState extends State<MainPageWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ScanbotAppBar('Scanbot SDK Flutter Example'),
        body: ListView(
          children: [
            BarcodeUseCasesWidget(),
            const TitleItemWidget(title: 'Custom UI'),
            MenuItemWidget(title: 'Classic Component', onTap: () => _startBarcodeCustomUIScanner(context)),
            const TitleItemWidget(title: 'Other SDK API'),
            MenuItemWidget(title: 'Detect Barcodes from Still Image', onTap: () => _detectBarcodeOnImage(context)),
            MenuItemWidget(title: 'Detect Barcodes from Multiple Still Images', onTap: () => _detectBarcodesOnImages(context)),
            MenuItemWidget(title: 'Detect Images From Pdf', onTap: () => _detectImagesOnPdf(context)),
            MenuItemWidget(
              title: "Set accepted barcode types (RTU)",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          BarcodesFormatSelectorWidget()),
                );
              },
            ),
            MenuItemWidget(
              title: 'getLicenseStatus()',
              startIcon: Icons.phonelink_lock,
              onTap: () {
                _getLicenseStatus();
              },
            ),
            MenuItemWidget(
              title: '3rd-party Libs & Licenses',
              startIcon: Icons.developer_mode,
              onTap: () {
                showLicensePage(
                  context: context,
                  applicationName: 'Scanbot SDK Flutter Example',
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: buildBottomNavigationBar(context)
    );
  }

  Future<void> _startBarcodeCustomUIScanner(BuildContext context) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const BarcodeScannerWidget()),
    );

    if (result is BarcodeScannerResult) {
      await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => BarcodesResultPreviewWidget(result.barcodes)),
      );
    }
  }

  /// Detect barcodes from still image
  Future<void> _detectBarcodeOnImage(BuildContext context) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }
    try {
      final response = await selectImageFromLibrary();

      if (response == null || response.path.isEmpty) {
        await showAlertDialog(context, title: "Info", "No image picked.");
        return;
      }

      final uriPath = Uri.file(response.path);

      var result = await ScanbotBarcodeSdk.detectBarcodesOnImage(
          uriPath,
          BarcodeScannerConfiguration());

      if(!result.success) {
        await showAlertDialog(context, title: "Info", "No barcodes detected.");
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => BarcodesResultPreviewWidget(result.barcodes)),
      );

    } catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ex.toString()),
      ));
    }
  }

  /// Detect barcodes from multiple still images
  Future<void> _detectBarcodesOnImages(BuildContext context) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      List<Uri> uris = List.empty(growable: true);

      final response = await ImagePicker().pickMultiImage();
      if (response.isEmpty) {
        await showAlertDialog(context, title: "Info", "No image picked.");
        return;
      }

      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          }
      );

      uris = response.map((image) => Uri.file(image.path)).toList();

      List<BarcodeItem> allBarcodes = [];

      for (var uri in uris) {
        var result = await ScanbotBarcodeSdk.detectBarcodesOnImage(
          uri,
          BarcodeScannerConfiguration());

        allBarcodes.addAll(result.barcodes);
      }

      Navigator.of(context).pop();

      if (allBarcodes.isNotEmpty) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BarcodesResultPreviewWidget(allBarcodes),
          ),
        );
      } else {
        await showAlertDialog(context, title: "Info", "No barcodes detected.");
        return;
      }

    } catch (ex) {
      Navigator.of(context, rootNavigator: true).pop();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ex.toString()),
      ));
    }
  }

  Future<void> _getLicenseStatus() async {
    try {
      final result = await ScanbotBarcodeSdk.getLicenseStatus();
      var status = " Status: ${result.licenseStatus.name}";

      if (result.licenseExpirationDate != null) {
        status += "\n ExpirationDate: ${result.licenseExpirationDate}";
      }

      await showAlertDialog(context, status, title: 'License Status');
    } catch (e) {
      await showAlertDialog(context, title: "Info", 'Error getting license status');
    }
  }

  Future<void> _detectImagesOnPdf(BuildContext context) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }
    try {
      final response = await selectPdfFile();

      if (response?.path == null) {
        await showAlertDialog(context, title: "Info", "No pdf picked.");
        return;
      }

      var result = await ScanbotBarcodeSdk.extractImagesFromPdf(ExtractImagesFromPdfParams(pdfFilePath: response!.path!));
      if(result != null) {
        await showAlertDialog(context, title: "Result", result.join('\n'));
      }
    } catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ex.toString()),
      ));
    }
  }

}