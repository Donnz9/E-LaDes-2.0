import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class MediaPickerService {
  static Future<void> showMediaPicker({
    required BuildContext context,
    required Function(String path) onFilePicked,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil Foto dari Kamera'),
              onTap: () async {
                Navigator.of(context).pop();
                final file = await _pickImage(ImageSource.camera);
                if (file != null) onFilePicked(file);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () async {
                Navigator.of(context).pop();
                final file = await _pickImage(ImageSource.gallery);
                if (file != null) onFilePicked(file);
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Pilih File (PDF, dll)'),
              onTap: () async {
                Navigator.of(context).pop();
                final file = await _pickFile();
                if (file != null) onFilePicked(file);
              },
            ),
          ],
        ),
      ),
    );
  }

  static Future<String?> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    return pickedFile?.path;
  }

  static Future<String?> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
    );
    return result != null && result.files.isNotEmpty ? result.files.first.path : null;
  }
}
