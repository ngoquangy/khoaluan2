import 'package:flutter/material.dart';
import 'package:learn_megnagmet/models/training_details.dart';

class TrainingResultTab extends StatelessWidget {
  final Future<List<TrainingDetail>> futureTrainingDetails;
  final int hocPhanId;

  const TrainingResultTab({
    Key? key,
    required this.futureTrainingDetails,
    required this.hocPhanId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TrainingDetail>>(
      future: futureTrainingDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi tải dữ liệu: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Chưa có kết quả luyện tập nào.'));
        }

        final results = snapshot.data!
            .where((detail) => detail.hocphanId == hocPhanId)
            .toList();

        if (results.isEmpty) {
          return const Center(
              child: Text('Không có kết quả cho học phần này.'));
        }

        return Column(
          children: results
              .map((detail) => TrainingResultCard(detail: detail))
              .toList(),
        );
      },
    );
  }
}

class TrainingResultCard extends StatelessWidget {
  final TrainingDetail detail;

  const TrainingResultCard({Key? key, required this.detail}) : super(key: key);

  String getXepLoai(double? diem) {
    if (diem == null) return "Không có";
    if (diem >= 9.0) return "Xuất sắc";
    if (diem >= 8.0) return "Giỏi";
    if (diem >= 7.0) return "Khá";
    if (diem >= 5.0) return "Trung bình";
    return "Yếu";
  }

  @override
  Widget build(BuildContext context) {
    double? point = double.tryParse(detail.point);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red, width: 2),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Center(
                child: Text(
                  getXepLoai(point),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ĐỀ ${detail.tracnghiemId}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.timer,
                                    size: 18, color: Colors.purple),
                                const SizedBox(width: 6),
                                Text(detail.totalTime),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    size: 18, color: Colors.purple),
                                const SizedBox(width: 6),
                                Text(detail.date),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              detail.point,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Điểm',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.pinkAccent, Colors.blueAccent],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Số câu đã làm: ${detail.totalCount}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      KetQuaBox(
                        label: "Đúng",
                        value: "${detail.trueCount}",
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                      KetQuaBox(
                        label: "Sai",
                        value: "${detail.falseCount}",
                        icon: Icons.cancel,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KetQuaBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const KetQuaBox({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Icon(icon, size: 28, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
