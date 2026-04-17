import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

BarcodeScannerConfiguration configureDocumentParsers() {
  final barcodeScannerConfiguration = BarcodeScannerConfiguration(
    barcodeFormatConfigurations: [
      BarcodeFormatCommonConfiguration(),
    ],
    // Example of adding specific formats for parsed documents
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
    // Set to true if you want to only accept barcodes with parsed documents
    onlyAcceptDocuments: true,
    engineMode: BarcodeScannerEngineMode.NEXT_GEN,
  );

  return barcodeScannerConfiguration;
}
