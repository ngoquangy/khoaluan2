import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learn_megnagmet/models/hoc_phan.dart';
import 'package:learn_megnagmet/models/bo_de.dart';
import 'package:learn_megnagmet/models/cau_hoi.dart';
import 'package:learn_megnagmet/models/dap_an.dart';
import 'package:learn_megnagmet/Services/globals.dart'; // Đảm bảo globals.dart được import đúng
import 'package:learn_megnagmet/models/loai_trac_nghiem.dart';
import 'package:learn_megnagmet/models/learning.dart';
import 'package:learn_megnagmet/models/exam_result.dart';
import 'package:learn_megnagmet/models/certificate.dart';
import 'package:learn_megnagmet/models/feedback.dart';
// import 'package:learn_megnagmet/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learn_megnagmet/models/training_details.dart';
import 'package:learn_megnagmet/models/chapter.dart';

class AuthServices {
  static Future<http.Response> register(
      String name, String email, String password, String phone) async {
    Map<String, String> data = {
      "full_name": name,
      "email": email,
      "password": password,
      "phone": phone,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'register');
    return await http.post(
      url,
      headers: headers,
      body: body,
    );
  }

  static Future<http.Response> login(String email, String password) async {
    Map<String, String> data = {
      "email": email,
      "password": password,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'login');
    return await http.post(
      url,
      headers: headers,
      body: body,
    );
  }

  static Future<List<HocPhan>> fetchHocPhan() async {
    var url = Uri.parse(baseURL + 'hocphan');
    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => HocPhan.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load hoc phan');
    }
  }

  // Fetch other data methods for BoDe, CauHoi, and DapAn as needed
  static Future<List<BoDeTracNghiem>> fetchBoDe() async {
    var url = Uri.parse(baseURL + 'bode');
    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => BoDeTracNghiem.fromJson(data)).toList();
    } else {
      throw Exception("Failed to load bo de: ${response.body}");
    }
  }

  static Future<http.Response> updatePoint(
      int userId, String bodeId, int totalPoints) async {
    Map<String, dynamic> data = {
      "total_point": totalPoints, // Đảm bảo tên trường là total_point
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'update_points/$userId/$bodeId');

    return await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }

  static Future<http.Response> updateStatus(
      int userId, String bodeId, String status) async {
    Map<String, dynamic> data = {
      "status": status, // Đảm bảo tên trường là total_point
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'update_status/$userId/$bodeId');

    return await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }

  // Fetch CauHoi and DapAn similarly as needed
  static Future<List<CauHoi>> fetchCauHoi() async {
    var url = Uri.parse(baseURL + 'cauhoi');
    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => CauHoi.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }

  static Future<List<DapAn>> fetchDapAn() async {
    var url = Uri.parse(baseURL + 'dapan');
    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => DapAn.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load answers');
    }
  }

  static Future<http.Response> submitExamResults(
      int userId,
      int hocphanId,
      String bodetracnghiemId,
      List<Map<String, dynamic>> results,
      int total_point,
      String status) async {
    var url = Uri.parse(baseURL + 'exam_results');
    var body = json.encode({
      'user_id': userId,
      'hocphan_id': hocphanId,
      'bodetracnghiem_id': bodetracnghiemId,
      'question': results,
      'total_point': total_point,
      'status': status,
    });

    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }

  static Future<List<ExamResult>> fetchExamResults() async {
    var url = Uri.parse(baseURL + 'exam_results');
    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => ExamResult.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load ExamResult: ${response.body}');
    }
  }

  static Future<http.Response> updateProfile(
      String userId, String fullName, String email, String phone) async {
    Map<String, String> data = {
      "full_name": fullName,
      "email": email,
      "phone": phone,
    };
    var body = json.encode(data);
    var url = Uri.parse(
        baseURL + 'update_profile/$userId'); // Adjust the URL for your API

    return await http.put(
      url,
      headers: headers,
      body: body,
    );
  }

  static Future<http.Response> forgotPassword(String email) async {
    Map<String, String> data = {
      "email": email,
    };
    var body = json.encode(data);
    var url =
        Uri.parse(baseURL + 'forgot_password'); // Thay đổi URL cho API của bạn

    return await http.post(
      url,
      headers: headers,
      body: body,
    );
  }

  static Future<http.Response> resetPassword(
      String token, String password) async {
    Map<String, String> data = {
      "token": token,
      "password": password,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'reset_password');
    return await http.post(
      url,
      headers: headers,
      body: body,
    );
  }

  // Phương thức mới để lấy danh sách loại trắc nghiệm
  static Future<List<LoaiTracNghiem>> fetchLoaiTracNghiem() async {
    var url = Uri.parse(baseURL + 'loaitracnghiem');
    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => LoaiTracNghiem.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load loai trac nghiem');
    }
  }

  // Phương thức mới để lấy danh sách loại trắc nghiệm
  static Future<List<Learning>> fetchLearning() async {
    var url = Uri.parse(baseURL + 'learnings');
    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Learning.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load learning');
    }
  }

  // Phương thức mới để lấy danh sách loại trắc nghiệm
  static Future<List<Certificate>> fetchCertificate() async {
    var url = Uri.parse(baseURL + 'cartificate');
    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Certificate.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load learning');
    }
  }

  // Phương thức gửi phản hồi
  static Future<http.Response> createFeedBack(FeedbackModel feedback) async {
    var url = Uri.parse(baseURL + 'feedback'); // Endpoint cho feedback
    var body = json.encode(feedback.toJson()); // Chuyển đổi thành JSON

    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }

  static Future<http.Response> updatePhoto(
      String userId, XFile imageFile) async {
    var url = Uri.parse(baseURL + 'update_photo/$userId');

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);

    // Đính kèm file ảnh vào request
    request.files.add(
      await http.MultipartFile.fromPath(
        'photo', // Tên field trong API
        imageFile.path,
      ),
    );

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return response;
  }

  // Phương thức gửi phản hồi
  static Future<http.Response> createCertificate(
      Certificate certificate) async {
    var url = Uri.parse(baseURL + 'cartificate'); // Endpoint cho feedback
    var body = json.encode(certificate.toJson()); // Chuyển đổi thành JSON

    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }

  // Phương thức gửi phản hồi
  static Future<http.Response> createThanhTuu(Learning learning) async {
    var url = Uri.parse(baseURL + 'learnings'); // Endpoint cho feedback
    var body = json.encode(learning.toJson()); // Chuyển đổi thành JSON

    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }

  // Phương thức mới để lấy danh sách loại trắc nghiệm
  static Future<List<TrainingDetail>> fetchKetQua() async {
    var url = Uri.parse(baseURL + 'training_details');
    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => TrainingDetail.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load training details');
    }
  }

   // Phương thức gửi phản hồi
  static Future<http.Response> createTrainingDetails(TrainingDetail training_details) async {
    var url = Uri.parse(baseURL + 'training_details'); // Endpoint cho feedback
    var body = json.encode(training_details.toJson()); // Chuyển đổi thành JSON

    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }

  static Future<List<Chapter>> fetchChapter() async {
    var url = Uri.parse(baseURL + 'chapter');
    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Chapter.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load chapters');
    }
  }
}
