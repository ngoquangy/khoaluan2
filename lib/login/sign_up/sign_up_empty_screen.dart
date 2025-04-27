import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/login/login_empty_state.dart';
import 'package:learn_megnagmet/login/sign_up/term_and_condition.dart';
import '../../utils/screen_size.dart';
import '../../Services/auth_services.dart'; // Import your AuthServices

class SignInEmptyScreen extends StatefulWidget {
  const SignInEmptyScreen({Key? key}) : super(key: key);

  @override
  State<SignInEmptyScreen> createState() => _SignInEmptyScreenState();
}

class _SignInEmptyScreenState extends State<SignInEmptyScreen> {
  bool isChecked = false;
  bool isPassHidden = true;
  bool isPassHidden1 = true;

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController phoneController =
      TextEditingController(); // Added phone controller

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),
              SizedBox(height: 20.h),
              Center(
                child: Text(
                  "Tạo tài khoản",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.sp,
                    fontFamily: 'Gilroy',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: ListView(
                  children: [
                    detailForm(),
                    SizedBox(height: 25.h),
                    termConditionCheckbox(),
                    SizedBox(height: 25.h),
                    signUpButton(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: alreadyLoginButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  toggle() {
    setState(() {
      isPassHidden = !isPassHidden;
    });
  }

  toggle1() {
    setState(() {
      isPassHidden1 = !isPassHidden1;
    });
  }

  Widget detailForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Name',
              hintStyle: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.bold),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: const Color(0XFF23408F), width: 1.w)),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: const Color(0XFFDEDEDE), width: 1.w),
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              contentPadding:
                  EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
            ),
            validator: (val) {
              if (val!.isEmpty) return 'Enter your name';
              return null;
            },
          ),
          SizedBox(height: 20.h),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'Email',
              hintStyle: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.bold),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: const Color(0XFF23408F), width: 1.w)),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: const Color(0XFFDEDEDE), width: 1.w),
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              contentPadding:
                  EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
            ),
            validator: (val) {
              if (val!.isEmpty) return 'Enter your email';
              if (!RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(val)) {
                return "Please enter a valid email address";
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),
          TextFormField(
            controller: phoneController, // Phone number input
            decoration: InputDecoration(
              hintText: 'Phone Number',
              hintStyle: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.bold),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: const Color(0XFF23408F), width: 1.w)),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: const Color(0XFFDEDEDE), width: 1.w),
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              contentPadding:
                  EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
            ),
            validator: (val) {
              if (val!.isEmpty) return 'Enter your phone number';
              return null;
            },
          ),
          SizedBox(height: 20.h),
          TextFormField(
            controller: passwordController,
            obscureText: isPassHidden,
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                  onTap: () => toggle(),
                  child: Image(
                    image: isPassHidden
                        ? const AssetImage("assets/notvisible_eye.png")
                        : const AssetImage("assets/visible_eye.png"),
                    height: 20.h,
                    width: 20.w,
                  )),
              hintText: 'Password',
              hintStyle: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.bold),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: const Color(0XFF23408F), width: 1.w)),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: const Color(0XFFDEDEDE), width: 1.w),
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              contentPadding:
                  EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
            ),
            validator: (val) {
              if (val!.isEmpty) return 'Enter your password';
              return null;
            },
          ),
          SizedBox(height: 20.h),
          TextFormField(
            controller: confirmPassController,
            obscureText: isPassHidden1,
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                  onTap: () => toggle1(),
                  child: Image(
                    image: isPassHidden1
                        ? const AssetImage("assets/notvisible_eye.png")
                        : const AssetImage("assets/visible_eye.png"),
                    height: 20.h,
                    width: 20.w,
                  )),
              hintText: 'Confirm password',
              hintStyle: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.bold),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: const Color(0XFF23408F), width: 1.w)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0XFFDEDEDE), width: 1.w),
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              contentPadding:
                  EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
            ),
            validator: (val) {
              if (val!.isEmpty) return 'Enter confirm password';
              if (val != passwordController.text)
                return 'Passwords do not match';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget termConditionCheckbox() {
    return Row(
      children: [
        Checkbox(
          activeColor: const Color(0XFF23408F),
          side: const BorderSide(color: Color(0XFFDEDEDE)),
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value!;
            });
          },
        ),
        RichText(
            text: TextSpan(
                text: 'I Agree with ',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .color, // 👈 tự đổi theo theme
                ),
                children: [
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.to(const TermCondition());
                  },
                text: 'Terms and condition',
                style: const TextStyle(
                    color: Color(0XFF23408F),
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Gilroy'),
              )
            ])),
      ],
    );
  }

  Widget signUpButton() {
    return GestureDetector(
      onTap: () {
        if (formKey.currentState!.validate()) {
          if (isChecked) {
            register();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('You must accept the terms and conditions')),
            );
          }
        }
      },
      child: Container(
        height: 56.h,
        width: 374.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0XFF23408F),
        ),
        child: Center(
          child: Text(
            "Đăng Ký",
            style: TextStyle(
              color: const Color(0XFFFFFFFF),
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Gilroy',
            ),
          ),
        ),
      ),
    );
  }

  Future<void> register() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String phone = phoneController.text.trim(); // Get phone number input

    // Call your AuthServices to perform the registration
    try {
      var response = await AuthServices.register(name, email, password, phone);
      if (response.statusCode == 200) {
        // Handle successful registration
        Get.offAll(const EmptyState()); // Navigate to the next screen
      } else {
        // Handle registration error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${response.body}')),
        );
      }
    } catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
    }
  }

  Widget alreadyLoginButton() {
    return Align(
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          text: 'Already have an account? ',
          style: TextStyle(
            color:
                Theme.of(context).textTheme.bodyMedium!.color, // 👈 Tự đổi màu
            fontSize: 15.sp,
            fontFamily: 'Gilroy',
          ),
          children: [
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Get.off(const EmptyState());
                },
              text: 'Login',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Gilroy',
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .color, // 👈 màu nổi bật (tuỳ dark/light)
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
    phoneController.dispose(); // Dispose of the phone controller
    super.dispose();
  }
}
