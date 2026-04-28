import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

BarcodeFormatCommonConfiguration filterGroupBarcodes() {
  final barcodeFormatCommonConfiguration = BarcodeFormatCommonConfiguration(
    regexFilter: '',
    minimum1DQuietZoneSize: 10,
    stripCheckDigits: false,
    minimumTextLength: 0,
    maximumTextLength: 0,
    gs1Handling: Gs1Handling.PARSE,
    strictMode: true,
    formats: BarcodeFormats.common,
    addAdditionalQuietZone: false,
  );

  return barcodeFormatCommonConfiguration;
}
