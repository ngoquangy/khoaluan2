import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:learn_megnagmet/Services/auth_services.dart';
import 'package:learn_megnagmet/models/learning.dart';
import 'package:learn_megnagmet/home/calendar_screen.dart';

class AchievementWidget extends StatefulWidget {
  const AchievementWidget({Key? key}) : super(key: key);

  @override
  _AchievementWidgetState createState() => _AchievementWidgetState();
}

class _AchievementWidgetState extends State<AchievementWidget> {
  List<Learning> learnings = [];
  int streakCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchLearningData();
  }

  Future<void> _fetchLearningData() async {
    try {
      // Fetch learning data from AuthServices
      learnings = await AuthServices.fetchLearning();

      // Optionally filter by userId if needed
      // learnings = learnings.where((learning) => learning.userId == userId).toList();

      // Update streak count
      setState(() {
        streakCount = _calculateStreakCount();
      });
    } catch (e) {
      print('Error fetching streaks: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra khi tải dữ liệu!')),
      );
    }
  }

  int _calculateStreakCount() {
    if (learnings.isEmpty) return 0;

    List<DateTime> dates = learnings
        .map((learning) => DateTime.parse(learning.timeSpending))
        .toList()
      ..sort();

    int maxStreak = 1, currentStreak = 1;

    for (int i = 1; i < dates.length; i++) {
      final difference = dates[i].difference(dates[i - 1]).inDays;

      if (difference <= 1) {
        // Nếu cách nhau 1 ngày, tiếp tục chuỗi
        currentStreak++;
      } else if (difference == 2) {
        // Nếu cách nhau đúng 2 ngày, tiếp tục tính chuỗi (tính là tiếp nối)
        currentStreak++;
      } else {
        // Nếu cách nhau trên 2 ngày, reset chuỗi
        maxStreak = currentStreak > maxStreak ? currentStreak : maxStreak;
        currentStreak = 1;
      }
    }

    // Kiểm tra chuỗi cuối cùng sau khi vòng lặp kết thúc
    return currentStreak > maxStreak ? currentStreak : maxStreak;
  }

  @override
  Widget build(BuildContext context) {
    final startOfWeek =
        DateTime.now().subtract(Duration(days: DateTime.now().weekday % 7));

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CalendarScreen()),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_fire_department, color: Colors.orange, size: 80),
            SizedBox(height: 10),
            Text(
              streakCount > 0
                  ? 'Chuỗi $streakCount ngày học!'
                  : 'Chưa bắt đầu học!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (index) {
                final date = startOfWeek.add(Duration(days: index));
                bool isMarked = learnings
                    .map((learning) => learning.timeSpending)
                    .contains(DateFormat('yyyy-MM-dd').format(date));

                return Column(
                  children: [
                    Icon(Icons.local_fire_department,
                        color: isMarked ? Colors.orange : Colors.grey.shade300,
                        size: 30),
                    SizedBox(height: 4),
                    Text(DateFormat.E().format(date)),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
