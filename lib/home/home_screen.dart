import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/controller/controller.dart';
import 'package:learn_megnagmet/home/search_screen.dart';
import 'package:learn_megnagmet/models/design_list.dart';
import 'package:learn_megnagmet/models/home_slider.dart';
import 'package:learn_megnagmet/models/recently_added.dart';
import 'package:learn_megnagmet/models/trending_cource.dart';
import 'package:learn_megnagmet/utils/slider_page_data_model.dart';
import 'package:learn_megnagmet/Services/token.dart' as token;
// import 'package:intl/intl.dart';
import '../utils/screen_size.dart';
import 'package:learn_megnagmet/Services/urlimage.dart';

import 'package:learn_megnagmet/home/RecentAddedList.dart';
import 'package:learn_megnagmet/home/achievement.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<HomeSlider> pages = [];
  List<Design> design = Utils.getDesign();
  List<Trending> trendingCource = Utils.getTrending();
  List<Recent> recentAdded = Utils.getRecentAdded();
  HomeController homecontroller = Get.put(HomeController());

  // int currentpage = 0;
  PageController controller = PageController();
  bool buttonvalue = false;
  int currentvalue = 0;
  // List userDetail = Utils.getUser();
  @override
  void initState() {
    pages = Utils.getHomeSliderPages();
    super.initState();
    _fetchStreaks();
  }

  Future<void> _fetchStreaks() async {
    // Lấy userId từ token
    final userIdString = token.userId;
    final userId = int.tryParse(userIdString);

    // Kiểm tra tính hợp lệ của userId
    if (userId == null || userId < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ID không hợp lệ!')),
      );
      return; // Kết thúc phương thức nếu userId không hợp lệ
    }
  }

  toggle(int index) {
    setState(() {
      if (trendingCource[index].buttonStatus == true) {
        trendingCource[index].buttonStatus = false;
      } else {
        trendingCource[index].buttonStatus = true;
      }
    });
  }

  toggleRecent(int index) {
    setState(() {
      if (recentAdded[index].buttonStatus == true) {
        recentAdded[index].buttonStatus = false;
      } else {
        recentAdded[index].buttonStatus = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            height: double.infinity,
            width: double.infinity,
            child: GetBuilder<HomeController>(
              init: HomeController(),
              builder: (controller) => SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Container(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25.r,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: token.userAvatar.isNotEmpty
                                ? NetworkImage(
                                    '$urlImage${token.userAvatar}') // Hiển thị ảnh mới
                                : AssetImage("assets/9187604.png")
                                    as ImageProvider,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            "Welcome, ${token.userName}",
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Expanded(
                      child: ListView(
                        // physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        primary: true,
                        children: [
                          Container(
                            child: TextFormField(
                              onTap: () {
                                Get.to(SearchScreen());
                              },
                              readOnly:
                                  true, // Thêm cái này để ngăn mở bàn phím khi chỉ dùng để điều hướng
                              decoration: InputDecoration(
                                hintText: 'Học Phần',
                                hintStyle: TextStyle(
                                  color: const Color(0xFF9B9B9B),
                                  fontWeight: FontWeight.bold,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: const Color(0xFF9B9B9B),
                                  size: 34.sp,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: const Color(0xFF23408F),
                                    width: 1.w,
                                  ),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          generatepage(),
                          SizedBox(height: 20.h),
                          indicator(),
                          SizedBox(height: 20.h),
                          // horizontal_disidn(),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Thành tựu học tập",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(height: 21.h),
                          AchievementWidget(), // Use the new widget here
                          SizedBox(height: 21.h),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Học phần gần đây",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(height: 21.h),
                          RecentAddedList(), // Replace this line
                          SizedBox(height: 21.h),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget generatepage() {
    return CarouselSlider.builder(
      options: CarouselOptions(
        autoPlay: false,
        initialPage: 0,
        height: 150.0.h,
        viewportFraction: 1.0, // Chỉ hiển thị một bức ảnh tại một thời điểm
        onPageChanged: (index, reason) {
          homecontroller.onChange(index.obs);
        },
      ),
      itemBuilder: (context, index, realIndex) {
        return Container(
          child: Container(
            height: 150.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill, // Sử dụng BoxFit.fill
                image: AssetImage(pages[index].image!),
              ),
              borderRadius: BorderRadius.circular(22),
            ),
          ),
        );
      },
      itemCount: pages.length,
    );
  }

  Widget indicator() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(pages.length, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 10.h,
              width: 10.w,
              //margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: (index == homecontroller.currentpage.value)
                      ? const Color(0XFF23408F)
                      : const Color(0XFFDEDEDE)),
            ),
          );
        }));
  }

  Widget design_list() {
    return Expanded(
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          primary: false,
          scrollDirection: Axis.horizontal,
          itemCount: design.length,
          itemBuilder: (BuildContext context, index) {
            return Stack(
              children: [
                Image(
                  image: AssetImage(design[index].image!),
                  height: 110.h,
                  width: 110.h,
                )
              ],
            );
          }),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget horizontal_disidn() {
    return Container(
      //color: Colors.red,
      height: 100.h,
      width: double.infinity,
      child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          shrinkWrap: true,
          primary: false,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: design.length,
          itemBuilder: (BuildContext context, index) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: index == 0 ? 0.w : 6.w),
                  child: Image(
                    image: AssetImage(design[index].image!),
                    height: 110.h,
                    width: 110.w,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 60.h),
                  child: Text(
                    design[index].name!,
                    style: TextStyle(
                        color: Color(0XFF000000),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            );
          }),
    );
  }

  Widget recentCourses() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 20, vertical: 16), // Thêm padding cho khung
      margin: EdgeInsets.symmetric(
          vertical: 10), // Thêm margin cho khoảng cách giữa các khung
      decoration: BoxDecoration(
        color: Colors.white, // Màu nền cho khung
        borderRadius: BorderRadius.circular(12), // Bo tròn các góc
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: Offset(0, 2)), // Đổ bóng
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Recent Courses",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          // Thêm nội dung cho Recent Courses ở đây
        ],
      ),
    );
  }
}
