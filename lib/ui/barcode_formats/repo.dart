import 'package:barcode_scanner/scanbot_barcode_sdk_ui_v2.dart';

class BarcodeFormatsV2Repository {
  Set<BarcodeFormat> selectedFormats = getSelectableTypes().toSet();

  static List<BarcodeFormat> getSelectableTypes() =>
      PredefinedBarcodes.allBarcodeTypes();
}
