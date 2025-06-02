import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

Future<List<String>?> extractImagesFromPdf() async {
    /**
     * Select a file
     * Return early if no file is selected or there is an issue selecting a file
     **/
    final pdfFilePath = "my-pdf-file-path";

    /**
     * Extract the images from the pdf with the desired configuration options
     */
    var result = await ScanbotBarcodeSdk.extractImagesFromPdf(ExtractImagesFromPdfParams(pdfFilePath: pdfFilePath));

    /**
     * Handle the result
     */
    return result;
}