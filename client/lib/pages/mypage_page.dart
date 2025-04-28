import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8081/api',
      headers: {'Content-Type': 'application/json'},
      extra: {'withCredentials': true},
    ),
  );

  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    try {
      final res = await dio.get('/checkLogin');
      if (res.statusCode == 200 && res.data == 'Y') {
        setState(() {
          isLoggedIn = true;
        });
      }
    } catch (e) {
      print("로그인 확인 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/'),
                    child: const Text(
                      'STUDY CAFE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _navItem(context, 'Find Store', '/store'),
                      const SizedBox(width: 20),
                      _navItem(context, 'QnA', '/inquiry'),
                      const SizedBox(width: 20),
                      _navItem(context, 'Guides', '/guides'),
                    ],
                  ),
                  const Text(
                    'MY PAGE',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 200),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _menuButton(
                    'Account',
                    () => Navigator.pushNamed(context, '/account'),
                  ),
                  const SizedBox(width: 20),
                  _verticalDivider(),
                  const SizedBox(width: 20),
                  _menuButton(
                    'Reservation',
                    () => Navigator.pushNamed(context, '/reservationinfo'),
                  ),
                  const SizedBox(width: 20),
                  _verticalDivider(),
                  const SizedBox(width: 20),
                  _menuButton(
                    'Q&A',
                    () => Navigator.pushNamed(context, '/inquiryinfo'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, String text, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _menuButton(String title, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black, // 👉 글자색 명시
        minimumSize: const Size(360, 80), // 👉 너비와 높이 고정
        //padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 30),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      child: Text(title),
    );
  }

  Widget _verticalDivider() {
    return Container(width: 1, height: 280, color: Colors.black);
  }
}
