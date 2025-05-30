package com.reservation.demo.repository;

import com.reservation.demo.domain.*;
import com.reservation.demo.dto.UserLginReq;
import com.reservation.demo.dto.UserRegsReq;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface UserDAO {
    //아이디 로그인
    UserLginInfo selectLoginUser(final UserLginReq params);

    //비밀번호 오류 카운트 증가, 초기화
    void updateErrorCount(final UserLginReq params);
    void updateErrorCountZero(final UserLginReq params);

    //로그인 히스토리++
    void insertLoginUserHist(final UserLginHistVO params);

    //회원가입
    void insertUser(final UserRegsReq params);

    //아이디 중복 체크
    int ChkUserId(final String userId);

    //회원 정보 조회
    UserLginInfo selectUser(final String userId);

    //회원 정보 VO

    //회원탈퇴
    void deleteUser(final String userId);

    //예약 내역 조회
    List<BookingInfo> selectBookingByUserId(String userId);

    List<BookingInfo> selectUpcomingBookingByUserId(String userId);

    List<BookingInfo> selectPastBookingByUserId(String userId);

    //문의 내역 조회
    List<InquiryInfo> selectInquiryByUserId(String userId);
}
