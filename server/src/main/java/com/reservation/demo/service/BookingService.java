package com.reservation.demo.service;

import com.reservation.demo.domain.BookingInfo;
import com.reservation.demo.domain.InquiryInfo;
import com.reservation.demo.dto.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public interface BookingService {
    public BaseUpdateResponse bookingProcess(BookingReq params) throws Exception;  // 예약 생성
    public BaseUpdateResponse updateBooking(BookingUpdateReq params) throws Exception; // 예약 수정
    public BaseUpdateResponse cancelBooking(String bookingId) throws Exception;                     // 예약 취소
    public BookingInfo getBookingById(String bookingId);
    public List<BookingInfo> getReservedSeats(LocalDate usingDate, LocalDateTime checkin, LocalDateTime checkout);
}
