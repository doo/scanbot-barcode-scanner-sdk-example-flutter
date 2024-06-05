import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scanner/scanbot_barcode_sdk.dart' as sdk;

class ScanbotScannerScreen extends StatefulWidget {
  const ScanbotScannerScreen();

  @override
  State<ScanbotScannerScreen> createState() => _ScanbotScannerScreenState();
}

class _ScanbotScannerScreenState extends State<ScanbotScannerScreen> {
  int _index = 0;
  ValueNotifier<bool> detectBarcodes = ValueNotifier<bool>(false);
  ValueNotifier<bool> showPolygon = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScanbotScanner(
            detectBarcodes: detectBarcodes,
           // showPolygon: showPolygon,
            onScanned: (String barcode) async {
              print('Barcode: $barcode scanned');
              // if the barcode is in our inventory and is a valid product, timeout for mocking network call
              Future<void>.delayed(const Duration(milliseconds: 300));

              detectBarcodes.value = false;
              setState(() {
                _index = 0; // to change a value inside setState this a more correct approach?
              });
              return 200;
            },
            onLicenseFailed: () {
              print('License failed');
            }),
        IndexedStack(
          index: _index,
          children: [
            GestureDetector(
              onTap: () {
                detectBarcodes.value = true;
                setState(() {
                  _index =
                      1; // to change a value inside setState this a more correct approach?
                });
              },
              child: Container(
                  color: Colors.green,
                  child: const Center(child: Text('Start scanning'))),
            ),
            Container(color: Colors.transparent)
          ],
        ),
      ],
    );
  }
}


class ScanbotScanner extends StatefulWidget {
  const ScanbotScanner(
      {required this.detectBarcodes, required this.onScanned, required this.onLicenseFailed});

  final ValueNotifier<bool> detectBarcodes;
  final Future<dynamic> Function(String) onScanned;
  final void Function() onLicenseFailed;

  @override
  State<ScanbotScanner> createState() => _ScanbotScannerState();
}

class _ScanbotScannerState extends State<ScanbotScanner> with WidgetsBindingObserver {
  Timer? _lastScanTimer;
  bool _cameraPreviewStarted = false;
  bool _shouldScan = false;
  bool _isRunningAdd = false;
  bool _cameraBreak = false;
  String _lastScannedBarcode = '';
  DateTime _lastScannedTime = DateTime.now();
  DateTime _detectBarcodesTimeLastChanged = DateTime.now();
  final int _delayUntilAdd = 100;
  final int _delayUntilShowCameraAfterPreviewStarted = 100;
  final int _turnOffCameraWhenIdleFor = 3000;
  final bool _shouldScanAllTypesOfBarcodes = false;
  final bool _showCameraOverlay = true;
  bool _showBarcodeOverlay = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _shouldScan = widget.detectBarcodes.value;
    widget.detectBarcodes.addListener(_onDetectBarcodeChange);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _lastScanTimer?.cancel();
    widget.detectBarcodes.removeListener(_onDetectBarcodeChange);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _cameraPreviewStarted = false;
      if (mounted) setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant ScanbotScanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.detectBarcodes != widget.detectBarcodes) {
      oldWidget.detectBarcodes.removeListener(_onDetectBarcodeChange);
      widget.detectBarcodes.addListener(_onDetectBarcodeChange);
    }
  }

  void _startScanTimer() {
    _lastScanTimer?.cancel();
    _lastScanTimer = Timer(Duration(milliseconds: _turnOffCameraWhenIdleFor), () {
      if (_cameraBreak && !_cameraPreviewStarted) return;
      _cameraBreak = true;
      _cameraPreviewStarted = false;
      if (mounted) setState(() {});
    });
  }

  void _cancelScanTimer() {
    _lastScanTimer?.cancel();
    if (!_cameraBreak) return;
    _cameraBreak = false;
    if (mounted) setState(() {});
  }

  void _changeDetection(bool detect) {
    detect ? _cancelScanTimer() : _startScanTimer();
    if (_shouldScan != detect) {
      _shouldScan = detect;
      if (mounted) setState(() {});
    }
  }

  Future<void> _addBarcodeItem(List<sdk.BarcodeItem> barcodeItems) async {
    if (_isRunningAdd ||
        !_cameraPreviewStarted ||
        !DateTime.now().isAfter(_detectBarcodesTimeLastChanged.add(Duration(milliseconds: _delayUntilAdd)))) return;
    _isRunningAdd = true;
    sdk.BarcodeItem? barcodeItem = barcodeItems.firstWhereOrNull((sdk.BarcodeItem item) {
      String barcode = item.text ?? '';
      return barcode.isNotEmpty &&
          (barcode == _lastScannedBarcode
              ? DateTime.now().difference(_lastScannedTime) > const Duration(seconds: 1)
              : true) &&
          !barcode.startsWith('{') &&
          !barcode.contains('http') &&
          (item.barcodeFormat == sdk.BarcodeFormat.DATA_MATRIX
              ? barcode.length == 27 && barcode.substring(1, 3) == '01' && barcode.substring(19, 21) == '98'
              : true);
    });

    dynamic result;
    String barcode = barcodeItem?.text ?? '';
    if (barcode.isNotEmpty) {
      _lastScannedBarcode = barcode;
      _lastScannedTime = DateTime.now();
      result = await widget.onScanned(barcode);
    }
    if (result == 200 || result == 404) {
      _changeDetection(false);
    }
    _isRunningAdd = false;
  }

  void _onDetectBarcodeChange() {
    if (_shouldScan != widget.detectBarcodes.value) {
      _detectBarcodesTimeLastChanged = DateTime.now();
      _changeDetection(widget.detectBarcodes.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          if (!_cameraBreak)
            sdk.BarcodeScannerCamera(
                barcodeListener: (sdk.BarcodeScanningResult scanningResult) async {
                  await _addBarcodeItem(scanningResult.barcodeItems);
                },
                errorListener: (sdk.SdkLicenseException e) {
                  print('Error: ${e.message}');
                  widget.onLicenseFailed();
                },
                onCameraPreviewStarted: (bool _) {
                  _changeDetection(false);
                  Future.delayed(Duration(milliseconds: _delayUntilShowCameraAfterPreviewStarted), () {
                    _cameraPreviewStarted = true;
                    if (mounted) setState(() {});
                    if (widget.detectBarcodes.value) {
                      _changeDetection(true);
                    }
                  });
                },
                configuration: sdk.BarcodeCameraConfiguration(
                  detectionEnabled: _shouldScan,
                  scannerConfiguration: sdk.BarcodeClassicScannerConfiguration(
                    barcodeFormats: _shouldScanAllTypesOfBarcodes
                        ? sdk.PredefinedBarcodes.allBarcodeTypes()
                        : [
                      sdk.BarcodeFormat.EAN_8,
                      sdk.BarcodeFormat.EAN_13,
                      sdk.BarcodeFormat.CODE_128,
                      sdk.BarcodeFormat.DATA_MATRIX,
                      sdk.BarcodeFormat.DATABAR_LIMITED,
                      sdk.BarcodeFormat.RSS_14,
                      sdk.BarcodeFormat.RSS_EXPANDED,
                      sdk.BarcodeFormat.GS1_COMPOSITE,
                      sdk.BarcodeFormat.UPC_A,
                      sdk.BarcodeFormat.UPC_E,
                    ],
                    acceptedDocumentFormats: [],
                    additionalParameters: sdk.BarcodeAdditionalParameters(
                      gs1HandlingMode: sdk.Gs1HandlingMode.DECODE,
                      msiPlesseyChecksumAlgorithm: sdk.MSIPlesseyChecksumAlgorithm.MOD_11_NCR,
                    ),
                  ),
                  finder: !_showCameraOverlay
                      ? null
                      : sdk.FinderConfiguration(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.yellow,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                      ),
                      widget: LayoutBuilder(builder: (context, constrains) {
                        double boxSize = (constrains.maxHeight / 6).floor().toDouble();
                        return OverflowBox(
                          maxHeight: constrains.maxHeight + 16,
                          maxWidth: constrains.maxWidth + 16,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  height: boxSize,
                                  width: boxSize,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border(
                                      top: BorderSide(width: 2, color: Colors.yellow),
                                      right: BorderSide(width: 2, color: Colors.yellow),
                                    ),
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(24)),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  height: boxSize,
                                  width: boxSize,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(width: 2, color: Colors.yellow),
                                      left: BorderSide(width: 2, color: Colors.yellow),
                                    ),
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24)),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: boxSize,
                                  width: boxSize,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(width: 2, color: Colors.yellow),
                                      right: BorderSide(width: 2, color: Colors.yellow),
                                    ),
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(24)),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Container(
                                  height: boxSize,
                                  width: boxSize,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(width: 2, color: Colors.yellow),
                                      left: BorderSide(width: 2, color: Colors.yellow),
                                    ),
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      backgroundColor: Colors.black.withOpacity(0.4),
                      finderInsets: const sdk.Insets(bottom: 100),
                      finderAspectRatio: sdk.AspectRatio(width: 3, height: 2.2)),
                  cameraZoomFactor: 0.02,
                  overlayConfiguration: sdk.SelectionOverlayScannerConfiguration(
                    overlayEnabled: _shouldScan && _showBarcodeOverlay,
                    automaticSelectionEnabled: true,
                    textFormat: sdk.BarcodeOverlayTextFormat.NONE,
                    polygonColor: Colors.yellow,
                  ),
                )),
          if (!_cameraPreviewStarted)
            Container(
                color: Colors.black,
                child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                      strokeWidth: 2,
                    ))),
        ],
      ),
    );
  }
}