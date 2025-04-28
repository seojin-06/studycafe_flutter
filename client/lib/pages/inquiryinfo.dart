import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'inquirydetail_page.dart';

class InquiryInfoPage extends StatefulWidget {
  const InquiryInfoPage({super.key});

  @override
  State<InquiryInfoPage> createState() => _InquiryInfoPageState();
}

class _InquiryInfoPageState extends State<InquiryInfoPage> {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8081/api',
      headers: {'Content-Type': 'application/json'},
      extra: {"withCredentials": true}, // 세션 유지
    ),
  );

  List<Map<String, dynamic>> inquiries = [];

  @override
  void initState() {
    super.initState();
    loadInquiries();
  }

  Future<void> loadInquiries() async {
    try {
      final res = await dio.get('/user/inquiries');
      setState(() {
        inquiries = List<Map<String, dynamic>>.from(res.data);
      });
    } catch (e) {
      print("문의내역 조회 실패: $e");
    }
  }

  Future<void> cancelInquiry(String inquiryId) async {
    try {
      await dio.post(
        '/user/board/inquiryDeleteProc',
        data: {'inquiryId': inquiryId},
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("문의가 성공적으로 취소되었습니다.")));
      loadInquiries(); // 리스트 다시 불러오기
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

            // ✅ Q&A 제목
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Q&A',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Divider(height: 30, thickness: 1),

            // ✅ 문의 리스트
            Expanded(
              child:
                  inquiries.isEmpty
                      ? const Center(
                        child: Text(
                          "내역이 없습니다",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        itemCount: inquiries.length,
                        itemBuilder: (context, index) {
                          final inquiry = inquiries[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => InquiryDetailPage(
                                                  inquiryId:
                                                      inquiry['inquiryId'],
                                                ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Title: ${inquiry['inquiryTitle']}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Type: ${inquiry['inquiryType']['description']}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed:
                                      () => cancelInquiry(inquiry['inquiryId']),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                  ),
                                  child: const Text('Cancel QnA'),
                                ),
                              ],
                            ),
                          );
                        },
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
}
