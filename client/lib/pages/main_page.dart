import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isLoggedIn = false;
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8081/api',
      headers: {'Content-Type': 'application/json'},
      extra: {"withCredentials": true}, // 쿠키를 포함하기 위한 설정
    ),
  );

  @override
  void initState() {
    super.initState();
    getMainData(); // 메인 데이터 가져오기
    checkLogin();
  }

  void checkLogin() async {
    try {
      final res = await dio.get(
        '/checkLogin',
      ); // baseUrl + /checkLogin = full URL

      if (res.statusCode == 200 && res.data == 'Y') {
        setState(() {
          isLoggedIn = true;
        });
      } else {
        print("로그인 상태 아님");
      }
    } catch (e) {
      print("로그인 확인 중 에러 발생: $e");
    }
  }

  Future<void> getMainData() async {
    try {
      final res = await dio.get('/index');
      print("메인 페이지 응답: ${res.data}");
    } catch (e) {
      print("메인 데이터 불러오기 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    getMainData();

    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/main_background.png', // 👉 이 파일은 assets 폴더에 있어야 함
              fit: BoxFit.cover,
            ),
          ),

          // 상단 내비게이션
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 왼쪽
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'STUDY CAFE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  // 중앙
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _navButton(context, 'Find Store', '/store'),
                        const SizedBox(width: 20),
                        _navButton(context, 'QnA', '/inquiry'),
                        const SizedBox(width: 20),
                        _navButton(context, 'Guides', '/guides'),
                      ],
                    ),
                  ),
                  // 오른쪽
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (!isLoggedIn)
                          _navTextButton(
                            context,
                            'LOG IN',
                            '/login',
                            light: true,
                          )
                        else
                          _navLogoutButton(context),
                        const SizedBox(width: 10),
                        if (!isLoggedIn)
                          _navTextButton(
                            context,
                            'SIGN UP',
                            '/signup',
                            light: false,
                          )
                        else
                          _navTextButton(
                            context,
                            'MY PAGE',
                            '/mypage',
                            light: false,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isLoggedIn)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 250),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _mainActionButton(
                      context,
                      'Ticket Buy',
                      '/ticket',
                      light: true,
                    ),
                    const SizedBox(width: 20),
                    _mainActionButton(
                      context,
                      'Seat Reservation',
                      '/reservation',
                      light: false,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _navLogoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          final res = await dio.post('/user/logoutProc'); // 🔥 로그아웃 요청

          if (res.statusCode == 200) {
            // 로그아웃 성공 시 → 로그인 상태 변경 및 메인 이동
            setState(() {
              isLoggedIn = false;
            });
            Navigator.pushReplacementNamed(context, '/');
          } else {
            print("로그아웃 실패: ${res.statusCode}");
          }
        } catch (e) {
          print("로그아웃 중 오류 발생: $e");
        }
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(fontSize: 14),
      ),
      child: const Text("LOG OUT"),
    );
  }

  Widget _navButton(BuildContext context, String title, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      ),
    );
  }

  Widget _navTextButton(
    BuildContext context,
    String title,
    String route, {
    required bool light,
  }) {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, route),
      style: ElevatedButton.styleFrom(
        elevation: 0, // ✅ 그림자 제거!
        backgroundColor: light ? Colors.grey[200] : Colors.black,
        foregroundColor: light ? Colors.black : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(fontSize: 14),
      ),
      child: Text(title),
    );
  }

  Widget _mainActionButton(
    BuildContext context,
    String title,
    String route, {
    required bool light,
  }) {
    return SizedBox(
      width: 300, // ✅ 버튼 너비 고정
      height: 60, // ✅ 높이도 맞출 수 있음 (선택)
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, route),
        style: ElevatedButton.styleFrom(
          backgroundColor: light ? Colors.white : Colors.black,
          foregroundColor: light ? Colors.black : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(title),
      ),
    );
  }
}
