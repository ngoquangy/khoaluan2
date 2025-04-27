// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:get/get.dart';

// class SelectImageScreen extends StatefulWidget {
//   @override
//   _SelectImageScreenState createState() => _SelectImageScreenState();
// }

// class _SelectImageScreenState extends State<SelectImageScreen> {
//   File? _selectedImage;

//   Future<void> _pickImage(ImageSource source) async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: source);

//     if (image != null) {
//       setState(() {
//         _selectedImage = File(image.path);
//       });
//     }
//   }

//   void _confirmSelection() {
//     if (_selectedImage != null) {
//       Get.back(result: _selectedImage!.path); // Trả về đường dẫn ảnh đã chọn
//     } else {
//       Get.snackbar('Thông báo', 'Vui lòng chọn một ảnh');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Chọn Hình Ảnh")),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           _selectedImage != null
//               ? Image.file(_selectedImage!, width: 200, height: 200, fit: BoxFit.cover)
//               : Icon(Icons.image, size: 100, color: Colors.grey),
//           SizedBox(height: 20),
//           ElevatedButton.icon(
//             onPressed: () => _pickImage(ImageSource.gallery),
//             icon: Icon(Icons.photo_library),
//             label: Text("Chọn từ Thư viện"),
//           ),
//           ElevatedButton.icon(
//             onPressed: () => _pickImage(ImageSource.camera),
//             icon: Icon(Icons.camera_alt),
//             label: Text("Chụp ảnh"),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _confirmSelection,
//             child: Text("Xác nhận"),
//           ),
//         ],
//       ),
//     );
//   }
// }
