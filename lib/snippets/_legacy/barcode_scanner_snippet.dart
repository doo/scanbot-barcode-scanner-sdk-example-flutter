import 'package:flutter/material.dart';

import 'package:barcode_scanner/scanbot_barcode_sdk.dart';
import 'package:barcode_scanner/scanbot_barcode_sdk.dart' as scanbot_sdk;

BarcodeScannerConfiguration barcodeConfigurationSnippet() {
  return BarcodeScannerConfiguration(
    topBarBackgroundColor: const Color(0xFFc8193c),
    barcodeFormats: PredefinedBarcodes.allBarcodeTypes(),
    overlayConfiguration: _overlayConfiguration(),
    finderAspectRatio: scanbot_sdk.AspectRatio(width: 4, height: 2), // Aspect ratio for the finder
    finderTextHint: 'Please align any supported barcode in the frame to scan it.',
    viewFinderEnabled: true, // Enable/disable the viewfinder
    // Uncomment and configure if needed
    // additionalParameters: BarcodeAdditionalParameters(
    //       gs1HandlingMode: Gs1HandlingMode.VALIDATE_FULL,
    //       minimumTextLength: 10,
    //       maximumTextLength: 11,
    //       minimum1DBarcodesQuietZone: 10,
    // )
    // cameraZoomFactor: 0.5, // Set zoom factor if needed
  );
}

SelectionOverlayConfiguration _overlayConfiguration() {
  return SelectionOverlayConfiguration(
    overlayEnabled: true, // Enable overlay
    polygonColor: Colors.red, // Color of the polygon
    automaticSelectionEnabled: false, // Disable automatic selection
  );
}