import 'package:flutter/material.dart';
import 'package:barcode_scanner/scanbot_barcode_sdk_v2.dart';

class GenericDocumentHelper {
  static Widget wrappedGenericDocumentField(GenericDocument? genericDocument) {
    if (genericDocument == null) return Container();

    TextFieldWrapper? wrappedGenericFieldValue;

    switch (genericDocument.type?.name) {
      case BoardingPass.DOCUMENT_TYPE:
        wrappedGenericFieldValue =
            BoardingPass(genericDocument).ElectronicTicket;
        break;
      case SwissQR.DOCUMENT_TYPE:
        wrappedGenericFieldValue = SwissQR(genericDocument).IBAN;
        break;

      case DEMedicalPlan.DOCUMENT_TYPE:
        wrappedGenericFieldValue =
            DEMedicalPlan(genericDocument).Doctor.IssuerName;
        break;

      case IDCardPDF417.DOCUMENT_TYPE:
        wrappedGenericFieldValue = IDCardPDF417(genericDocument).DateExpired;
        break;

      case GS1.DOCUMENT_TYPE:
        wrappedGenericFieldValue =
            GS1(genericDocument).Elements?.first.ApplicationIdentifier;
        break;

      case SEPA.DOCUMENT_TYPE:
        SEPA(genericDocument).ReceiverIBAN;
        break;

      case MedicalCertificate.DOCUMENT_TYPE:
        MedicalCertificate(genericDocument).DoctorNumber;
        break;

      case VCard.DOCUMENT_TYPE:
        VCard(genericDocument).FirstName;
        break;

      case AAMVA.DOCUMENT_TYPE:
        AAMVA(genericDocument).DriverLicense;
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
          "Document: ${genericDocument.type?.name} \nField: ${wrappedGenericFieldValue?.type.name} \nValue: ${wrappedGenericFieldValue?.value?.text}",
          style: const TextStyle(inherit: true, color: Colors.black)),
    );
  }
}
