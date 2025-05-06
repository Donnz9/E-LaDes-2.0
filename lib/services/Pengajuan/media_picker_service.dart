import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class MediaPickerService {
  static Future<void> showMediaPicker({
    required BuildContext context,
    required Function(List<String> path) onFilePicked,
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
                final file = await _pickImageFromCamera();
                if (file != null) onFilePicked([file]);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () async {
                Navigator.of(context).pop();
                final files = await _pickImagesFromGallery();
                if (files.isNotEmpty) onFilePicked(files);
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Pilih File (PDF, dll)'),
              onTap: () async {
                Navigator.of(context).pop();
                final files = await _pickFile();
                if (files.isNotEmpty) onFilePicked(files);
              },
            ),
          ],
        ),
      ),
    );
  }

  static Future<String?> _pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    return pickedFile?.path;
  }

  static Future<List<String>> _pickImagesFromGallery() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    return result?.paths.whereType<String>().toList() ?? [];
  }

  static Future<List<String>> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      return result.paths.whereType<String>().toList();
    }
    return [];
  }
}
