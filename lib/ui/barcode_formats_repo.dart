import 'package:barcode_scanner/common_data.dart';

class BarcodeFormatsRepository {
  Set<BarcodeFormat> selectedFormats = getSelectableTypes().toSet();
  static List<BarcodeFormat> getSelectableTypes() {
    var values = List.of(BarcodeFormat.values);
    values.remove(BarcodeFormat.UNKNOWN);
    return values;
  }
}
