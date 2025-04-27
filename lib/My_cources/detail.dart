import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_megnagmet/models/hoc_phan.dart';
import 'package:learn_megnagmet/profile/my_certification.dart';
import 'package:learn_megnagmet/Services/auth_services.dart';
import 'package:learn_megnagmet/models/cau_hoi.dart';
import 'package:learn_megnagmet/My_cources/bo_de.dart';
import 'package:learn_megnagmet/models/training_details.dart';
import 'package:learn_megnagmet/My_cources/training_result.dart';
import 'package:learn_megnagmet/models/bo_de.dart';

class DetailPage extends StatefulWidget {
  final HocPhan hocPhan;

  const DetailPage({Key? key, required this.hocPhan}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<List<TrainingDetail>> futureTrainingDetails;
  late Future<List<CauHoi>> _cauHoiFuture;
  late Future<List<BoDeTracNghiem>> futureBoDe; // Thêm biến này
  List<CauHoi> allCauHoi = [];
  int _currentIndex = 0;
  bool _isExpanded = false;

  final List<String> _tabs = ["Luyện tập", "Kết quả", "Chứng chỉ"];

  @override
  void initState() {
    super.initState();
    _cauHoiFuture = AuthServices.fetchCauHoi().then((cauHoiList) {
      setState(() {
        allCauHoi = cauHoiList;
      });
      return cauHoiList;
    });
    futureTrainingDetails = AuthServices.fetchKetQua();
    futureBoDe = AuthServices.fetchBoDe(); // Lấy bộ đề
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi Tiết',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildDetailCard(),
              const SizedBox(height: 10),
              _buildTabSection(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard() {
    final strippedText = _stripHtmlTags(widget.hocPhan.content);
    final words = strippedText.split(' ');
    final isLongText = words.length > 20;
    final displayText = !_isExpanded && isLongText
        ? words.take(20).join(' ') + '...'
        : strippedText;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.hocPhan.photo,
              height: 150,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              widget.hocPhan.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              SizedBox(width: 4),
              FutureBuilder<List<BoDeTracNghiem>>(
                future: futureBoDe,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Đang tải...');
                  } else if (snapshot.hasError) {
                    return Text('Có lỗi: ${snapshot.error}');
                  } else {
                    final count = snapshot.data?.where((boDe) => boDe.hocphanId == widget.hocPhan.id).length ?? 0;
                    return Text('$count bộ đề');
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayText,
                  style: const TextStyle(fontSize: 14),
                ),
                if (isLongText)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(
                      _isExpanded ? 'Thu gọn' : 'Xem thêm',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _stripHtmlTags(String htmlText) {
    final document = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(document, '');
  }

  Widget _buildTabSection() {
    return Container(
      width: double.infinity,
      height: 500.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildCustomTabBar(),
          const SizedBox(height: 10),
          Expanded(child: _buildTabContentScrollable()),
        ],
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(_tabs.length, (index) {
        final isSelected = _currentIndex == index;
        return GestureDetector(
          onTap: () {
            setState(() {
              _currentIndex = index;
            });
          },
          child: Column(
            children: [
              Text(
                _tabs[index],
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 3,
                width: isSelected ? 50 : 0,
                color: const Color(0XFF23408F),
                margin: const EdgeInsets.only(top: 6),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTabContentScrollable() {
    switch (_currentIndex) {
      case 0:
        return _buildScrollable(_buildLuyenTapTab());
      case 1:
        return _buildScrollable(_buildKetQuaTab());
      case 2:
        return _buildScrollable(_buildChungChiTab());
      default:
        return Container();
    }
  }

  Widget _buildScrollable(Widget child) {
    return SingleChildScrollView(child: child);
  }

  Widget _buildLuyenTapTab() {
    return BoDeTab(hocPhan: widget.hocPhan, allCauHoi: allCauHoi);
  }

  Widget _buildKetQuaTab() {
    return TrainingResultTab(
      futureTrainingDetails: futureTrainingDetails,
      hocPhanId: widget.hocPhan.id,
    );
  }

  Widget _buildChungChiTab() {
    return CertificateContent(hocPhanId: widget.hocPhan.id);
  }
}
