import 'package:barcode_scanner/barcode_sdk.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;

import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart' as picker;
import 'package:url_launcher/url_launcher.dart';

final enableImagesInScannedBarcodesResults = false;
final selectedFormatsNotifier =
    ValueNotifier<Set<BarcodeFormat>>(BarcodeFormats.all.toSet());

const Color ScanbotRedColor = Color(0xFFc8193c);

AppBar ScanbotAppBar(String title,
    {bool showBackButton = false,
    BuildContext? context,
    List<Widget>? actions}) {
  return AppBar(
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    backgroundColor: ScanbotRedColor,
    leading: showBackButton && context != null
        ? GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          )
        : null,
    title: Text(
      title,
      style: const TextStyle(
        inherit: true,
        color: Colors.white,
        fontSize: 20,
      ),
    ),
    actions: actions,
  );
}

Widget buildBottomNavigationBar(BuildContext context) {
  return Container(
    color: Colors.grey[200],
    padding: const material.EdgeInsets.all(10.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: _launchScanbotSDKURL,
          style: TextButton.styleFrom(
            padding: material.EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Learn More About Scanbot SDK',
            style: TextStyle(
              color: ScanbotRedColor,
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Copyright 2025 Scanbot SDK GmbH. All rights reserved.',
          style: TextStyle(
            fontSize: 10,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
      ],
    ),
  );
}

Future<bool> checkLicenseStatus(BuildContext context) async {
  final result = await ScanbotBarcodeSdk.getLicenseInfo();
  if (result.isValid) {
    return true;
  }
  await showAlertDialog(context, result.licenseStatusMessage, title: 'Info');
  return false;
}

Future<void> _launchScanbotSDKURL() async {
  var url = Uri.parse("https://scanbot.io/");
  if (await canLaunchUrl(url)) {
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> showAlertDialog(BuildContext context, String textToShow,
    {String? title}) async {
  Widget text = SimpleDialogOption(
    child: Text(textToShow),
  );

  final dialog = AlertDialog(
    title: title != null ? Text(title) : null,
    content: text,
    contentPadding: const material.EdgeInsets.all(0),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('OK'),
      ),
    ],
  );

  // show the dialog
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return dialog;
    },
  );
}

Future<XFile?> selectImageFromLibrary() async {
  return await ImagePicker().pickImage(source: picker.ImageSource.gallery);
}

Future<PlatformFile?> selectPdfFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null && result.files.isNotEmpty) {
    return result.files.first;
  }

  return null;
}
