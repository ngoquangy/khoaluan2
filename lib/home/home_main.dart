import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/controller/controller.dart';
import 'package:learn_megnagmet/home/home_screen.dart';
import '../My_cources/ongoing_screen.dart';
import '../My_cources/completed_screen.dart';
// import '../chate/chate_screen.dart';
import '../profile/my_profile.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({Key? key}) : super(key: key);

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  // int currentvalue = 0;
  // List userDetail = Utils.getUser();

  HomeMainController controller = Get.put(HomeMainController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeMainController>(
      init: HomeMainController(),
      builder: (controller) => Scaffold(
        body: _body(),
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: const Color(0XFF23408F).withOpacity(0.12),
                    spreadRadius: 0,
                    blurRadius: 12),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(22.0),
                topRight: Radius.circular(22.0),
              ),
              child: BottomNavigationBar(
                currentIndex: controller.position.value,
                onTap: (index) {
                  controller.onChange(index);
                },
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false, // Ẩn chữ khi chọn
                showUnselectedLabels: false, // Ẩn chữ khi không chọn
                selectedItemColor: const Color(0XFF23408F),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                        Icons.menu_book_outlined), // 📚 Icon danh sách khóa học
                    activeIcon: Icon(Icons.menu_book),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon:
                        Icon(Icons.school_outlined), // 🎓 Icon khóa học của tôi
                    activeIcon: Icon(Icons.school),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    activeIcon: Icon(Icons.person),
                    label: '',
                  ),
                ],
              ),
            )),
      ),
    );
  }

  _body() {
    switch (controller.position.value) {
      case 0:
        //return Center(child: Container(child: Text("1")));
        return HomeScreen();
      case 1:
        //return Center(child: Container(child: Text("2")));
        return const OngoingScreen();
      case 2:
        //return Center(child: Container(child: Text("2")));
        return const CompletedScreen();
      case 3:
        //return Center(child: Container(child: Text("3")));
        return MyProfile();
      default:
        return const Center(
          child: Text("inavalid"),
        );
    }
  }
}
