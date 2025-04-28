import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class TicketPurchasePage extends StatefulWidget {
  const TicketPurchasePage({super.key});

  @override
  State<TicketPurchasePage> createState() => _TicketPurchasePageState();
}

class _TicketPurchasePageState extends State<TicketPurchasePage> {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8081/api',
      headers: {'Content-Type': 'application/json'},
      extra: {"withCredentials": true},
    ),
  );

  String? userId;
  List<String> ticketTypes = [];
  List<String> paymentMethods = [];

  String? selectedTicketType;
  String? selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
    loadTicketTypes();
    loadPaymentMethods();
  }

  Future<void> loadUserInfo() async {
    try {
      final res = await dio.get('/user/userinfo');
      setState(() {
        userId = res.data['userId'];
      });
    } catch (e) {
      print('user info 불러오기 실패: $e');
    }
  }

  Future<void> loadTicketTypes() async {
    try {
      final res = await dio.get('/ticketTypes');
      setState(() {
        ticketTypes = List<String>.from(res.data);
        if (ticketTypes.isNotEmpty) {
          selectedTicketType = ticketTypes.first;
        }
      });
    } catch (e) {
      print('ticket types 불러오기 실패: $e');
    }
  }

  Future<void> loadPaymentMethods() async {
    try {
      final res = await dio.get('/paymentTypes');
      setState(() {
        paymentMethods = List<String>.from(res.data);
        if (paymentMethods.isNotEmpty) {
          selectedPaymentMethod = paymentMethods.first;
        }
      });
    } catch (e) {
      print('payment methods 불러오기 실패: $e');
    }
  }

  Future<void> checkout() async {
    if (userId == null ||
        selectedTicketType == null ||
        selectedPaymentMethod == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('모든 항목을 선택해주세요')));
      return;
    }

    try {
      final res = await dio.post(
        '/ticketProc',
        data: {
          'userId': userId,
          'ticketType': selectedTicketType,
          'paymentMethod': selectedPaymentMethod,
        },
      );

      if (res.data['succYn'] == 'Y') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('구매가 완료되었습니다')));
        Navigator.pushNamed(context, '/');
      } else {
        // 성공했지만 서버 응답 결과 실패!
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('구매에 실패했습니다')));
      }
    } catch (e) {
      // 아예 통신 자체 실패 (500, 400, 404 등)
      print('구매 실패: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('구매에 실패했습니다')));
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

            // ✅ 구매자
            _titleWithDivider('User'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft, // 🔥 왼쪽 정렬
                child: Text(userId ?? '', style: const TextStyle(fontSize: 16)),
              ),
            ),

            const SizedBox(height: 10),

            // ✅ 이용권 선택
            _titleWithDivider('Ticket Type'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child:
                  ticketTypes.isEmpty
                      ? const CircularProgressIndicator()
                      : DropdownButton<String>(
                        value: selectedTicketType,
                        isExpanded: true,
                        items:
                            ticketTypes
                                .map(
                                  (type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedTicketType = value;
                          });
                        },
                      ),
            ),

            const SizedBox(height: 10),

            // ✅ 결제 방법 선택
            _titleWithDivider('Payment Method'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child:
                  paymentMethods.isEmpty
                      ? const CircularProgressIndicator()
                      : DropdownButton<String>(
                        value: selectedPaymentMethod,
                        isExpanded: true,
                        items:
                            paymentMethods
                                .map(
                                  (method) => DropdownMenuItem(
                                    value: method,
                                    child: Text(method),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = value;
                          });
                        },
                      ),
            ),

            const Spacer(),

            // ✅ 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _grayButton('Check out', checkout),
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
    );
  }

  Widget _titleWithDivider(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        const Divider(thickness: 1, height: 30),
      ],
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
      height: 50,
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
