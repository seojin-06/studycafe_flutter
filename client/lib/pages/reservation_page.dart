import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8081/api',
      headers: {'Content-Type': 'application/json'},
      extra: {"withCredentials": true},
    ),
  );

  String? selectedDate;
  String? selectedCheckIn;
  String? selectedCheckOut;
  String? userId;

  List<String> branchList = []; // 서버에서 받아올 branch 목록
  List<String> timeOptions = [];
  Set<String> reservedSeats = {};
  String? selectedSeat;
  String? selectedBranch; // 선택한 branch

  final List<String> seats = [
    ...List.generate(8, (i) => 'A${i + 1}'),
    ...List.generate(8, (i) => 'B${i + 1}'),
    ...List.generate(8, (i) => 'C${i + 1}'),
  ];

  Future<void> loadBranchList() async {
    try {
      final res = await dio.get('/booking/branchTypes'); // 서버 URL 맞게 수정!
      setState(() {
        branchList = List<String>.from(res.data);
        if (branchList.isNotEmpty) {
          selectedBranch = branchList[0]; // 기본 첫 번째 선택
        }
      });
    } catch (e) {
      print('branch 리스트 불러오기 실패: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserInfo();
    loadBranchList();
    generateTimeOptions();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    selectedDate = today;
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

  void generateTimeOptions() {
    timeOptions.clear();
    final now = DateTime.now();
    DateTime start;

    if (selectedDate == DateFormat('yyyy-MM-dd').format(now)) {
      start = DateTime(now.year, now.month, now.day, now.hour, now.minute);
      start = start.add(Duration(minutes: 30 - start.minute % 30));
    } else {
      start = DateTime(now.year, now.month, now.day, 0, 0);
    }

    final end = DateTime(now.year, now.month, now.day, 23, 30);

    while (start.isBefore(end) || start.isAtSameMomentAs(end)) {
      timeOptions.add(DateFormat('HH:mm').format(start));
      start = start.add(const Duration(minutes: 30));
    }

    setState(() {
      selectedCheckIn = null;
      selectedCheckOut = null;
    });
  }

  Future<void> loadReservedSeats() async {
    if (selectedDate == null ||
        selectedCheckIn == null ||
        selectedCheckOut == null)
      return;
    try {
      final res = await dio.get(
        '/booking/reservedSeats',
        queryParameters: {
          'usingDate': selectedDate,
          'checkIn': selectedCheckIn,
          'checkOut': selectedCheckOut,
        },
      );
      reservedSeats = Set<String>.from(res.data);
      selectedSeat = null;
      setState(() {});
    } catch (e) {
      print('예약된 좌석 불러오기 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildLabel('Branch'),
              _buildBranchDropdown(),
              _buildLabel('Use Date'),
              _buildDatePicker(),
              _buildLabel('Check-in'),
              _buildTimeDropdown(isCheckIn: true),
              _buildLabel('Check-out'),
              _buildTimeDropdown(isCheckIn: false),

              _buildLabel('Select Seat'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: _buildSeatGrid(), // 이제 이거는 Expanded가 아님
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _grayButton('Check Out', _checkout),
                  const SizedBox(width: 20),
                  _grayButton('Go back', () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBranchDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: DropdownButton<String>(
        value: selectedBranch,
        isExpanded: true,
        hint: const Text('지점 선택'),
        items:
            branchList.map((branch) {
              return DropdownMenuItem(value: branch, child: Text(branch));
            }).toList(),
        onChanged: (value) {
          setState(() {
            selectedBranch = value;
          });
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
            children: [
              _navItem(context, 'Find Store', '/store'),
              const SizedBox(width: 20),
              _navItem(context, 'Ticket Type', '/ticket'),
              const SizedBox(width: 20),
              _navItem(context, 'Guides', '/guides'),
            ],
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/mypage'),
            child: const Text(
              'MY PAGE',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
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

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        readOnly: true,
        controller: TextEditingController(text: selectedDate),
        decoration: const InputDecoration(border: UnderlineInputBorder()),
        onTap: () async {
          final now = DateTime.now();
          final picked = await showDatePicker(
            context: context,
            initialDate: now,
            firstDate: now,
            lastDate: DateTime(now.year + 1),
          );
          if (picked != null) {
            selectedDate = DateFormat('yyyy-MM-dd').format(picked);
            generateTimeOptions();
            loadReservedSeats();
          }
        },
      ),
    );
  }

  Widget _buildTimeDropdown({required bool isCheckIn}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: DropdownButton<String>(
        value: isCheckIn ? selectedCheckIn : selectedCheckOut,
        isExpanded: true,
        hint: Text(isCheckIn ? '체크인 시간 선택' : '체크아웃 시간 선택'),
        items:
            timeOptions.map((time) {
              return DropdownMenuItem(value: time, child: Text(time));
            }).toList(),
        onChanged: (value) {
          setState(() {
            if (isCheckIn) {
              selectedCheckIn = value;
            } else {
              selectedCheckOut = value;
            }
            loadReservedSeats();
          });
        },
      ),
    );
  }

  Widget _buildSeatGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 10),
      crossAxisCount: 8,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1,
      children:
          seats.map((seat) {
            bool isDisabled = reservedSeats.contains(seat);
            bool isSelected = seat == selectedSeat;
            return GestureDetector(
              onTap:
                  isDisabled
                      ? null
                      : () {
                        setState(() {
                          selectedSeat = seat;
                        });
                      },
              child: Container(
                decoration: BoxDecoration(
                  color:
                      isDisabled
                          ? Colors.grey
                          : isSelected
                          ? Colors.black
                          : Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    seat,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
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

  void _checkout() async {
    if (selectedSeat == null ||
        selectedDate == null ||
        selectedCheckIn == null ||
        selectedCheckOut == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('모든 항목을 선택해주세요')));
      return;
    }

    try {
      final checkInDateTime = "$selectedDate" + "T" + "$selectedCheckIn";
      final checkOutDateTime = "$selectedDate" + "T" + "$selectedCheckOut";

      await dio.post(
        '/booking/bookingProc',
        data: {
          'userId': userId,
          'branch': selectedBranch,
          'seatNumber': selectedSeat,
          'usingDate': selectedDate,
          'checkin': checkInDateTime,
          'checkout': checkOutDateTime,
        },
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('예약이 완료되었습니다')));

      // 예약 성공 후 페이지 이동 (예: 예약 완료 페이지)
      Navigator.pushNamed(context, '/reservationcomplete');
    } catch (e) {
      print('예약 실패: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('예약에 실패했습니다')));
    }
  }
}
