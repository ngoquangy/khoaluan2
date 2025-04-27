import 'package:flutter/material.dart';
import 'package:learn_megnagmet/Services/token.dart' as token;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_megnagmet/profile/setting.dart';
// import 'package:learn_megnagmet/profile/my_certification.dart';
import 'package:learn_megnagmet/home/achievement.dart'; // Import the new widget

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50.h),
              _buildProfileInfo(),
              SizedBox(height: 20.h), // Tạo khoảng cách
              _setting(), // Gọi widget _setting()
              SizedBox(height: 40.h), // Tạo khoảng cách
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Chứng nhận",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
              SizedBox(height: 20.h), // Tạo khoảng cách
              AchievementWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: [
        SizedBox(height: 50.h),
        CircleAvatar(
          radius: 50.r,
          backgroundColor: Colors.grey[300],
          backgroundImage: token.userAvatar.isNotEmpty
              ? NetworkImage(token.userAvatar)
              : AssetImage("assets/9187604.png") as ImageProvider,
        ),
        SizedBox(height: 12.h),
        Text(
          token.userName.isNotEmpty ? token.userName : "User Name",
          style: TextStyle(
            fontSize: 24.sp,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _setting() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ListTile(
        title: Text(
          "Cài đặt",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Icon(Icons.settings, size: 35.h, color: Color(0XFF23408F)),
        trailing: Icon(Icons.chevron_right, size: 30.h, color: Colors.grey),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade300, width: 1.5),
          borderRadius: BorderRadius.circular(10.r),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsPage()),
          );
        },
      ),
    );
  }

  // Widget _certification() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 20.w),
  //     child: Column(
  //       children: [
  //         // SizedBox(height: 20.h), // Fixed space above the image
  //         GestureDetector(
  //           // onTap: () {
  //           //   Navigator.push(
  //           //     context,
  //           //     MaterialPageRoute(builder: (context) => CertificateContent(hocPhanId: 7892137)),
  //           //   );
  //           // },
  //           child: Container(
  //             height: 360.h, // Set a fixed height for the image
  //             width: double.infinity,
  //             child: Image.asset(
  //               "assets/certificate_7892137.png",
  //               fit: BoxFit.fill,
  //             ),
  //           ),
  //         ),
  //         // SizedBox(height: 20.h), // Fixed space below the image
  //       ],
  //     ),
  //   );
  // }
}
