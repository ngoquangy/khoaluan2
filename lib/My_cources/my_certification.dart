import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/models/certificate.dart';
import 'package:learn_megnagmet/models/hoc_phan.dart';
import 'package:learn_megnagmet/Services/auth_services.dart';
import 'package:learn_megnagmet/Services/token.dart' as token;
import 'package:qr_flutter/qr_flutter.dart';

class CertificateContent extends StatefulWidget {
  final int hocPhanId;

  const CertificateContent({Key? key, required this.hocPhanId})
      : super(key: key);

  @override
  State<CertificateContent> createState() => _CertificateContentState();
}

class _CertificateContentState extends State<CertificateContent> {
  late Future<List<Certificate>> futureCertificates;
  late Future<List<HocPhan>> futureHocPhan;

  @override
  void initState() {
    super.initState();
    futureCertificates = AuthServices.fetchCertificate();
    futureHocPhan = AuthServices.fetchHocPhan();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Certificate>>(
      future: futureCertificates,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Chứng chỉ chưa được cấp'));
        }

        final certificates = snapshot.data!
            .where((cert) => cert.hocPhanId == widget.hocPhanId)
            .toList();

        if (certificates.isEmpty) {
          return const Center(
              child: Text('Không có chứng chỉ cho học phần này'));
        }

        return FutureBuilder<List<HocPhan>>(
          future: futureHocPhan,
          builder: (context, hocPhanSnapshot) {
            if (hocPhanSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (hocPhanSnapshot.hasError) {
              return Center(child: Text('Lỗi: ${hocPhanSnapshot.error}'));
            } else if (!hocPhanSnapshot.hasData ||
                hocPhanSnapshot.data!.isEmpty) {
              return const Center(child: Text('Không tìm thấy học phần'));
            }

            final hocPhans = hocPhanSnapshot.data!;

            return ListView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // để tránh xung đột cuộn
              itemCount: certificates.length,
              itemBuilder: (context, index) {
                final certificate = certificates[index];
                final matchedHocPhan = hocPhans.firstWhereOrNull(
                    (hocPhan) => hocPhan.id == certificate.hocPhanId);

                return Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: Color(0xFF23408F), width: 15),
                    // color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Giấy chứng nhận',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text('Chứng nhận', style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 5),
                      Text(
                        '${token.userName}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Hoàn thành khóa học:',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        matchedHocPhan != null
                            ? matchedHocPhan.title
                            : 'Không xác định',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Ngày cấp: ${certificate.issueDate}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 30),

                      // ✅ HÀNG CHỨA CHỮ KÝ - LOGO - QR
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Ảnh chữ ký bên trái
                          Image.asset(
                            "assets/Picture1.png",
                            width: 80.w,
                            height: 80.h,
                            fit: BoxFit.contain,
                          ),

                          // Logo chứng chỉ ở giữa
                          Image.asset(
                            "assets/certificate_1356.png",
                            width: 80.w,
                            height: 80.h,
                            fit: BoxFit.contain,
                          ),

                          // QR code bên phải
                          // QR code bên phải
                          QrImageView(
                            data:
                                'http://192.168.171.200:8000/certificate/${certificate.userId}/${certificate.hocPhanId}',
                            version: QrVersions.auto,
                            size: 80.w,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
