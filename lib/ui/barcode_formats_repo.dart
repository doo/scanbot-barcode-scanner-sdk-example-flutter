import 'package:barcode_scanner/barcode_scanning_data.dart';

class BarcodeFormatsRepository {
  Set<BarcodeFormat> selectedFormats = getSelectableTypes().toSet();
  static List<BarcodeFormat> getSelectableTypes() {
    var values = List.of(BarcodeFormat.values);
    values..remove(BarcodeFormat.UNKNOWN);
    return values;
  }
}
