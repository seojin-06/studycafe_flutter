| Path                              | Method | Tag                    | Summary             | Operation                   |
|-----------------------------------|--------|------------------------|---------------------|-----------------------------|
| /api/user/logoutProc              | POST   | user-api-controller    | 로그아웃            | logoutProc                  |
| /api/user/loginProc               | POST   | user-api-controller    | 로그인              | userLoginProc               |
| /api/user/jnProc                  | POST   | user-api-controller    | 회원가입            | userJnProc                  |
| /api/user/board/inquiryUpdateProc | POST   | inquiry-api-controller | 문의 수정           | updateInquiry               |
| /api/user/board/inquiryProc       | POST   | inquiry-api-controller | 문의 작성           | inquiryProcess              |
| /api/user/board/inquiryDeleteProc | POST   | inquiry-api-controller | 문의 취소           | cancelInquiry               |
| /api/ticketProc                   | POST   | ticket-controller      | 티켓 구매           | ticketProcess               |
| /api/booking/bookingUpdateProc    | POST   | booking-api-controller | 예약 수정           | updateBooking               |
| /api/booking/bookingProc          | POST   | booking-api-controller | 좌석 예약           | bookingProcess              |
| /api/booking/bookingCancelProc    | POST   | booking-api-controller | 예약 취소           | cancelBooking               |
| /api/user/userticketinfo          | GET    | user-api-controller    | 회원 티켓 정보 확인 | userTicketInfo              |
| /api/user/userinfo                | GET    | user-api-controller    | 회원 정보 확인      | userInfo                    |
| /api/user/upcomingBookinginfo     | GET    | user-api-controller    | 예약 예정 목록      | getUpcomingBookingsByUserId |
| /api/user/pastBookinginfo         | GET    | user-api-controller    | 예약 완료 목록      | getPastBookingsByUserId     |
| /api/user/inquiryTypes            | GET    | inquiry-api-controller | 문의 타입 리스트    | getInquiryTypes             |
| /api/user/inquiryInfo/{inquiryId} | GET    | inquiry-api-controller | 문의 내역 확인      | inquiryInfo                 |
| /api/user/inquiries               | GET    | user-api-controller    | 문의 내역 조회      | getInquiryByUserId          |
| /api/checkLogin                   | GET    | user-api-controller    | 로그인 확인         | checkLogin                  |
| /api/booking/reservedSeats        | GET    | booking-api-controller | 예약된 좌석 조회    | getReservedSeats            |
| /api/booking/branchTypes          | GET    | booking-api-controller | 지점 종류 조회      | getBranchTypes              |
| /api/user/delete/{userId}         | DELETE | user-api-controller    | 회원 탈퇴           | userDeleteProc              |
| /api/user/board/inquiryDeleteProc | POST   | inquiry-api-controller | 문의 취소           | cancelInquiry               |
| /api/ticketProc                   | POST   | ticket-controller      | 티켓 구매           | ticketProcess               |
| /api/booking/bookingUpdateProc    | POST   | booking-api-controller | 예약 수정           | updateBooking               |
| /api/booking/bookingProc          | POST   | booking-api-controller | 좌석 예약           | bookingProcess              |
| /api/booking/bookingCancelProc    | POST   | booking-api-controller | 예약 취소           | cancelBooking               |
| /api/user/userticketinfo          | GET    | user-api-controller    | 회원 티켓 정보 확인 | userTicketInfo              |
| /api/user/userinfo                | GET    | user-api-controller    | 회원 정보 확인      | userInfo                    |
| /api/user/upcomingBookinginfo     | GET    | user-api-controller    | 예약 예정 목록      | getUpcomingBookingsByUserId |
| /api/user/pastBookinginfo         | GET    | user-api-controller    | 예약 완료 목록      | getPastBookingsByUserId     |
| /api/user/inquiryTypes            | GET    | inquiry-api-controller | 문의 타입 리스트    | getInquiryTypes             |
| /api/user/inquiryInfo/{inquiryId} | GET    | inquiry-api-controller | 문의 내역 확인      | inquiryInfo                 |
| /api/user/inquiries               | GET    | user-api-controller    | 문의 내역 조회      | getInquiryByUserId          |
| /api/checkLogin                   | GET    | user-api-controller    | 로그인 확인         | checkLogin                  |
| /api/booking/reservedSeats        | GET    | booking-api-controller | 예약된 좌석 조회    | getReservedSeats            |
| /api/booking/branchTypes          | GET    | booking-api-controller | 지점 종류 조회      | getBranchTypes              |
| /api/user/delete/{userId}         | DELETE | user-api-controller    | 회원 탈퇴           | userDeleteProc              |
