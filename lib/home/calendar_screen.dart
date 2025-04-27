import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:learn_megnagmet/Services/auth_services.dart';
import 'package:learn_megnagmet/models/learning.dart';
import 'package:learn_megnagmet/Services/token.dart' as token;

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  Set<String> streakDates = {};
  int totalDaysStudied = 0;

  @override
  void initState() {
    super.initState();
    _focusedDay = _selectedDay = DateTime.now();
    _fetchStreaks();
  }

  Future<void> _fetchStreaks() async {
    final userIdString = token.userId;
    final userId = int.tryParse(userIdString);

    if (userId == null || userId < 1) {
      _showSnackBar('User ID không hợp lệ!');
      return;
    }

    try {
      List<Learning> learnings = await AuthServices.fetchLearning();
      List<Learning> filteredLearnings =
          learnings.where((streak) => streak.userId == userId).toList();

      setState(() {
        streakDates = filteredLearnings
            .map((streak) => DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(streak.timeSpending)))
            .toSet();
        totalDaysStudied = streakDates.length;
      });
    } catch (e) {
      print('Error fetching streaks: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thành Tựu', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildNotificationBanner(),
              _buildCalendar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationBanner() {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.star, color: Colors.white),
              SizedBox(width: 10),
              Text("Chuỗi Streak",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ],
          ),
          SizedBox(height: 8),
          Image.asset("assets/success.png", height: 100, width: 100),
          SizedBox(height: 8),
          _buildStreakText(),
        ],
      ),
    );
  }

  Widget _buildStreakText() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Tôi đang sở hữu ',
            style: TextStyle(color: Colors.white, fontSize: 24.sp),
          ),
          TextSpan(
            text: '$totalDaysStudied',
            style: TextStyle(
                color: Colors.white,
                fontSize: 50.sp,
                fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: ' ngày streak học!',
            style: TextStyle(color: Colors.white, fontSize: 24.sp),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          weekendStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, date, _) {
            final formattedDate = DateFormat('yyyy-MM-dd').format(date);
            bool isMarked = streakDates.contains(formattedDate);

            return Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isMarked)
                    Icon(Icons.local_fire_department,
                        color: Colors.orange, size: 50),
                  Text('${date.day}',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
            );
          },
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        calendarStyle: CalendarStyle(
          todayDecoration:
              BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
          selectedDecoration:
              BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          markersMaxCount: 1,
          markerDecoration:
              BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
