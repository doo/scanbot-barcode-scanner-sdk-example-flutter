import 'package:barcode_scanner/barcode_sdk.dart';

Future<List<dynamic>> handleScanningResultWithDataParsers() async {
  // Start the barcode RTU UI with default configuration
  final scanningResult = await ScanbotBarcodeSdk.barcode.startScanner(
    BarcodeScannerScreenConfiguration(),
  );

  // Check if the status returned is ok and that the data is present
  if (scanningResult.status == OperationStatus.OK &&
      scanningResult.data != null) {
    final items = scanningResult.data!.items;
    final parsedData = <dynamic>[];

    // Loop through the scanned barcode items and extract the desired barcode data
    for (final item in items) {
      final genericDocument = item.barcode.extractedDocument;
      if (genericDocument == null) continue;

      final typeName = genericDocument.type.name;

      switch (typeName) {
        case BoardingPass.DOCUMENT_TYPE:
          parsedData
              .add(BoardingPass(genericDocument).electronicTicketIndicator);
          break;

        case SwissQR.DOCUMENT_TYPE:
          parsedData.add(SwissQR(genericDocument).iban);
          break;

        case DEMedicalPlan.DOCUMENT_TYPE:
          parsedData.add(DEMedicalPlan(genericDocument).doctor.issuerName);
          break;

        case IDCardPDF417.DOCUMENT_TYPE:
          parsedData.add(IDCardPDF417(genericDocument).dateExpired);
          break;

        case GS1.DOCUMENT_TYPE:
          final gs1Elements = GS1(genericDocument).elements;
          parsedData.add(gs1Elements.isNotEmpty
              ? gs1Elements.first.applicationIdentifier
              : null);
          break;

        case SEPA.DOCUMENT_TYPE:
          parsedData.add(SEPA(genericDocument).receiverIBAN);
          break;

        case MedicalCertificate.DOCUMENT_TYPE:
          parsedData.add(MedicalCertificate(genericDocument).doctorNumber);
          break;

        case VCard.DOCUMENT_TYPE:
          parsedData.add(VCard(genericDocument).formattedName?.rawValue);
          break;

        case AAMVA.DOCUMENT_TYPE:
          parsedData.add(AAMVA(genericDocument).issuerIdentificationNumber);
          break;

        case HIBC.DOCUMENT_TYPE:
          parsedData.add(HIBC(genericDocument).labelerIdentificationCode);
          break;
      }
    }

    return parsedData;
  }

  return [];
}
