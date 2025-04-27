// class User {
//   final int id;
//   final String? code;
//   final String? fullName;
//   final String? username;
//   final String? email;
//   final String? phone;
//   final String? photo;
//   final String? role;
//   final String? status;

//   User({
//     required this.id,
//     this.code,
//     this.fullName,
//     this.username,
//     this.email,
//     this.phone,
//     this.photo,
//     this.role,
//     this.status,
//   });

//   // Phương thức chuyển đổi từ JSON sang đối tượng User
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'] as int,
//       code: json['code'] as String?,
//       fullName: json['full_name'] as String?,
//       username: json['username'] as String?,
//       email: json['email'] as String?,
//       phone: json['phone'] as String?,
//       photo: json['photo'] as String?,
//       role: json['role'] as String?,
//       status: json['status'] as String?,
//     );
//   }

//   // Phương thức chuyển đổi từ đối tượng User sang JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'code': code,
//       'full_name': fullName,
//       'username': username,
//       'email': email,
//       'phone': phone,
//       'photo': photo,
//       'role': role,
//       'status': status,
//     };
//   }
// }