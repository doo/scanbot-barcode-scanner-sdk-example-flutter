import 'dart:async';
import 'dart:io';

import 'package:barcode_scanner/scanbot_barcode_sdk.dart';
import 'package:flutter/material.dart';

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
// Please submit the trial license form (https://docs.scanbot.io/trial/) on our website by using
// the app identifier "io.scanbot.example.sdk.barcode.flutter" of this example app or of your app.
const BARCODE_SDK_LICENSE_KEY = "";

Future<void> _initScanbotSdk() async {
  // Consider adjusting this optional storageBaseDirectory - see the comments below.
  final customStorageBaseDirectory = await getDemoStorageBaseDirectory();

  var config = SdkConfiguration(
    loggingEnabled: true,
    // Consider switching logging OFF in production. builds for security and performance reasons.
    licenseKey: BARCODE_SDK_LICENSE_KEY,
    // Uncomment to use custom storage directory
    // storageBaseDirectory: customStorageBaseDirectory,
  );

  if (shouldInitWithEncryption) {
    config.fileEncryptionPassword = 'SomeSecretPa\$\$w0rdForFileEncryption';
    config.fileEncryptionMode = FileEncryptionMode.AES256;
  }

  var licenseResult = await ScanbotBarcodeSdk.initialize(config);
  if (licenseResult is Ok<LicenseInfo>) {
    print(licenseResult.value.status.name);
  } else {
    print(licenseResult.toString());
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
            MenuItemWidget(
                title: 'Classic Component',
                onTap: () => _startBarcodeCustomUIScanner(context)),
            const TitleItemWidget(title: 'Other SDK API'),
            MenuItemWidget(
                title: 'Scan Barcodes from Still Image',
                onTap: () => _scanBarcodesFromImage(context)),
            MenuItemWidget(
                title: 'Scan Barcodes from Multiple Still Images',
                onTap: () => _scanBarcodesFromImages(context)),
            MenuItemWidget(
                title: 'Scan Barcodes from Pdf',
                onTap: () => _scanBarcodesFromPdf(context)),
            MenuItemWidget(
              title: "Set accepted barcode types (RTU UI)",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => BarcodesFormatSelectorWidget()),
                );
              },
            ),
            MenuItemWidget(
              title: 'License Info',
              startIcon: Icons.phonelink_lock,
              onTap: () {
                _getLicenseInfo();
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
        bottomNavigationBar: buildBottomNavigationBar(context));
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
  Future<void> _scanBarcodesFromImage(BuildContext context) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }
    final response = await selectImageFromLibrary();

    if (response == null || response.path.isEmpty) {
      await showAlertDialog(context, title: "Info", "No image picked.");
      return;
    }

    var scannerConfiguration = new BarcodeScannerConfiguration();

    var barcodeFormatCommonConfiguration =
        new BarcodeFormatCommonConfiguration();
    barcodeFormatCommonConfiguration.addAdditionalQuietZone = true;
    barcodeFormatCommonConfiguration.minimumTextLength = 5;

    // Configure different parameters for specific barcode format.
    var barcodeFormatCode128Configuration =
        new BarcodeFormatCode128Configuration();
    barcodeFormatCode128Configuration.minimumTextLength = 6;

    scannerConfiguration.barcodeFormatConfigurations = [
      barcodeFormatCommonConfiguration,
      barcodeFormatCode128Configuration,
    ];

    var result = await ScanbotBarcodeSdk.barcode
        .scanFromImageFileUri(response.path, scannerConfiguration);

    if (result is Ok<BarcodeScannerResult>) {
      if (!result.value.success) {
        await showAlertDialog(context, title: "Info", "No barcodes detected.");
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) =>
                BarcodesResultPreviewWidget(result.value.barcodes)),
      );
    } else {
      await showAlertDialog(context, title: "Info", result.toString());
    }
  }

  /// Detect barcodes from multiple still images
  Future<void> _scanBarcodesFromImages(BuildContext context) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    final paths = await selectImagesFromLibrary();
    if (paths.isEmpty) {
      await showAlertDialog(context, title: "Info", "No images picked.");
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    List<BarcodeItem> allBarcodes = [];

    var scannerConfiguration = new BarcodeScannerConfiguration();

    var barcodeFormatCommonConfiguration =
        new BarcodeFormatCommonConfiguration();
    barcodeFormatCommonConfiguration.addAdditionalQuietZone = true;
    barcodeFormatCommonConfiguration.minimumTextLength = 5;

    // Configure different parameters for specific barcode format.
    var barcodeFormatQrCodeConfiguration =
        new BarcodeFormatQrCodeConfiguration();
    barcodeFormatQrCodeConfiguration.microQr = true;

    scannerConfiguration.barcodeFormatConfigurations = [
      barcodeFormatCommonConfiguration,
      barcodeFormatQrCodeConfiguration,
    ];

    for (var path in paths) {
      var result = await ScanbotBarcodeSdk.barcode
          .scanFromImageFileUri(path, scannerConfiguration);

      if (result is Ok<BarcodeScannerResult>) {
        allBarcodes.addAll(result.value.barcodes);
      } else {
        await showAlertDialog(context, title: "Info", result.toString());
      }
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
    }
  }

  Future<void> _scanBarcodesFromPdf(BuildContext context) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    var pdfFile = await selectPdfFile();
    if (pdfFile == null) {
      return;
    }

    var scanningResult = await ScanbotBarcodeSdk.barcode
        .scanFromPdf(pdfFile.path!, BarcodeScannerConfiguration());

    if (scanningResult is Ok<BarcodeScannerResult>) {
      var barcodes = scanningResult.value.barcodes;
      if (barcodes.isNotEmpty) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BarcodesResultPreviewWidget(barcodes),
          ),
        );
      } else {
        await showAlertDialog(context, title: "Info", "No barcodes detected.");
        return;
      }
    } else {
      await showAlertDialog(context, title: "Info", scanningResult.toString());
    }
  }

  Future<void> _getLicenseInfo() async {
    final result = await ScanbotBarcodeSdk.getLicenseInfo();
    if (result is Ok<LicenseInfo>) {
      var licenseInfo =
          "Status: ${result.value.status.name}\nExpiration Date: ${result.value.expirationDateString}";

      await showAlertDialog(context, title: 'License Info', licenseInfo);
    } else {
      await showAlertDialog(context, title: "Info", result.toString());
    }
  }
}
