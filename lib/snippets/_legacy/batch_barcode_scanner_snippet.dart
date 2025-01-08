import 'dart:math';

import 'package:barcode_scanner/scanbot_barcode_sdk.dart';
import 'package:barcode_scanner/scanbot_barcode_sdk.dart' as scanbot_sdk;

BatchBarcodeScannerConfiguration batchBarcodeConfigurationSnippet(List<BarcodeFormat>? barcodeFormats) {
  return BatchBarcodeScannerConfiguration(
    barcodeFormatter: _barcodeFormatter,
    cancelButtonTitle: 'Cancel',
    enableCameraButtonTitle: 'Camera Enable',
    enableCameraExplanationText: 'Explanation text',
    finderTextHint:
    'Please align any supported barcode in the frame to scan it.',
    // Uncomment if needed to provide clear button text
    // clearButtonTitle: "CCCClear",
    // Uncomment if needed to provide submit button text
    // submitButtonTitle: "Submitt",
    barcodesCountText: '%d codes',
    fetchingStateText: 'Might be not needed',
    noBarcodesTitle: 'Nothing to see here',
    finderAspectRatio: scanbot_sdk.AspectRatio(width: 3, height: 2), // Aspect ratio of the scanning frame
    finderLineWidth: 7,
    successBeepEnabled: true,
    orientationLockMode: OrientationLockMode.PORTRAIT,
    barcodeFormats: barcodeFormats ?? PredefinedBarcodes.allBarcodeTypes(),
    cancelButtonHidden: false,
      // Uncomment and set zoom factor if needed
    // cameraZoomFactor: 0.5
      // Uncomment to set additional barcode parameters
    // additionalParameters: BarcodeAdditionalParameters(
    //       gs1HandlingMode: Gs1HandlingMode.VALIDATE_FULL,
    //       minimumTextLength: 10,
    //       maximumTextLength: 11,
    //       minimum1DBarcodesQuietZone: 10,
    //     )
  );
}

/// Formats the barcode data with a random delay
Future<BarcodeFormattedData> _barcodeFormatter(BarcodeItem item) async {
  final random = Random();
  final randomNumber = random.nextInt(4) + 2;
  await Future.delayed(Duration(seconds: randomNumber));

  return BarcodeFormattedData(
    title: item.barcodeFormat.toString(),
    subtitle: '${item.text ?? ''} custom string',
  );
}