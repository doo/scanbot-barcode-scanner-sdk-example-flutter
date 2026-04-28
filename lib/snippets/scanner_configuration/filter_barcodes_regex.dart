import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

BarcodeScannerConfiguration filterBarcodesRegex() {
  final configs = <BarcodeFormatConfigurationBase>[];

  final baseFormatConfig = BarcodeFormatCommonConfiguration(
    // You can set a regex filter here to limit the barcodes that will be scanned
    // Here is an example of a regex that matches only barcodes that contain numbers from 0 to 5
    regexFilter: r'\b[0-5]+\b',
    minimum1DQuietZoneSize: 10,
    stripCheckDigits: false,
    minimumTextLength: 0,
    maximumTextLength: 0,
    gs1Handling: Gs1Handling.PARSE,
    strictMode: true,
    formats: BarcodeFormats.common,
    addAdditionalQuietZone: false,
  );

  configs.add(baseFormatConfig);

  final barcodeScannerConfiguration = BarcodeScannerConfiguration(
    barcodeFormatConfigurations: configs,
    engineMode: BarcodeScannerEngineMode.NEXT_GEN,
  );

  return barcodeScannerConfiguration;
}
