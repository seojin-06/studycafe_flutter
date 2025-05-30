package com.reservation.demo.service;

import com.reservation.demo.domain.BookingInfo;
import com.reservation.demo.domain.InquiryInfo;
import com.reservation.demo.domain.UserLginInfo;
import com.reservation.demo.domain.UserVO;
import com.reservation.demo.dto.BaseUpdateResponse;
import com.reservation.demo.dto.UserDeleteReq;
import com.reservation.demo.dto.UserLginReq;
import com.reservation.demo.dto.UserRegsReq;

import java.util.List;

public interface UserService {
    UserVO userLoginProcess(UserLginReq params);
    BaseUpdateResponse userJnProc(UserRegsReq params);
    BaseUpdateResponse userDeleteProc(UserDeleteReq params);
    List<BookingInfo> getBookingsByUserId(String userId);
    List<BookingInfo> getUpcomingBookingsByUserId(String userId);
    List<BookingInfo> getPastBookingsByUserId(String userId);
    List<InquiryInfo> getInquiriesByUserId(String userId);
    UserLginInfo getUserInfo(String userId);
}
