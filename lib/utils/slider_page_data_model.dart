import 'package:learn_megnagmet/models/choose_plane.dart';
import 'package:learn_megnagmet/models/design_list.dart';
import 'package:learn_megnagmet/models/home_slider.dart';
import 'package:learn_megnagmet/models/recently_added.dart';
import 'package:learn_megnagmet/models/trending_cource.dart';

class Utils {
  static List<HomeSlider> getHomeSliderPages() {
    return [
      HomeSlider(
          image: 'assets/backgroudhocphan.png', title: 'What you want to learn?'),
      HomeSlider(
          image: 'assets/backgroudcertifications.png', title: 'Get online certificate.'),
    ];
  }

  static List<Design> getDesign() {
    return [
      Design(image: 'assets/d3.png', name: 'Design', color: '0XFFFFF6E5'),
      Design(image: 'assets/d4.png', name: 'Code', color: '0XFFFEE9EB'),
      Design(image: 'assets/d5.png', name: 'Buisness', color: '0XFFECF6FF'),
      Design(image: 'assets/d6.png', name: 'Photography', color: '0XFFFFF6E5'),
    ];
  }

  static List<Trending> getTrending() {
    return [
      Trending(
          review: '4.9',
          image: 'assets/trending1.png',
          title: 'UI/UX Design',
          subtitle: 'master class',
          time: '2 .40 Hrs',
          circleimage: 'assets/trendingcircle1.png',
          personname: 'Jenny Wilson',
          id: 1,
          buttonStatus: false),
      Trending(
          review: '4.9',
          image: 'assets/trending2.png',
          title: 'Office management',
          subtitle: 'master class',
          time: '2 .40 Hrs',
          circleimage: 'assets/trendingcircle2.png',
          personname: 'Cody Fisher',
          id: 2,
          buttonStatus: false),
      Trending(
          review: '3.5',
          image: 'assets/trending3.png',
          title: 'Digital photography',
          subtitle: 'master class',
          time: '12 .30 Hrs',
          circleimage: 'assets/trendingcircle3.png',
          personname: 'Leslie Alexander',
          id: 3,
          buttonStatus: false),
      Trending(
          review: '3.5',
          image: 'assets/trending4.png',
          title: 'Software Development.',
          subtitle: '',
          time: '12 .30 Hrs',
          circleimage: 'assets/trendingcircle4.png',
          personname: 'Kristin Watson',
          id: 4,
          buttonStatus: false),
      Trending(
          review: '4.9',
          image: 'assets/trending5.png',
          title: 'Master in adobe',
          subtitle: 'photoshop',
          time: '2 .40 Hrs',
          circleimage: 'assets/trendingcircle2.png',
          personname: 'Cody Fisher',
          id: 5,
          buttonStatus: false),
      Trending(
          review: '4.9',
          image: 'assets/trending6.png',
          title: 'Flutter Development.',
          subtitle: '',
          time: '12 .30 Hrs',
          circleimage: 'assets/trendingcircle4.png',
          personname: 'Kristin Watson',
          id: 6,
          buttonStatus: false),
    ];
  }

  static List<Recent> getRecentAdded() {
    return [
      Recent(
          image: 'assets/recent1.png',
          time: '2 .40 Hrs',
          review: '4.9',
          personname: 'Jenny Wilson',
          price: '\$174.00',
          circleimage: 'assets/recentcircle1.png',
          title: 'How to make creative photo with photoshop',
          id: 1,
          buttonStatus: false),
      Recent(
          image: 'assets/recent2.png',
          time: '2 .40 Hrs',
          review: '3.9',
          personname: 'Jenny Wilson',
          price: '\$174.00',
          circleimage: 'assets/recentcircle1.png',
          title: 'How to illustratior with diffirent menu and vector',
          id: 2,
          buttonStatus: false),
      Recent(
          image: 'assets/recent1.png',
          time: '2 .40 Hrs',
          review: '4.9',
          personname: 'Jenny Wilson',
          price: '\$140.00',
          circleimage: 'assets/recentcircle1.png',
          title: 'How to make creative photo with photoshop   ',
          id: 3,
          buttonStatus: false),
    ];
  }

  static List<ChoicePlane> getChoosePlane() {
    return [
      ChoicePlane(
          planeTime: '\$12/Month',
          planfacelity1st: 'Lorem ipsum dolor sit amet',
          planfacelity2nd: 'Lorem ipsum dolor sit amet',
          planfacelity3rd: 'Lorem ipsum dolor sit amet',
          image: 'assets/right.png',
          cho: false,
          id: 1),
      ChoicePlane(
          planeTime: '\$99/Year',
          planfacelity1st: 'Lorem ipsum dolor sit amet',
          planfacelity2nd: 'Lorem ipsum dolor sit amet',
          planfacelity3rd: 'Lorem ipsum dolor sit amet',
          image: 'assets/right.png',
          cho: false,
          id: 2),
    ];
  }
}