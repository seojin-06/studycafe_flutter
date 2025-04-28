import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class InquiryDetailPage extends StatefulWidget {
  final String inquiryId;

  const InquiryDetailPage({super.key, required this.inquiryId});

  @override
  State<InquiryDetailPage> createState() => _InquiryDetailPageState();
}

class _InquiryDetailPageState extends State<InquiryDetailPage> {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8081/api',
      headers: {'Content-Type': 'application/json'},
      extra: {"withCredentials": true}, // 세션 유지
    ),
  );

  Map<String, dynamic>? inquiryDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadInquiryDetail();
  }

  Future<void> loadInquiryDetail() async {
    try {
      final res = await dio.get('/user/inquiryInfo/${widget.inquiryId}');
      setState(() {
        inquiryDetail = res.data;
        isLoading = false;
      });
    } catch (e) {
      print("문의 상세 조회 실패: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> cancelInquiry() async {
    try {
      await dio.post(
        'api/user/board/inquiryDeleteProc',
        data: {'inquiryId': widget.inquiryId},
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("문의가 성공적으로 취소되었습니다.")));
      Navigator.pop(context); // 취소 후 이전 화면으로
    } catch (e) {
      print("문의 취소 실패: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("문의 취소에 실패했습니다.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ✅ 상단바 (InquiryInfoPage 스타일 복붙)
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

            // ✅ 문의 상세 내용
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : inquiryDetail == null
                      ? const Center(child: Text('문의 내역을 불러올 수 없습니다.'))
                      : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              inquiryDetail!['inquiryTitle'] ?? '제목 없음',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(height: 30, thickness: 1),
                            const SizedBox(height: 10),
                            Text(
                              inquiryDetail!['inquiryContent'] ?? '내용 없음',
                              style: const TextStyle(fontSize: 18),
                            ),
                            const Spacer(),

                            // ✅ 버튼 2개
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _grayButton('Cancel QnA', cancelInquiry),
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
