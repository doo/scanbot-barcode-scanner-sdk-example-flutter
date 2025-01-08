import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

BarcodeScannerConfiguration QROnlyBarcodeConfigurationSnippet() {
  return BarcodeScannerConfiguration(
    barcodeFormats: [BarcodeFormat.QR_CODE],
    finderTextHint: 'Please align a QR code in the frame to scan it.',
      // additionalParameters: BarcodeAdditionalParameters(
      //     gs1HandlingMode: Gs1HandlingMode.VALIDATE_FULL,
      //     minimumTextLength: 10,
      //     maximumTextLength: 11,
      //     minimum1DBarcodesQuietZone: 10,
      //   )
    // ...
  );
}