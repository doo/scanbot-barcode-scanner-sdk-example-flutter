import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:barcode_scanner/scanbot_barcode_sdk.dart';
import 'package:barcode_scanner/scanbot_barcode_sdk.dart' as scanbot;

import 'package:scanbot_barcode_sdk_example/ui/barcode_formats_repo.dart';
import 'package:scanbot_barcode_sdk_example/ui/barcodes_formats_selector.dart';
import 'package:scanbot_barcode_sdk_example/ui/barcodes_preview_widget.dart';
import 'package:scanbot_barcode_sdk_example/ui/classical_components/barcode_custom_ui.dart';
import 'package:scanbot_barcode_sdk_example/ui/classical_components/test_barcode.dart';
import 'package:scanbot_barcode_sdk_example/ui/menu_items.dart';
import 'package:scanbot_image_picker/models/image_picker_response.dart';
import 'package:scanbot_image_picker/scanbot_image_picker_flutter.dart';

bool shouldInitWithEncryption = false;
BarcodeFormatsRepository barcodeFormatsRepository = BarcodeFormatsRepository();

void main() => runApp(MyApp());

// TODO Add the Scanbot Barcode Scanner SDK license key here.
// Please note: The Scanbot Barcode Scanner SDK will run without a license key for one minute per session!
// After the trial period is over all Barcode SDK functions as well as the UI components will stop working.
// You can get an unrestricted "no-strings-attached" 30 day trial license key for free.
// Please submit the trial license form (https://scanbot.io/en/sdk/demo/trial) on our website by using
// the app identifier "io.scanbot.example.sdk.barcode.flutter" of this example app or of your app.
const BARCODE_SDK_LICENSE_KEY = "";
_initScanbotSdk() async {
  Directory? storageDirectory;
  if (Platform.isAndroid) {
    storageDirectory = await getExternalStorageDirectory();
  }
  if (Platform.isIOS) {
    storageDirectory = await getApplicationDocumentsDirectory();
  }
  EncryptionParameters? encryptionParameters;
  if (shouldInitWithEncryption) {
    encryptionParameters = EncryptionParameters(
        password: "password", mode: FileEncryptionMode.AES256);
  }
  var config = ScanbotSdkConfig(
      licenseKey: BARCODE_SDK_LICENSE_KEY,
      encryptionParameters: encryptionParameters,
      loggingEnabled: true,
      // Consider disabling logging in production builds for security and performance reasons.
      storageBaseDirectory:
          "${storageDirectory?.path}/custom-barcode-sdk-storage");

  try {
    config.useCameraX = true;
    await ScanbotBarcodeSdk.initScanbotSdk(config);
  } catch (e) {
    print(e);
  }
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
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Barcode SDK Flutter Example App',
            style: TextStyle(inherit: true, color: Colors.black)),
      ),
      body: ListView(
        children: <Widget>[
          MenuItemWidget(
            "Scan Barcode",
            onTap: () {
              startBarcodeScanner();
            },
          ),
          MenuItemWidget(
            "Scan Barcode with Image Result",
            onTap: () {
              startBarcodeScanner(shouldSnapImage: true);
            },
          ),
          MenuItemWidget(
            "Scan Batch Barcodes",
            onTap: () {
              startBatchBarcodeScanner();
            },
          ),
          MenuItemWidget(
            'Scan Barcode (Custom UI)',
            onTap: () {
              _startBarcodeCustomUIScanner();
            },
          ),
          MenuItemWidget(
            'Scan Barcode (Client UI)',
            onTap: () {
              _startBarcodeClientUIScanner();
            },
          ),
          MenuItemWidget(
            "Pick Image from Gallery",
            onTap: () {
              pickImageAndDetect();
            },
          ),
          MenuItemWidget(
            "Cleanup Storage",
            onTap: () {
              cleanupStorage();
            },
          ),
          MenuItemWidget(
            "Set Accepted Barcodes",
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        BarcodesFormatSelectorWidget(barcodeFormatsRepository)),
              );
            },
          ),
          MenuItemWidget(
            "Check License Status",
            onTap: () {
              showLicenseStatus();
            },
          ),
          MenuItemWidget(
            "Licenses info",
            startIcon: Icons.settings,
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: 'Scanbot Barcode sdk example',
                applicationVersion: '1.0',
                applicationLegalese:
                    'Copyright (c) 2016 doo GmbH, https://scanbot.io',
              );
            },
          ),
        ],
      ),
    );
  }

  startBatchBarcodeScanner() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }
    try {
      final additionalParameters = BarcodeAdditionalParameters(
          minimumTextLength: 3,
          maximumTextLength: 45,
          minimum1DBarcodesQuietZone: 10,
          codeDensity: CodeDensity.HIGH);
      var config = BatchBarcodeScannerConfiguration(
        barcodeFormatter: (item) async {
          Random random = Random();
          int randomNumber = random.nextInt(4) + 2;
          await Future.delayed(Duration(seconds: randomNumber));
          return BarcodeFormattedData(
              title: item.barcodeFormat.toString(),
              subtitle: item.text ?? "" "custom string");
        },
        topBarBackgroundColor: Colors.blueAccent,
        topBarButtonsColor: Colors.white70,
        cameraOverlayColor: Colors.black26,
        finderLineColor: Colors.red,
        finderTextHintColor: Colors.cyanAccent,
        cancelButtonTitle: "Cancel",
        enableCameraButtonTitle: "camera enable",
        enableCameraExplanationText: "explanation text",
        finderTextHint:
            "Please align any supported barcode in the frame to scan it.",
        // clearButtonTitle: "CCCClear",
        // submitButtonTitle: "Submitt",
        barcodesCountText: "%d codes",
        fetchingStateText: "might be not needed",
        noBarcodesTitle: "nothing to see here",
        barcodesCountTextColor: Colors.purple,
        finderAspectRatio: scanbot.AspectRatio(width: 2, height: 1),
        topBarButtonsInactiveColor: Colors.orange,
        detailsActionColor: Colors.yellow,
        detailsBackgroundColor: Colors.amber,
        detailsPrimaryColor: Colors.yellowAccent,
        finderLineWidth: 7,
        successBeepEnabled: true,
        // flashEnabled: true,
        orientationLockMode: OrientationLockMode.NONE,
        // cameraZoomFactor: 1,
        additionalParameters: additionalParameters,
        barcodeFormats: barcodeFormatsRepository.selectedFormats.toList(),
        cancelButtonHidden: false,
        overlayConfiguration: SelectionOverlayConfiguration(
            overlayEnabled: true, automaticSelectionEnabled: true),
        //useButtonsAllCaps: true
      );

      var result = await ScanbotBarcodeSdk.startBatchBarcodeScanner(config);
      if (result.operationResult == OperationResult.SUCCESS) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => BarcodesResultPreviewWidget(result)),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  startBarcodeScanner({bool shouldSnapImage = false}) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }
    final additionalParameters = BarcodeAdditionalParameters(
      minimumTextLength: 3,
      maximumTextLength: 45,
      minimum1DBarcodesQuietZone: 10,
      codeDensity: CodeDensity.HIGH,
    );
    var config = BarcodeScannerConfiguration(
      barcodeImageGenerationType: shouldSnapImage
          ? BarcodeImageGenerationType.VIDEO_FRAME
          : BarcodeImageGenerationType.NONE,
      topBarBackgroundColor: Colors.blueAccent,
      finderLineColor: Colors.red,
      cancelButtonTitle: "Cancel",
      finderTextHint:
          "Please align any supported barcode in the frame to scan it.",
      successBeepEnabled: true,

      // cameraZoomFactor: 1,
      additionalParameters: additionalParameters,
      barcodeFormats: barcodeFormatsRepository.selectedFormats.toList(),
      // see further customization configs ...
      orientationLockMode: OrientationLockMode.NONE,
      //useButtonsAllCaps: true,
    );

    try {
      var result = await ScanbotBarcodeSdk.startBarcodeScanner(config);

      if (result.operationResult == OperationResult.SUCCESS) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => BarcodesResultPreviewWidget(result)),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  pickImageAndDetect() async {
    try {
      var response = await ScanbotImagePickerFlutter.pickImageAsync();
      var uriPath = response.uri ?? "";
      if (uriPath.isEmpty) {
        ValidateUriError(response);
        return;
      }

      if (!await checkLicenseStatus(context)) {
        return;
      }

      var result = await ScanbotBarcodeSdk.detectBarcodesOnImage(
        Uri.parse(uriPath),
        barcodeFormats: barcodeFormatsRepository.selectedFormats.toList(),
        additionalParameters:
            BarcodeAdditionalParameters(codeDensity: CodeDensity.HIGH),
      );

      if (result.operationResult == OperationResult.SUCCESS) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => BarcodesResultPreviewWidget(result)),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _startBarcodeCustomUIScanner() async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const BarcodeScannerWidget()),
    );
    if (result is BarcodeScanningResult) {
      await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => BarcodesResultPreviewWidget(result)),
      );
    }
  }
  Future<void> _startBarcodeClientUIScanner() async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ScanbotScannerScreen()),
    );
    if (result is BarcodeScanningResult) {
      await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => BarcodesResultPreviewWidget(result)),
      );
    }
  }

  cleanupStorage() async {
    try {
      await ScanbotBarcodeSdk.cleanupBarcodeStorage();
      showAlertDialog(context, "Barcode image storage was cleaned",
          title: "Info");
    } catch (e) {
      print(e);
    }
  }

  showLicenseStatus() async {
    try {
      var result = await ScanbotBarcodeSdk.getLicenseStatus();
      showAlertDialog(context, jsonEncode(result), title: "License Status");
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkLicenseStatus(BuildContext context) async {
    var result = await ScanbotBarcodeSdk.getLicenseStatus();
    if (result.isLicenseValid) {
      return true;
    }
    await showAlertDialog(
        context, 'Scanbot SDK trial period or (trial) license has expired.',
        title: 'Info');
    return false;
  }

  /// Check for error message and display accordingly.
  void ValidateUriError(ImagePickerResponse response) {
    String message = response.message ?? "";
    showAlertDialog(context, message);
  }
}

Future<void> showAlertDialog(BuildContext context, String textToShow,
    {String? title}) async {
  Widget text = SimpleDialogOption(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(textToShow),
    ),
  );

  // set up the SimpleDialog
  AlertDialog dialog = AlertDialog(
    title: title != null ? Text(title) : null,
    content: text,
    contentPadding: const EdgeInsets.all(0),
    actions: <Widget>[
      TextButton(
        child: const Text('OK'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );

  // show the dialog
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return dialog;
    },
  );
}
