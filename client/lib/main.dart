import 'package:flutter/material.dart';
import 'package:flutter_web/pages/signup_page.dart';
import 'dart:convert';

import 'pages/main_page.dart'; // 너가 만든 메인 페이지 경로
import 'pages/login_page.dart';
import 'pages/mypage_page.dart';
import 'pages/account.dart';
import 'pages/reservationinfo.dart';
import 'pages/inquiryinfo.dart';
import 'pages/inquirydetail_page.dart';
import 'pages/inquiry_page.dart';
import 'pages/inquirycomplete_page.dart';
import 'pages/ticket_page.dart';
import 'pages/reservationcomplete_page.dart';
import 'pages/reservation_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Cafe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/', // 처음 페이지 // 메인 페이지 진입
      routes: {
        '/': (context) => const MainPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/mypage': (context) => const MyPage(),
        '/account': (context) => const AccountInfoPage(),
        '/inquiryinfo': (context) => const InquiryInfoPage(),
        '/reservationinfo': (context) => const ReservationInfoPage(),
        '/inquirydetail': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return InquiryDetailPage(inquiryId: args['inquiryId']);
        },
        '/inquiry': (context) => const InquiryPage(),
        '/inquirycomplete': (context) => const InquiryCompletePage(),
        '/ticket': (context) => const TicketPurchasePage(),
        '/reservationcomplete': (context) => const ReservationCompletePage(),
        '/reservation': (context) => const ReservationPage(),
      },
    );
  }
}
