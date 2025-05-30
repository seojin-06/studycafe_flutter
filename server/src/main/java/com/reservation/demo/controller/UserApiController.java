package com.reservation.demo.controller;

import com.reservation.demo.domain.*;
import com.reservation.demo.dto.BaseUpdateResponse;
import com.reservation.demo.dto.UserDeleteReq;
import com.reservation.demo.dto.UserLginReq;
import com.reservation.demo.dto.UserRegsReq;
import com.reservation.demo.service.UserService;
import com.reservation.demo.utils.SessionUtil;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.security.Principal;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api")
@Slf4j
public class UserApiController {
    private final UserService userService;

    @ResponseBody
    @PostMapping("/user/loginProc")
    @Operation(summary = "로그인", description = "로그인 처리")
    public UserVO userLoginProc(@RequestBody @Validated UserLginReq params) {
        System.out.println("login request data: " + params.toString());
        return userService.userLoginProcess(params);
    }

    @PostMapping("/user/logoutProc")
    public ResponseEntity<String> logoutProc(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return ResponseEntity.ok("logout complete");
    }
    @ResponseBody
    @PostMapping(value = "/user/jnProc")
    @Operation(summary = "회원가입", description = "회원가입 처리")
    public BaseUpdateResponse userJnProc(@RequestBody @Validated UserRegsReq params) {
        System.out.println("userJn request: " + params.toString());
        return userService.userJnProc(params);
    }

    @ResponseBody
    @DeleteMapping(value = "/user/delete/{userId}")
    @Operation(summary = "회원 탈퇴", description = "회원 탈퇴 후 로그아웃 처리")
    public BaseUpdateResponse userDeleteProc(@RequestBody @Validated UserDeleteReq params, HttpSession session) {
        session.invalidate();
        return userService.userDeleteProc(params);
    }

    @GetMapping("/checkLogin")
    public String checkLogin(HttpSession session) {
        UserVO userVO = (UserVO) session.getAttribute("USER_VO");
        return (userVO != null) ? "Y" : "N";
    }

    @GetMapping("/user/inquiries")
    @Operation(summary = "문의내역 조회", description = "로그인한 사용자의 문의 내역 JSON 반환")
    public ResponseEntity<?> getInquiryByUserId(HttpSession session) {
        UserVO userVO = (UserVO) session.getAttribute("USER_VO");

        if (userVO == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인 정보가 없습니다.");
        }

        List<InquiryInfo> inquiryList = userService.getInquiriesByUserId(userVO.getLginData().getUserId());
        return ResponseEntity.ok(inquiryList); // JSON으로 반환됨
    }

    @GetMapping("/user/userinfo")
    @Operation(summary = "회원 정보 확인", description = "회원 정보 페이지로 이동")
    public ResponseEntity<?> userInfo(HttpSession session) {
        UserVO userVO = (UserVO) session.getAttribute("USER_VO");

        if (userVO == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인 정보가 없습니다.");
        }

        UserLginInfo userLginInfo = userService.getUserInfo(userVO.getLginData().getUserId());

        return ResponseEntity.ok(userLginInfo);
    }

    @GetMapping("/user/userticketinfo")
    @Operation(summary = "회원 티켓 정보 확인", description = "회원 티켓 정보 페이지로 이동")
    public ResponseEntity<?> userTicketInfo(HttpSession session) {
        UserVO userVO = (UserVO) session.getAttribute("USER_VO");
        log.info("ticket info request: {}", userVO.getTicketInfo());

        if (userVO == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인 정보가 없습니다.");
        }

        if (userVO.getTicketInfo() != null && !userVO.getTicketInfo().isExpired()) {
            return ResponseEntity.ok(userVO.getTicketInfo());
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("티켓 정보가 없습니다.");
        }
    }

    @GetMapping("/user/upcomingBookinginfo")
    public ResponseEntity<?> getUpcomingBookingsByUserId(HttpSession session) {
        UserVO userVO = (UserVO) session.getAttribute("USER_VO");

        if (userVO == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인 정보가 없습니다.");
        }

        List<BookingInfo> bookingList = userService.getUpcomingBookingsByUserId(userVO.getLginData().getUserId());;
        return ResponseEntity.ok(bookingList); // JSON으로 반환됨
    }

    @GetMapping("/user/pastBookinginfo")
    public ResponseEntity<?> getPastBookingsByUserId(HttpSession session) {
        UserVO userVO = (UserVO) session.getAttribute("USER_VO");

        if (userVO == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인 정보가 없습니다.");
        }

        List<BookingInfo> bookingList = userService.getPastBookingsByUserId(userVO.getLginData().getUserId());;
        return ResponseEntity.ok(bookingList); // JSON으로 반환됨
    }
}
