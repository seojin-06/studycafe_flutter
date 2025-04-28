import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class InquiryPage extends StatefulWidget {
  const InquiryPage({super.key});

  @override
  State<InquiryPage> createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8081/api',
      headers: {'Content-Type': 'application/json'},
      extra: {"withCredentials": true},
    ),
  );

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  List<String> inquiryTypes = []; // 서버에서 받아올 문의 타입 리스트
  String? selectedInquiryType; // 선택된 문의 타입
  String? userId; // 사용자 ID

  @override
  void initState() {
    super.initState();
    loadInquiryTypes(); // 문의 타입 불러오기
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    try {
      final res = await dio.get('/user/userinfo');
      setState(() {
        userId = res.data['userId']; // 서버가 리턴해주는 userId
      });
    } catch (e) {
      print('user info 불러오기 실패: $e');
    }
  }

  Future<void> loadInquiryTypes() async {
    try {
      final res = await dio.get('/user/inquiryTypes');
      setState(() {
        inquiryTypes = List<String>.from(res.data);
        if (inquiryTypes.isNotEmpty) {
          selectedInquiryType = inquiryTypes.first;
        }
      });
    } catch (e) {
      print('문의 타입 불러오기 실패: $e');
    }
  }

  Future<void> submitInquiry() async {
    if (titleController.text.isEmpty ||
        contentController.text.isEmpty ||
        selectedInquiryType == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('모든 항목을 입력해주세요')));
      return;
    }

    try {
      await dio.post(
        '/user/board/inquiryProc',
        data: {
          'userId': userId,
          'inquiryTitle': titleController.text,
          'inquiryType': selectedInquiryType,
          'inquiryContent': contentController.text,
        },
      );

      // 등록 성공하면 완료페이지로 이동!
      Navigator.pushNamed(context, '/inquirycomplete');
    } catch (e) {
      print('문의 등록 실패: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('문의 등록에 실패했습니다')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ✅ 상단바
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
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/mypage'),
                    child: const Text(
                      'MY PAGE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ✅ 문의 작성 폼
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 제목 입력
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),

                    const Divider(thickness: 1, height: 30), // ✅ 회색선
                    // 문의 타입 선택
                    inquiryTypes.isEmpty
                        ? const CircularProgressIndicator()
                        : DropdownButton<String>(
                          value: selectedInquiryType,
                          items:
                              inquiryTypes
                                  .map(
                                    (type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedInquiryType = value;
                            });
                          },
                        ),

                    const Divider(thickness: 1, height: 30), // ✅ 회색선
                    // 내용 입력
                    Expanded(
                      child: TextField(
                        controller: contentController,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          hintText: '내용을 입력하세요',
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    // 버튼
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _grayButton('Register', submitInquiry),
                        const SizedBox(width: 20),
                        _grayButton('Go back', () {
                          Navigator.pop(context);
                        }),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, String title, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _grayButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: 160,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
