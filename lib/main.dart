import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:barcode_scanner/scanbot_barcode_sdk.dart';
import 'package:barcode_scanner/scanbot_barcode_sdk.dart' as scanbot;
import 'package:barcode_scanner/scanbot_barcode_sdk_v2.dart' as scanbotV2;

import 'package:scanbot_barcode_sdk_example/ui/barcode_formats/barcode_formats_repo.dart';
import 'package:scanbot_barcode_sdk_example/ui/barcode_formats/barcodes_formats_selector.dart';
import 'package:scanbot_barcode_sdk_example/ui/ready_to_use_ui_legacy/barcodes_preview_widget.dart';
import 'package:scanbot_barcode_sdk_example/ui/classic_components/barcode_custom_ui.dart';
import 'package:scanbot_barcode_sdk_example/ui/menu_items.dart';
import 'package:scanbot_image_picker/models/image_picker_response.dart';
import 'package:scanbot_image_picker/scanbot_image_picker_flutter.dart';

import 'ui/ready_to_use_ui/barcodes_preview_widget_v2.dart';

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

Future<void> _initScanbotSdk() async {
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
            title: 'Scan Barcode (Classic Component)',
            onTap: () {
              _startBarcodeCustomUIScanner();
            },
          ),
          MenuItemWidget(
            title: "Single Scan with confirmation dialog (RTU v2.0)",
            onTap: () {
              startSingleScanV2();
            },
          ),
          MenuItemWidget(
            title: "Multiple Scan (RTU v2.0)",
            onTap: () {
              startMultipleScanV2();
            },
          ),
          MenuItemWidget(
            title: "Find and Pick (RTU v2.0)",
            onTap: () {
              startFindAndPickScanV2();
            },
          ),
          MenuItemWidget(
            title: "AROverlay (RTU v2.0)",
            onTap: () {
              startAROverlayScanV2();
            },
          ),
          MenuItemWidget(
            title: "Info Mapping (RTU v2.0)",
            onTap: () {
              startInfoMappingScanV2();
            },
          ),
          MenuItemWidget(
            title: "Scan Barcode",
            onTap: () {
              startBarcodeScanner();
            },
          ),
          MenuItemWidget(
            title: "Scan Barcode with Image Result",
            onTap: () {
              startBarcodeScanner(shouldSnapImage: true);
            },
          ),
          MenuItemWidget(
            title: "Scan Batch Barcodes",
            onTap: () {
              startBatchBarcodeScanner();
            },
          ),
          MenuItemWidget(
            title: "Pick Image from Gallery",
            onTap: () {
              pickImageAndDetect();
            },
          ),
          MenuItemWidget(
            title: "Cleanup Storage",
            onTap: () {
              cleanupStorage();
            },
          ),
          MenuItemWidget(
            title: "Set Accepted Barcodes",
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        BarcodesFormatSelectorWidget(barcodeFormatsRepository)),
              );
            },
          ),
          MenuItemWidget(
            title: "Check License Status",
            onTap: () {
              showLicenseStatus();
            },
          ),
          MenuItemWidget(
            title: "Licenses info",
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

  startSingleScanV2() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      // Create the default configuration object.
      var configuration = scanbotV2.BarcodeScannerConfiguration();

      // Initialize the single-scan use case.
      var singleUsecase = scanbotV2.SingleScanningMode();

      // Enable and configure the confirmation sheet.
      singleUsecase.confirmationSheetEnabled = true;
      singleUsecase.sheetColor = ScanbotColor("#FFFFFF");

      // Hide/unhide the barcode image.
      singleUsecase.barcodeImageVisible = true;

      // Configure the barcode title of the confirmation sheet.
      singleUsecase.barcodeTitle.visible = true;
      singleUsecase.barcodeTitle.color = ScanbotColor("#000000");

      // Configure the barcode subtitle of the confirmation sheet.
      singleUsecase.barcodeSubtitle.visible = true;
      singleUsecase.barcodeSubtitle.color = ScanbotColor("#000000");

      // Configure the cancel button of the confirmation sheet.
      singleUsecase.cancelButton.text = "Close";
      singleUsecase.cancelButton.foreground.color = ScanbotColor("#C8193C");
      singleUsecase.cancelButton.background.fillColor =
          ScanbotColor("#00000000");

      // Configure the submit button of the confirmation sheet.
      singleUsecase.submitButton.text = "Submit";
      singleUsecase.submitButton.foreground.color = ScanbotColor("#FFFFFF");
      singleUsecase.submitButton.background.fillColor = ScanbotColor("#C8193C");

      // Set the configured use case.
      configuration.useCase = singleUsecase;

      // Create and set an array of accepted barcode formats.
      // configuration.recognizerConfiguration.barcodeFormats = [
      //   scanbotV2.BarcodeFormat.AZTEC,
      //   scanbotV2.BarcodeFormat.PDF_417,
      //   scanbotV2.BarcodeFormat.QR_CODE,
      //   scanbotV2.BarcodeFormat.MICRO_QR_CODE,
      //   scanbotV2.BarcodeFormat.MICRO_PDF_417,
      //   scanbotV2.BarcodeFormat.ROYAL_MAIL,
      // ];

      var result =
          await scanbotV2.ScanbotBarcodeSdk.startBarcodeScanner(configuration);

      if (result.operationResult == OperationResult.SUCCESS) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  BarcodesResultPreviewWidgetV2(result.value!)),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  startMultipleScanV2() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      // Create the default configuration object.
      var configuration = scanbotV2.BarcodeScannerConfiguration();

      // Initialize the single-scan use case.
      var multiUsecase = scanbotV2.MultipleScanningMode();

      // Set the counting repeat delay.
      multiUsecase.countingRepeatDelay = 1000;

      // Set the counting mode.
      multiUsecase.mode = scanbotV2.MultipleBarcodesScanningMode.COUNTING;

      // Set the sheet mode of the barcodes preview.
      multiUsecase.sheet.mode = scanbotV2.SheetMode.COLLAPSED_SHEET;

      // Set the height of the collapsed sheet.
      multiUsecase.sheet.collapsedVisibleHeight =
          scanbotV2.CollapsedVisibleHeight.LARGE;

      // Enable manual count change.
      multiUsecase.sheetContent.manualCountChangeEnabled = true;

      // Configure the submit button.
      multiUsecase.sheetContent.submitButton.text = "Submit";
      multiUsecase.sheetContent.submitButton.foreground.color =
          ScanbotColor("#000000");

      // Set the configured use case.
      configuration.useCase = multiUsecase;

      // Create and set an array of accepted barcode formats.
      // configuration.recognizerConfiguration.barcodeFormats = [
      //   scanbotV2.BarcodeFormat.AZTEC,
      //   scanbotV2.BarcodeFormat.PDF_417,
      //   scanbotV2.BarcodeFormat.QR_CODE,
      //   scanbotV2.BarcodeFormat.MICRO_QR_CODE,
      //   scanbotV2.BarcodeFormat.MICRO_PDF_417,
      //   scanbotV2.BarcodeFormat.ROYAL_MAIL,
      // ];

      var result =
          await scanbotV2.ScanbotBarcodeSdk.startBarcodeScanner(configuration);

      if (result.operationResult == OperationResult.SUCCESS) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  BarcodesResultPreviewWidgetV2(result.value!)),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  startFindAndPickScanV2() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      // Create the default configuration object.
      var configuration = scanbotV2.BarcodeScannerConfiguration();

      // Initialize the single-scan use case.
      var usecase = scanbotV2.FindAndPickScanningMode();

      // Set the configured use case.
      configuration.useCase = usecase;

      // Configure AR Overlay.
      usecase.arOverlay.visible = true;

      // Enable/Disable the automatic selection.
      usecase.arOverlay.automaticSelectionEnabled = false;

      // Enable/Disable the swipe to delete.
      usecase.sheetContent.swipeToDelete.enabled = true;

      // Enable/Disable allow partial scan.
      usecase.allowPartialScan = true;

      // Set the expected barcodes.
      usecase.expectedBarcodes = [
        scanbotV2.ExpectedBarcode(
            barcodeValue: "123456", title: "", image: "Image_URL", count: 4),
        scanbotV2.ExpectedBarcode(
            barcodeValue: "SCANBOT", title: "", image: "Image_URL", count: 3)
      ];

      // Set the configured usecase.
      configuration.useCase = usecase;

      var result =
          await scanbotV2.ScanbotBarcodeSdk.startBarcodeScanner(configuration);

      if (result.operationResult == OperationResult.SUCCESS) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  BarcodesResultPreviewWidgetV2(result.value!)),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  startAROverlayScanV2() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      // Create the default configuration object.
      var configuration = scanbotV2.BarcodeScannerConfiguration();

      // Configure the usecase.
      var usecase = scanbotV2.MultipleScanningMode();
      usecase.mode = scanbotV2.MultipleBarcodesScanningMode.UNIQUE;
      usecase.sheet.mode = scanbotV2.SheetMode.COLLAPSED_SHEET;
      usecase.sheet.collapsedVisibleHeight =
          scanbotV2.CollapsedVisibleHeight.SMALL;

      // Configure AR Overlay.
      usecase.arOverlay.visible = true;
      usecase.arOverlay.automaticSelectionEnabled = false;

      // Set the configured usecase.
      configuration.useCase = usecase;

      // Create and set an array of accepted barcode formats.
      // configuration.recognizerConfiguration.barcodeFormats = [
      //   scanbotV2.BarcodeFormat.AZTEC,
      //   scanbotV2.BarcodeFormat.PDF_417,
      //   scanbotV2.BarcodeFormat.QR_CODE,
      //   scanbotV2.BarcodeFormat.MICRO_QR_CODE,
      //   scanbotV2.BarcodeFormat.MICRO_PDF_417,
      //   scanbotV2.BarcodeFormat.ROYAL_MAIL,
      // ];

      // Set the configured usecase.
      configuration.useCase = usecase;

      var result =
          await scanbotV2.ScanbotBarcodeSdk.startBarcodeScanner(configuration);

      if (result.operationResult == OperationResult.SUCCESS) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  BarcodesResultPreviewWidgetV2(result.value!)),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  startInfoMappingScanV2() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      var configuration = scanbotV2.BarcodeScannerConfiguration();
      var singleScanningMode = scanbotV2.SingleScanningMode();

      // Enable the confirmation sheet.
      singleScanningMode.confirmationSheetEnabled = true;

      // Set the item mapper.
      singleScanningMode.barcodeInfoMapping.barcodeItemMapper =
          (item, onResult, onError) async {
        //return result
        onResult(scanbotV2.BarcodeMappedData(
            title: "Title", subtitle: "Subtitle", barcodeImage: "Image_URL"));

        // if need to show error
        // onError();
      };

      // Retrieve the instance of the error state from the use case object.
      var errorState = singleScanningMode.barcodeInfoMapping.errorState;

      // Configure the title.
      errorState.title.text = "Error_Title";
      errorState.title.color = ScanbotColor("#000000");

      // Configure the subtitle.
      errorState.subtitle.text = "Error_Subtitle";
      errorState.subtitle.color = ScanbotColor("#000000");

      // Configure the cancel button.
      errorState.cancelButton.text = "Cancel";
      errorState.cancelButton.foreground.color = ScanbotColor("#C8193C");

      // Configure the retry button.
      errorState.retryButton.text = "Retry";
      errorState.retryButton.foreground.iconVisible = true;
      errorState.retryButton.foreground.color = ScanbotColor("#FFFFFF");
      errorState.retryButton.background.fillColor = ScanbotColor("#C8193C");

      // Set the configured error state.
      singleScanningMode.barcodeInfoMapping.errorState = errorState;

      // Set the configured use case.
      configuration.useCase = singleScanningMode;

      // Create and set an array of accepted barcode formats.
      // configuration.recognizerConfiguration.barcodeFormats = [
      //   scanbotV2.BarcodeFormat.AZTEC,
      //   scanbotV2.BarcodeFormat.PDF_417,
      //   scanbotV2.BarcodeFormat.QR_CODE,
      //   scanbotV2.BarcodeFormat.MICRO_QR_CODE,
      //   scanbotV2.BarcodeFormat.MICRO_PDF_417,
      //   scanbotV2.BarcodeFormat.ROYAL_MAIL,
      // ];

      var result =
          await scanbotV2.ScanbotBarcodeSdk.startBarcodeScanner(configuration);
      if (result.operationResult == OperationResult.SUCCESS) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  BarcodesResultPreviewWidgetV2(result.value!)),
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
      showAlertDialog(context, "${result.status}", title: "License Status");
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
