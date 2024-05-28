import 'package:barcode_scanner/json/common_generic_document.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scanner/scanbot_barcode_sdk_v2.dart';

class GenericDocumentHelper {
  static Widget wrappedGenericDocumentField(GenericDocument? genericDocument) {
    if (genericDocument == null) return Container();

    GenericDocumentWrapper documentWrapper =
        GenericDocumentWrapper.wrap(genericDocument!);

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
