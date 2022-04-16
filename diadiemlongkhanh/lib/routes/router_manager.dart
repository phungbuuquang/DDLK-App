import 'package:diadiemlongkhanh/screens/base_tabbar/base_tabbar_screen.dart';
import 'package:diadiemlongkhanh/screens/create_review/create_review_screen.dart';
import 'package:diadiemlongkhanh/screens/forgot_password/forgot_password_screen.dart';
import 'package:diadiemlongkhanh/screens/forgot_password/reset_password_screen.dart';
import 'package:diadiemlongkhanh/screens/login/login_screen.dart';
import 'package:diadiemlongkhanh/screens/login/option_login_screen.dart';
import 'package:diadiemlongkhanh/screens/login/otp_login_screen.dart';
import 'package:diadiemlongkhanh/screens/places/list_place_screen.dart';
import 'package:diadiemlongkhanh/screens/profile/setting_profile_screen.dart';
import 'package:diadiemlongkhanh/screens/profile/setting_screen.dart';
import 'package:diadiemlongkhanh/screens/promotion/detail_promotion_screen.dart';
import 'package:diadiemlongkhanh/screens/promotion/promotion_screen.dart';
import 'package:diadiemlongkhanh/screens/signup/option_signup_screen.dart';
import 'package:diadiemlongkhanh/screens/signup/signup_screen.dart';
import 'package:diadiemlongkhanh/screens/verify_phone/verify_phone_screen.dart';
import 'package:diadiemlongkhanh/screens/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';

class RouterManager {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouterName.option_login:
        return MaterialPageRoute(
          builder: (_) => OptionLoginScreen(),
        );
      case RouterName.option_signup:
        return MaterialPageRoute(
          builder: (_) => OptionSingupScreen(),
        );
      case RouterName.login:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );
      case RouterName.verify_phone:
        return MaterialPageRoute(
          builder: (_) => VerifyPhoneScreen(),
        );
      case RouterName.forgot_password:
        return MaterialPageRoute(
          builder: (_) => ForgotPasswordScreen(),
        );
      case RouterName.reset_password:
        return MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(),
        );
      case RouterName.signup:
        return MaterialPageRoute(
          builder: (_) => SignupScreen(),
        );
      case RouterName.welcome:
        return MaterialPageRoute(
          builder: (_) => WelcomeScreen(),
        );
      case RouterName.base_tabbar:
        return MaterialPageRoute(
          builder: (_) => BaseTabBarSreen(),
        );
      case RouterName.otp_login:
        return MaterialPageRoute(
          builder: (_) => OTPLoginScreen(),
        );
      case RouterName.create_review:
        return MaterialPageRoute(
          builder: (_) => CreateReviewScreen(),
        );
      case RouterName.promotion:
        return MaterialPageRoute(
          builder: (_) => PromotionScreen(),
        );
      case RouterName.detail_promotion:
        return MaterialPageRoute(
          builder: (_) => DetailPromotionScreen(),
        );
      case RouterName.list_places:
        return MaterialPageRoute(
          builder: (_) => ListPlaceScreen(),
        );
      case RouterName.setting:
        return MaterialPageRoute(
          builder: (_) => SettingScreen(),
        );
      case RouterName.setting_profile:
        return MaterialPageRoute(
          builder: (_) => SettingProfileScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}

class RouterName {
  static const option_login = '/option_login';
  static const option_signup = '/option_signup';
  static const login = '/login';
  static const verify_phone = '/verify_phone';
  static const forgot_password = '/forgot_password';
  static const reset_password = '/reset_password';
  static const signup = '/signup';
  static const welcome = '/welcome';
  static const base_tabbar = '/base_tabbar';
  static const otp_login = '/otp_login';
  static const create_review = '/create_review';
  static const promotion = '/promotion';
  static const detail_promotion = '/detail_promotion';
  static const list_places = '/list_places';
  static const setting = '/setting';
  static const setting_profile = '/setting_profile';
}
