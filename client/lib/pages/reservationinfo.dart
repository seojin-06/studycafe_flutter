import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ReservationInfoPage extends StatefulWidget {
  const ReservationInfoPage({super.key});

  @override
  State<ReservationInfoPage> createState() => _ReservationInfoPageState();
}

class _ReservationInfoPageState extends State<ReservationInfoPage> {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8081/api',
      headers: {'Content-Type': 'application/json'},
      extra: {"withCredentials": true}, // 세션 유지
    ),
  );

  List<dynamic> upcomingReservations = [];
  List<dynamic> pastReservations = [];
  bool isUpcoming = true;

  @override
  void initState() {
    super.initState();
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    try {
      final upcomingRes = await dio.get('/user/upcomingBookinginfo');
      final pastRes = await dio.get('/user/pastBookinginfo');

      print('업커밍 예약 데이터: ${upcomingRes.data}');
      print('과거 예약 데이터: ${pastRes.data}');

      setState(() {
        upcomingReservations = upcomingRes.data;
        pastReservations = pastRes.data;
      });
    } catch (e) {
      print('예약 내역 조회 오류: $e');
    }
  }

  Future<void> cancelReservation(String bookingId) async {
    try {
      await dio.post(
        '/booking/bookingCancelProc',
        data: {'bookingId': bookingId},
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("예약이 성공적으로 취소되었습니다.")));
      fetchReservations(); // 리스트 다시 불러오기
    } catch (e) {
      print("예약 취소 실패: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("예약 취소에 실패했습니다.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final reservations = isUpcoming ? upcomingReservations : pastReservations;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ✅ 상단 바
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

            // ✅ 예약 정보
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reservations',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _tab('Upcoming', true),
                        const SizedBox(width: 16),
                        _tab('Past', false),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 1),

                    // ✅ 리스트 or "내역이 없습니다"
                    Expanded(
                      child:
                          reservations.isEmpty
                              ? const Center(
                                child: Text(
                                  "내역이 없습니다",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                              : ListView.builder(
                                itemCount: reservations.length,
                                itemBuilder: (context, index) {
                                  final r = reservations[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Branch: ${r['branch']}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Check In: ${extractTime(r['checkin'])}',
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                'Check Out: ${extractTime(r['checkout'])}',
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                'Seat: ${r['seatNumber']}',
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                'Date: ${r['usingDate']}',
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (isUpcoming)
                                          ElevatedButton(
                                            onPressed:
                                                () => cancelReservation(
                                                  r['bookingId'],
                                                ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10,
                                                  ),
                                            ),
                                            child: const Text(
                                              'Cancel Reservation',
                                            ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _tab(String title, bool tabValue) {
    return GestureDetector(
      onTap: () => setState(() => isUpcoming = tabValue),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight:
              isUpcoming == tabValue ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, String title, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  String extractTime(String datetimeString) {
    try {
      final dateTime = DateTime.parse(datetimeString);
      return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return "시간 오류";
    }
  }
}
