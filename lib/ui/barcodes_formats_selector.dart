import 'package:flutter/material.dart';

import 'barcode_format_item.dart';
import 'barcode_formats_repo.dart';

class BarcodesFormatSelectorWidget extends StatefulWidget {
  final BarcodeFormatsRepository _repository;

  BarcodesFormatSelectorWidget(this._repository);

  @override
  _BarcodesFormatSelectorWidgetState createState() =>
      _BarcodesFormatSelectorWidgetState(_repository);
}

class _BarcodesFormatSelectorWidgetState
    extends State<BarcodesFormatSelectorWidget> {
  BarcodeFormatsRepository _repository;

  var allBarcodes = BarcodeFormatsRepository.getSelectableTypes();

  _BarcodesFormatSelectorWidgetState(this._repository);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(),
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.white,
          title: const Text('Accepted barcodes',
              style: TextStyle(inherit: true, color: Colors.black)),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, position) {
                  var item = allBarcodes[position];
                  return BarcodeFormatItemWidget(
                      item, _repository.selectedFormats.contains(item),
                      onSelect: (bool) {
                    setState(() {
                      if (bool) {
                        _repository.selectedFormats.add(item);
                      } else {
                        _repository.selectedFormats.remove(item);
                      }
                    });
                  });
                },
                itemCount: allBarcodes.length,
              ),
            ),
          ],
        ));
  }
}
