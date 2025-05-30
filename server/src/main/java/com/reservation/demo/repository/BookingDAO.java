package com.reservation.demo.repository;

import com.reservation.demo.domain.BookingInfo;
import com.reservation.demo.domain.InquiryInfo;
import com.reservation.demo.dto.BookingReq;
import com.reservation.demo.dto.BookingUpdateReq;
import com.reservation.demo.dto.InquiryReq;
import com.reservation.demo.dto.InquiryUpdateReq;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface BookingDAO {
    // 1. 예약 추가
    void insertBooking(final BookingReq params);

    // 2. Id 중복 조회
    int bookingIdExists(final String bookingId);

    // 4. 특정 예약 상세 조회
    BookingInfo selectBookingById(final String bookingId);

    // 5. 예약 수정 (날짜/객실 변경)
    void updateBooking(final BookingUpdateReq params);

    // 6. 예약 취소
    void cancelBooking(final String bookingId);

    // 7. 예약된 좌석 조회
    List<BookingInfo> selectReservedSeats(
            @Param("date") LocalDate date,
            @Param("checkIn") LocalDateTime checkIn,
            @Param("checkOut") LocalDateTime checkOut
    );
}
