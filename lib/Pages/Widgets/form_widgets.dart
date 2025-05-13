import 'dart:io';
import 'package:flutter/material.dart';
import 'package:elades20/Services/Pengajuan/media_picker_service.dart';
import 'package:flutter/services.dart';

class FormWidgets {
  static Widget buildTextField({
    required String label,
    required TextEditingController? controller,
    bool obscureText = false,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? obscureText : false,
        keyboardType:
            isPassword ? TextInputType.visiblePassword : TextInputType.text,
        cursorColor: const Color.fromARGB(255, 46, 46, 46),
        decoration: InputDecoration(
          labelText: label,
          floatingLabelStyle: const TextStyle(color: Color(0xFF4B9560)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF4B9560)),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  static Widget buildDateField(
      {required String label,
      required TextEditingController controller,
      required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        cursorColor: const Color(0xFF4B9560),
        decoration: InputDecoration(
          labelText: label,
          floatingLabelStyle: const TextStyle(color: Color(0xFF4B9560)),
          suffixIcon: const Icon(Icons.calendar_today),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF4B9560)),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            String formattedDate =
                "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
            controller.text = formattedDate;
          }
        },
      ),
    );
  }

  static Widget buildDropdownField({
    required String label,
    required String? selectedValue,
    required Function(String?) onChanged,
    required List<DropdownMenuItem<String>> items,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        items: items,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelStyle: const TextStyle(color: Color(0xFF4B9560)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF4B9560)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  static Widget buildMedia(
    BuildContext context,
    List<String> mediaPaths,
    Function(List<String>) onMediaPathsChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Media (Foto/File)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: mediaPaths.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == mediaPaths.length) {
                return buildAddMediaButton(
                  context,
                  (paths) {
                    List<String> updatedPaths = List.from(mediaPaths)
                      ..addAll(paths);
                    onMediaPathsChanged(updatedPaths);
                  },
                );
              }

              final path = mediaPaths[index];
              final isImage = path.toLowerCase().endsWith('.jpg') ||
                  path.toLowerCase().endsWith('.png') ||
                  path.toLowerCase().endsWith('.jpeg') ||
                  path.toLowerCase().endsWith('.gif');
              final isPdf = path.toLowerCase().endsWith('.pdf');
              final isDoc = path.toLowerCase().endsWith('.doc') ||
                  path.toLowerCase().endsWith('.docx') ||
                  path.toLowerCase().endsWith('.txt') ||
                  path.toLowerCase().endsWith('.xls') ||
                  path.toLowerCase().endsWith('.xlsx');

              return Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: isImage
                        ? Image.file(File(path), fit: BoxFit.cover)
                        : isPdf
                            ? const Icon(Icons.picture_as_pdf,
                                size: 40, color: Colors.red)
                            : isDoc
                                ? const Icon(Icons.description,
                                    size: 40, color: Colors.blue)
                                : const Icon(Icons.insert_drive_file,
                                    size: 40, color: Colors.grey),
                  ),
                  Positioned(
                    top: -8,
                    right: -8,
                    child: IconButton(
                      icon:
                          const Icon(Icons.cancel, color: Colors.red, size: 20),
                      onPressed: () {
                        List<String> updatedPaths = List.from(mediaPaths);
                        updatedPaths.removeAt(index);
                        onMediaPathsChanged(updatedPaths);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  static Widget buildAddMediaButton(
    BuildContext context,
    Function(List<String>) onFilePicked,
  ) {
    return GestureDetector(
      onTap: () {
        MediaPickerService.showMediaPicker(
          context: context,
          onFilePicked: (paths) {
            debugPrint('Media dipilih: $paths');
            onFilePicked(paths);
          },
        );
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.add, size: 30, color: Colors.black54),
      ),
    );
  }

  // Add this method to your FormWidgets class
  static Widget buildNikField({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number, // Numeric keyboard
        maxLength: 16, // Limit to 16 characters
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, // Only allow digits
        ],
        validator: (value) {
          if (value == null || value.isEmpty || value.length < 16) {
            return 'NIK harus 16 digit';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorColor: const Color.fromARGB(255, 46, 46, 46),
        decoration: InputDecoration(
          labelText: label,
          counterText: "", // Hide the character counter
          floatingLabelStyle: const TextStyle(color: Color(0xFF4B9560)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF4B9560)),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFC10D00)),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFC10D00)),
            borderRadius: BorderRadius.circular(8),
          ),
          errorStyle: const TextStyle(color: Color(0xFFC10D00)),
        ),
      ),
    );
  }
}
