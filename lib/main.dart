import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:barcode_scanner/barcode_scanning_data.dart';
import 'package:barcode_scanner/common_data.dart';
import 'package:barcode_scanner/scanbot_barcode_sdk.dart';
import 'package:barcode_scanner/scanbot_sdk_models.dart';

import 'package:scanbot_barcode_sdk_example/ui/barcode_formats_repo.dart';
import 'package:scanbot_barcode_sdk_example/ui/barcodes_formats_selector.dart';
import 'package:scanbot_barcode_sdk_example/ui/barcodes_preview_widget.dart';
import 'package:scanbot_barcode_sdk_example/ui/menu_items.dart';

void main() => runApp(MyApp());

// TODO Add the Scanbot Barcode Scanner SDK license key here.
// Please note: The Scanbot Barcode Scanner SDK will run without a license key for one minute per session!
// After the trial period is over all Barcode SDK functions as well as the UI components will stop working.
// You can get an unrestricted "no-strings-attached" 30 day trial license key for free.
// Please submit the trial license form (https://scanbot.io/sdk/trial.html) on our website by using
// the app identifier "io.scanbot.example.sdk.barcode.flutter" of this example app or of your app.
const BARCODE_SDK_LICENSE_KEY = '';

_initScanbotSdk() async {
  Directory? storageDirectory;
  if (Platform.isAndroid) {
    storageDirectory = await getExternalStorageDirectory();
  }
  if (Platform.isIOS) {
    storageDirectory = await getApplicationDocumentsDirectory();
  }

  var config = ScanbotSdkConfig(
      licenseKey: BARCODE_SDK_LICENSE_KEY,
      loggingEnabled: true, // Consider disabling logging in production builds for security and performance reasons.
      storageBaseDirectory: "${storageDirectory?.path}/custom-barcode-sdk-storage"
  );

  try {
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
    return MaterialApp(home: MainPageWidget());
  }
}

class MainPageWidget extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPageWidget> {
  BarcodeFormatsRepository barcodeFormatsRepository =
      BarcodeFormatsRepository();

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
        ],
      ),
    );
  }
  startBatchBarcodeScanner() async {
    try {
      //var config = BarcodeScannerConfiguration(); // testing default configs
      var config = BatchBarcodeScannerConfiguration(
          barcodeFormatter: (item) async {
            Random random = new Random();
            int randomNumber = random.nextInt(4) + 2;
            await new Future.delayed(Duration(seconds: randomNumber));
            return BarcodeFormattedData(
                title: item.barcodeFormat.toString(), subtitle: item.text);
          },
          topBarBackgroundColor: Colors.blueAccent,
          topBarButtonsColor: Colors.white70,
          cameraOverlayColor: Colors.black26,
          finderLineColor: Colors.red,
          finderTextHintColor: Colors.cyanAccent,
          cancelButtonTitle: "Cancel",
          enableCameraButtonTitle: "camera enable",
          enableCameraExplanationText: "explanation text",
          finderTextHint: "Please align any supported barcode in the frame to scan it.",
          // clearButtonTitle: "CCCClear",
          // submitButtonTitle: "Submitt",
          barcodesCountText: "%d codes",
          fetchingStateText: "might be not needed",
          noBarcodesTitle: "nothing to see here",
          barcodesCountTextColor: Colors.purple,
          finderAspectRatio: FinderAspectRatio(width: 2, height: 3),
          topBarButtonsInactiveColor: Colors.orange,
          detailsActionColor: Colors.yellow,
          detailsBackgroundColor: Colors.amber,
          detailsPrimaryColor: Colors.yellowAccent,
          finderLineWidth: 7,
          successBeepEnabled: true,
          // flashEnabled: true,
          orientationLockMode: CameraOrientationMode.PORTRAIT,
          barcodeFormats: barcodeFormatsRepository.selectedFormats.toList(),
          cancelButtonHidden: false
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
    if (!await checkLicenseStatus(context)) { return; }

    var config = BarcodeScannerConfiguration(
      barcodeImageGenerationType: shouldSnapImage
          ? BarcodeImageGenerationType.VIDEO_FRAME
          : BarcodeImageGenerationType.NONE,
      topBarBackgroundColor: Colors.blueAccent,
      finderLineColor: Colors.red,
      cancelButtonTitle: "Cancel",
      finderTextHint: "Please align any supported barcode in the frame to scan it.",
      successBeepEnabled: true,
      barcodeFormats: barcodeFormatsRepository.selectedFormats.toList(),
      // see further customization configs ...
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
      var image = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 90);
      if (image == null) { return; }

      if (!await checkLicenseStatus(context)) { return; }

      var result = await ScanbotBarcodeSdk.detectFromImageFile(
          Uri.parse(image.path), barcodeFormatsRepository.selectedFormats.toList(), true);

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

  cleanupStorage() async {
    try {
      await ScanbotBarcodeSdk.cleanupBarcodeStorage();
      showAlertDialog(context, "Barcode image storage was cleaned", title: "Info");
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
    await showAlertDialog(context, 'Scanbot SDK trial period or (trial) license has expired.', title: 'Info');
    return false;
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
    contentPadding: EdgeInsets.all(0),
    actions: <Widget>[
      FlatButton(
        child: Text('OK'),
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
