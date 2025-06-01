package com.reservation.demo.controller;

import com.reservation.demo.domain.BookingInfo;
import com.reservation.demo.domain.UserVO;
import com.reservation.demo.dto.*;
import com.reservation.demo.enums.BranchType;
import com.reservation.demo.enums.InquiryType;
import com.reservation.demo.service.BookingService;
import com.reservation.demo.service.TicketService;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api")
public class BookingApiController {
    private final BookingService bookingService;

    @PostMapping("booking/bookingProc")
    @Operation(summary = "좌석 예약", description = "좌석 예약 처리")
    public BaseUpdateResponse bookingProcess(@RequestBody @Validated BookingReq params, HttpSession session) throws Exception {
        UserVO userVO = (UserVO) session.getAttribute("USER_VO");
        log.info("ticketinfo: {}", userVO.getTicketInfo());

        if (userVO.getTicketInfo() != null && !userVO.getTicketInfo().isExpired()) {
            log.info("booking request: {}", params.getUserId());
            return bookingService.bookingProcess(params);
        } else {
            throw new Exception("보유 중인 이용권이 없습니다. 이용권 구매 후 예약해주세요.");
        }
    }

    @GetMapping("/booking/reservedSeats")
    public ResponseEntity<List<String>> getReservedSeats(
            @RequestParam("usingDate") String dateStr,
            @RequestParam("checkIn") String checkInStr,
            @RequestParam("checkOut") String checkOutStr) {

        try {
            // 문자열로 들어온 걸 LocalDate/LocalDateTime으로 파싱
            LocalDate usingDate = LocalDate.parse(dateStr);
            LocalDateTime checkIn = LocalDateTime.parse(dateStr + "T" + checkInStr);
            LocalDateTime checkOut = LocalDateTime.parse(dateStr + "T" + checkOutStr);

            // 서비스 호출
            List<BookingInfo> reservedSeats = bookingService.getReservedSeats(usingDate, checkIn, checkOut);

            // BookingInfo에서 좌석 번호만 추출해서 반환
            List<String> seatNumbers = reservedSeats.stream()
                    .map(BookingInfo::getSeatNumber) // getSeatNumber()는 BookingInfo에 있어야 해
                    .toList();

            return ResponseEntity.ok(seatNumbers);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/booking/branchTypes")
    public ResponseEntity<List<String>> getBranchTypes() {
        List<String> branchTypes = Arrays.stream(BranchType.values())
                .map(Enum::name)
                .toList();

        return ResponseEntity.ok(branchTypes);
    }

    @PostMapping("booking/bookingUpdateProc")
    @Operation(summary = "예약 수정", description = "예약 수정 처리")
    public BaseUpdateResponse updateBooking(@RequestBody @Validated BookingUpdateReq params) throws Exception {
        BaseUpdateResponse res = new BaseUpdateResponse();

        try {
            res = bookingService.updateBooking(params);
            log.info("booking Update success");
        } catch (Exception e) {
            log.error("booking Update fail: {}", e.getMessage(), e);  // 예외 전체 출력
            res.setSuccYn("N");
        }
        return res;
    }

    @PostMapping("booking/bookingCancelProc")
    @Operation(summary = "예약 취소", description = "예약 취소 처리")
    public BaseUpdateResponse cancelBooking(@RequestBody String bookingIdRaw) throws Exception {
        String bookingId = bookingIdRaw.replaceAll(".*bookingId\":\"(.*?)\".*", "$1").trim();

        BaseUpdateResponse res = new BaseUpdateResponse();

        try {
            res = bookingService.cancelBooking(bookingId);
            log.info("booking Cancel success");
        } catch (Exception e) {
            log.error("booking Cancel fail: {}", e.getMessage(), e);  // 예외 전체 출력
            res.setSuccYn("N");
        }
        return res;
    }
}
