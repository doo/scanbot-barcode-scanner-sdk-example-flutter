import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

/// Returns a configured [BarcodeScannerConfiguration] you can pass to your scanner.
BarcodeScannerConfiguration filterIndividualBarcodes() {
  final configs = <BarcodeFormatConfigurationBase>[];

  final baseConfig = BarcodeFormatCommonConfiguration(
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
  configs.add(baseConfig);

  // Add individual configurations for specific barcode formats
  final australiaPostConfig = BarcodeFormatAustraliaPostConfiguration(
    regexFilter: '',
    australiaPostCustomerFormat: AustraliaPostCustomerFormat.ALPHA_NUMERIC,
  );
  configs.add(australiaPostConfig);

  final msiPlesseyConfig = BarcodeFormatMsiPlesseyConfiguration(
    regexFilter: '',
    minimum1DQuietZoneSize: 10,
    stripCheckDigits: false,
    minimumTextLength: 0,
    maximumTextLength: 0,
    checksumAlgorithms: const [MsiPlesseyChecksumAlgorithm.MOD_10],
  );
  configs.add(msiPlesseyConfig);

  final code11Config = BarcodeFormatCode11Configuration(
    regexFilter: '',
    minimum1DQuietZoneSize: 10,
    stripCheckDigits: false,
    minimumTextLength: 0,
    maximumTextLength: 0,
    checksum: true,
  );
  configs.add(code11Config);

  final code2Of5Config = BarcodeFormatCode2Of5Configuration(
    regexFilter: '',
    minimum1DQuietZoneSize: 10,
    stripCheckDigits: false,
    minimumTextLength: 0,
    maximumTextLength: 0,
    iata2of5: true,
    code25: false,
    industrial2of5: false,
    useIATA2OF5Checksum: true,
  );
  configs.add(code2Of5Config);

  // Set the configurations to the barcode scanner
  final barcodeScannerConfiguration = BarcodeScannerConfiguration(
    barcodeFormatConfigurations: configs,
    extractedDocumentFormats: const [
      BarcodeDocumentFormat.AAMVA,
      BarcodeDocumentFormat.BOARDING_PASS,
      BarcodeDocumentFormat.DE_MEDICAL_PLAN,
      BarcodeDocumentFormat.MEDICAL_CERTIFICATE,
      BarcodeDocumentFormat.ID_CARD_PDF_417,
      BarcodeDocumentFormat.SEPA,
      BarcodeDocumentFormat.SWISS_QR,
      BarcodeDocumentFormat.VCARD,
      BarcodeDocumentFormat.GS1,
      BarcodeDocumentFormat.HIBC,
    ],
    onlyAcceptDocuments: false,
    engineMode: BarcodeScannerEngineMode.NEXT_GEN,
    returnBarcodeImage: true,
  );

  return barcodeScannerConfiguration;
}
