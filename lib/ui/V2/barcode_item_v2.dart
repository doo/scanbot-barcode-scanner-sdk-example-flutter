import 'package:barcode_scanner/json/common_generic_document.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scanner/scanbot_barcode_sdk_v2.dart';

class BarcodeItemWidgetV2 extends StatelessWidget {
  final BarcodeItem item;

  BarcodeItemWidgetV2(this.item);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              barcodeFormatEnumMap[item.type]!,
              style: const TextStyle(inherit: true, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(item.text ?? "",
                style: const TextStyle(inherit: true, color: Colors.black)),
          ),
          wrappedGenericDocumentField(),
        ],
      ),
    );
  }

  Widget wrappedGenericDocumentField() {
    if (item.parsedDocument == null) return Container();

    GenericDocumentWrapper documentWrapper =
        GenericDocumentWrapper.wrap(item.parsedDocument!);

    TextFieldWrapper? wrappedGenericFieldValue;

    switch (documentWrapper.document.type.name) {
      case BoardingPass.DOCUMENT_TYPE:
        wrappedGenericFieldValue =
            (documentWrapper as BoardingPass).ElectronicTicket;
        break;
      case SwissQR.DOCUMENT_TYPE:
        wrappedGenericFieldValue = (documentWrapper as SwissQR).IBAN;
        break;

      case DEMedicalPlan.DOCUMENT_TYPE:
        wrappedGenericFieldValue =
            (documentWrapper as DEMedicalPlan).Doctor.IssuerName;
        break;

      case IDCardPDF417.DOCUMENT_TYPE:
        wrappedGenericFieldValue =
            (documentWrapper as IDCardPDF417).DateExpired;
        break;

      case GS1.DOCUMENT_TYPE:
        wrappedGenericFieldValue =
            (documentWrapper as GS1).Elements?.first.ApplicationIdentifier;
        break;

      case SEPA.DOCUMENT_TYPE:
        (documentWrapper as SEPA).ReceiverIBAN;
        break;

      case MedicalCertificate.DOCUMENT_TYPE:
        (documentWrapper as MedicalCertificate).DoctorNumber;
        break;

      case VCard.DOCUMENT_TYPE:
        (documentWrapper as VCard).FirstName;
        break;

      case AAMVA.DOCUMENT_TYPE:
        (documentWrapper as AAMVA).DriverLicense;
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
          "Document: ${documentWrapper.document.type.name} \nField: ${wrappedGenericFieldValue?.type.name} \nValue: ${wrappedGenericFieldValue?.value?.text}",
          style: const TextStyle(inherit: true, color: Colors.black)),
    );
  }
}

const barcodeFormatEnumMap = {
  BarcodeFormat.AZTEC: 'AZTEC',
  BarcodeFormat.CODABAR: 'CODABAR',
  BarcodeFormat.CODE_25: 'CODE_25',
  BarcodeFormat.CODE_39: 'CODE_39',
  BarcodeFormat.CODE_93: 'CODE_93',
  BarcodeFormat.CODE_128: 'CODE_128',
  BarcodeFormat.DATA_MATRIX: 'DATA_MATRIX',
  BarcodeFormat.EAN_8: 'EAN_8',
  BarcodeFormat.EAN_13: 'EAN_13',
  BarcodeFormat.ITF: 'ITF',
  BarcodeFormat.PDF_417: 'PDF_417',
  BarcodeFormat.QR_CODE: 'QR_CODE',
  BarcodeFormat.MICRO_QR_CODE: 'MICRO_QR_CODE',
  BarcodeFormat.DATABAR: 'DATABAR',
  BarcodeFormat.DATABAR_EXPANDED: 'DATABAR_EXPANDED',
  BarcodeFormat.UPC_A: 'UPC_A',
  BarcodeFormat.UPC_E: 'UPC_E',
  BarcodeFormat.MSI_PLESSEY: 'MSI_PLESSEY',
  BarcodeFormat.IATA_2_OF_5: 'IATA_2_OF_5',
  BarcodeFormat.INDUSTRIAL_2_OF_5: 'INDUSTRIAL_2_OF_5',
  BarcodeFormat.USPS_INTELLIGENT_MAIL: 'USPS_INTELLIGENT_MAIL',
  BarcodeFormat.ROYAL_MAIL: 'ROYAL_MAIL',
  BarcodeFormat.ROYAL_TNT_POST: 'ROYAL_TNT_POST',
  BarcodeFormat.JAPAN_POST: 'JAPAN_POST',
  BarcodeFormat.AUSTRALIA_POST: 'AUSTRALIA_POST',
  BarcodeFormat.DATABAR_LIMITED: 'DATABAR_LIMITED',
  BarcodeFormat.GS1_COMPOSITE: 'GS1_COMPOSITE',
  BarcodeFormat.MICRO_PDF_417: 'MICRO_PDF_417'
};
