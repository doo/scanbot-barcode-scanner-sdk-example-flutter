import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

class BarcodeFormatsRepository {
  Set<BarcodeFormat> selectedFormats = getSelectableTypes().toSet();
  static List<BarcodeFormat> getSelectableTypes() {
    var values = PredefinedBarcodes.allBarcodeTypes();
    return values;
  }
}
