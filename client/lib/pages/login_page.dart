import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8081/api',
      headers: {'Content-Type': 'application/json'},
      extra: {"withCredentials": true}, // 쿠키를 포함하기 위한 설정
    ),
  );

  Future<void> login(String userId, String userPw) async {
    final response = await dio.post(
      '/user/loginProc',
      data: {"userId": userId, "userPw": userPw},
    );

    if (response.statusCode == 200) {
      final data = response.data;
      print("로그인 성공! 유저 정보: $data");

      //로그인 성공하면 홈으로 이동
      Navigator.pushReplacementNamed(context, '/');
    } else {
      print("로그인 실패");
      // 실패 alert 띄우기
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: const Text(
                      'STUDY CAFE',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
                    'SIGN UP',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 120), // ← 조절 가능
            const Text(
              'STUDY CAFE',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            _inputField(_idController, 'Id'),
            const SizedBox(height: 10),
            _inputField(_pwController, 'Password', isPassword: true),
            const SizedBox(height: 20),
            Container(
              width: 320,
              height: 48,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () async {
                  final userId = _idController.text;
                  final userPw = _pwController.text;

                  if (userId.isEmpty || userPw.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("아이디와 비밀번호를 모두 입력해주세요")),
                    );
                    return;
                  }

                  await login(userId, userPw);
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            Container(
              width: 320,
              height: 48,
              margin: const EdgeInsets.only(bottom: 80),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(
    TextEditingController controller,
    String hint, {
    bool isPassword = false,
  }) {
    return SizedBox(
      width: 320,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.grey),
          ),
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
}
