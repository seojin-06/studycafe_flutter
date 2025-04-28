import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AccountInfoPage extends StatefulWidget {
  const AccountInfoPage({super.key});

  @override
  State<AccountInfoPage> createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8081/api',
      headers: {'Content-Type': 'application/json'},
      extra: {"withCredentials": true},
    ),
  );

  Map<String, dynamic>? user;
  Map<String, dynamic>? ticketInfo;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchUserTicketInfo();
  }

  Future<void> fetchUserInfo() async {
    try {
      final res = await dio.get('/user/userinfo');
      setState(() => user = res.data);
    } catch (e) {
      print('회원 정보 불러오기 실패: $e');
    }
  }

  Future<void> fetchUserTicketInfo() async {
    try {
      final res = await dio.get('/user/userticketinfo');
      setState(() => ticketInfo = res.data);
    } catch (e) {
      print('회원 티켓 정보 불러오기 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = user == null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            const SizedBox(height: 20),
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildUserInfoSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/'),
            child: const Text(
              'STUDY CAFE',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
    );
  }

  Widget _buildUserInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 박스
          Container(
            width: 180,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person, size: 80, color: Colors.grey),
                const SizedBox(height: 10),
                Text(
                  user?['userName'] ?? '이름 없음',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '✔ Email Confirmed',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 40),
          // 정보 섹션
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, ${user?['userName'] ?? 'User'}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("Joined in ${user?['regDt'] ?? '정보 없음'}"),
                const Divider(height: 30),
                _infoItem("USER ID:", user?['userId']),
                _infoItem("EMAIL:", user?['userEmail']),
                _infoItem("TICKET:", ticketInfo?['ticketTypeName'] as String?),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value ?? '정보 없음'),
        ],
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
