package com.reservation.demo.service;

import com.reservation.demo.domain.BookingInfo;
import com.reservation.demo.domain.InquiryInfo;
import com.reservation.demo.dto.BaseUpdateResponse;
import com.reservation.demo.dto.BookingReq;
import com.reservation.demo.dto.BookingUpdateReq;
import com.reservation.demo.repository.BookingDAO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class BookingServiceImpl implements BookingService {
    private final BookingDAO bookingDAO;
    @Transactional
    @Override
    public BaseUpdateResponse bookingProcess(BookingReq params) throws Exception {
        BaseUpdateResponse res = new BaseUpdateResponse();
        log.info("booking request: {}", params.getSeatNumber());

        try {
            params.setBookingId(generateUniqueBookingId());
            bookingDAO.insertBooking(params);
        } catch (Exception e) {
            log.error("booking error: ", e);  // 예외 발생시 로그 기록
            throw new Exception("예약에 실패하였습니다.");
        }

        log.info("booking success: {}", params.getBookingId());
        res.setSuccYn("Y");
        return res;
    }

    public String generateUniqueBookingId() {
        String bookingId = UUID.randomUUID().toString().replace("-", "");
        while (bookingDAO.bookingIdExists(bookingId) > 0) {  // DB에서 이미 존재하는지 확인
            bookingId = UUID.randomUUID().toString().replace("-", "");
        }
        return bookingId;
    }

    @Transactional
    @Override
    public BaseUpdateResponse updateBooking(BookingUpdateReq params) throws Exception {
        BaseUpdateResponse res = new BaseUpdateResponse();

        try {
            bookingDAO.updateBooking(params);
        } catch (Exception e) {
            log.error("booking update error: ", e);  // 예외 발생시 로그 기록
            throw new Exception("예약 수정에 실패하였습니다.");
        }

        res.setSuccYn("Y");
        return res;
    }

    @Transactional
    @Override
    public BaseUpdateResponse cancelBooking(String bookingId) throws Exception {
        BaseUpdateResponse res = new BaseUpdateResponse();

        log.info("bookingId: {}", bookingId);
        BookingInfo bookingInfo = bookingDAO.selectBookingById(bookingId);

        if (bookingInfo == null) {
            throw new Exception("해당 예약을 찾을 수 없습니다.");
        }

        // 예약 취소
        try {
            bookingDAO.cancelBooking(bookingId);
        } catch (Exception e) {
            log.error("booking update error: ", e);  // 예외 발생시 로그 기록
            throw new Exception("예약 취소에 실패하였습니다.");
        }

        res.setSuccYn("Y");
        return res;
    }

    @Transactional
    @Override
    public BookingInfo getBookingById(String bookingId) {
        return bookingDAO.selectBookingById(bookingId);
    }

    @Transactional
    @Override
    public List<BookingInfo> getReservedSeats(LocalDate usingDate, LocalDateTime checkin, LocalDateTime checkout) {
        log.info("reserved seat inquiry request: usingDate={}, checkin={}, checkout={}", usingDate, checkin, checkout);
        List<BookingInfo> reservedSeats = bookingDAO.selectReservedSeats(usingDate, checkin, checkout);

        if (reservedSeats.isEmpty()) {
            log.info("no reserved seat.");
        } else {
            log.info("reserved seats: {}", reservedSeats.size());
        }

        return reservedSeats;
    }
}
