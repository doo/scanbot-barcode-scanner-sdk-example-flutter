import 'package:flutter/material.dart';

import '../snippets/rtuui/rtuUiV2_ar_overlay_usecase.dart';
import '../snippets/rtuui/rtuUiV2_find_and_pick_scanning_usecase.dart';
import '../snippets/rtuui/rtuUiV2_mapping_item_config.dart';
import '../snippets/rtuui/rtuUiV2_multi_scanning_usecase.dart';
import '../snippets/rtuui/rtuUiV2_single_scanning_usecase.dart';

import '../utility/utils.dart';
import '../ui/menu_items.dart';
import '../ui/preview/barcode_preview.dart';
import '../ui/barcode_formats/repo.dart';
import '../ui/barcode_formats/selector.dart';

import 'package:barcode_scanner/scanbot_barcode_sdk_ui_v2.dart';


class BarcodeUseCasesWidget extends StatefulWidget {
  @override
  _BarcodeUseCasesWidget createState() {
    return _BarcodeUseCasesWidget();
  }
}

class _BarcodeUseCasesWidget extends State<BarcodeUseCasesWidget> {
  late BarcodeFormatsV2Repository _barcodeFormatsRepository;

  @override
  void initState() {
    _barcodeFormatsRepository = BarcodeFormatsV2Repository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const TitleItemWidget(title: 'Barcode Scanners (RTU v2.0)'),
        BuildMenuItem(context, "Single Scan with confirmation dialog", startSingleScanV2),
        BuildMenuItem(context, "Multiple Scan", startMultipleScanV2),
        BuildMenuItem(context, "Find and Pick", startFindAndPickScanV2),
        BuildMenuItem(context, "AROverlay", startAROverlayScanV2),
        BuildMenuItem(context, "Info Mapping", startItemMappingScanV2),
        MenuItemWidget(
            title: "Set Accepted Barcodes (RTU v2.0)",
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        BarcodesFormatSelectorWidget(_barcodeFormatsRepository)),
              );
            },
          ),
      ],
    );
  }

  Future<void> startScan({
    required BuildContext context,
    required Future<ResultWrapper<BarcodeScannerResult>> Function() scannerFunction,
  }) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }
    try {
      var result = await scannerFunction();
      if (result.status == OperationStatus.OK &&
          result.value != null) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BarcodesResultPreviewWidgetV2(result.value!),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> startSingleScanV2(BuildContext context) async {
    await startScan(
      context: context,
      scannerFunction: () => ScanbotBarcodeSdkUiV2.startBarcodeScanner(rtuUiV2SingleScanningUseCase(_barcodeFormatsRepository.selectedFormats.toList())),
    );
  }

  Future<void> startMultipleScanV2(BuildContext context) async {
    await startScan(
      context: context,
      scannerFunction: () => ScanbotBarcodeSdkUiV2.startBarcodeScanner(rtuUiV2MultipleScanningUseCase(_barcodeFormatsRepository.selectedFormats.toList())),
    );
  }

  Future<void> startFindAndPickScanV2(BuildContext context) async {
    await startScan(
      context: context,
      scannerFunction: () => ScanbotBarcodeSdkUiV2.startBarcodeScanner(rtuUiV2FindAndPickModeUseCase(_barcodeFormatsRepository.selectedFormats.toList())),
    );
  }

  Future<void> startAROverlayScanV2(BuildContext context) async {
    await startScan(
      context: context,
      scannerFunction: () => ScanbotBarcodeSdkUiV2.startBarcodeScanner(rtuUiArOverlayUseCase(_barcodeFormatsRepository.selectedFormats.toList())),
    );
  }

  Future<void> startItemMappingScanV2(BuildContext context) async {
    await startScan(
      context: context,
      scannerFunction: () => ScanbotBarcodeSdkUiV2.startBarcodeScanner(rtuUiV2MappingItemConfiguration(_barcodeFormatsRepository.selectedFormats.toList())),
    );
  }
}