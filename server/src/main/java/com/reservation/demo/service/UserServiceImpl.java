package com.reservation.demo.service;

import com.reservation.demo.domain.*;
import com.reservation.demo.dto.BaseUpdateResponse;
import com.reservation.demo.dto.UserDeleteReq;
import com.reservation.demo.dto.UserLginReq;
import com.reservation.demo.dto.UserRegsReq;
import com.reservation.demo.enums.ExceptType;
import com.reservation.demo.exception.YbBizException;
import com.reservation.demo.repository.TicketDAO;
import com.reservation.demo.repository.UserDAO;
import com.reservation.demo.utils.CryptoUtil;
import com.reservation.demo.utils.HttpRequestUtil;
import com.reservation.demo.utils.ObjectUtil;
import com.reservation.demo.utils.SessionUtil;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final UserDAO userDAO;
    private final TicketDAO ticketDAO;

    //로그인 처리
    @Transactional
    @Override
    public UserVO userLoginProcess(final UserLginReq params) {
        String userId = params.getUserId();
        String userPw = params.getUserPw();
        log.info("login request: userId={}", userId); // 로그인 시도한 아이디 로그

        //사용자 비밀번호 암호화
        params.setUserPw(CryptoUtil.encrypt(userPw));

        //아이디, 비밀번호 확인 쿼리
        UserLginInfo loginResult = userDAO.selectLoginUser(params);

        if(loginResult == null || ObjectUtil.isEmpty(loginResult)) {
            userDAO.updateErrorCount(params);
            throw new YbBizException(ExceptType.JOIN002); //아이디 또는 비밀번호를 잘못 입력
        } else {
            UserLginHistVO userLginHistVO = new UserLginHistVO(userId, HttpRequestUtil.getClientIP());
            userDAO.insertLoginUserHist(userLginHistVO);

            if(loginResult.getPwErrCnt() >= 5) {
                throw new YbBizException(ExceptType.LGIN003); //비밀 번호를 5회 이상 잘못 입력하셨습니다.
            } else {
                userDAO.updateErrorCountZero(params);

                HttpSession session = HttpRequestUtil.getSession();
                UserVO userVO = new UserVO();

                TicketInfo ticketInfo = ticketDAO.selectTicketInfoByUserId(userId);
                if (ticketInfo != null) {
                    log.info("ticket info: {}", ticketInfo.getTicketId());
                    log.info("ticket expired info: {}", ticketInfo.isExpired());

                    // 유효 기간 만료 체크도 여기서
                    if (ticketInfo.isExpired()) {
                        ticketDAO.updateTicketExpire(userId);
                        ticketInfo.setExpiredFlag(true);
                    }
                } else {
                    log.info("No ticket info");
                }

                session.setAttribute("userVO", userVO);
                this.setLoginResult(userVO, loginResult, ticketInfo);
            }
        }

        log.info("login success: session info={}", SessionUtil.getUserVO());
        return SessionUtil.getUserVO();
    }

    public void setLoginResult(UserVO userVO, UserLginInfo loginResult, TicketInfo ticketInfo) {
        userVO.setLginYn("Y");
        userVO.setLginData(loginResult);
        userVO.setTicketInfo(ticketInfo);

        SessionUtil.setUserVO(userVO);
        log.info("set session: {}", SessionUtil.getUserVO());
        log.info("lginData: {}", SessionUtil.getUserVO().getLginData());
    }

    @Transactional
    @Override
    public BaseUpdateResponse userJnProc(final UserRegsReq params) {
        BaseUpdateResponse res = new BaseUpdateResponse();
        String userId = params.getUserId();
        String userPw = params.getUserPw();
        String userPwChk = params.getUserPwChk();

        //아이디 중복체크
        if(this.idDupChk(userId)) {
            throw new YbBizException(ExceptType.JOIN004);
        }

        //비밀번호 동일 여부 체크
        if(!userPw.equals(userPwChk)) {
            throw new YbBizException(ExceptType.JOIN002);
        } else {
            userPw = CryptoUtil.encrypt(userPw);
            params.setUserPw(userPw);
        }

        try {
            userDAO.insertUser(params);
        } catch (Exception e) {
            throw new YbBizException(ExceptType.JOIN001);
        }

        res.setSuccYn("Y");
        return res;
    }

    public boolean idDupChk(final String id) {
        return userDAO.ChkUserId(id) > 0;
    }

    /*@Transactional
    @Override
    public List<BookingInfo> getBookingsByUserId(String userId) {
        return userDAO.selectBookingByUserId(userId);
    }*/

    @Transactional
    @Override
    public BaseUpdateResponse userDeleteProc(UserDeleteReq params) {
        BaseUpdateResponse res = new BaseUpdateResponse();
        String userId = params.getUserId();
        String userPw = params.getUserPw();

        //사용자 비밀번호 암호화
        params.setUserPw(CryptoUtil.encrypt(userPw));

        UserLginInfo userChk = userDAO.selectUser(params.getUserId());

        if(userChk == null || ObjectUtil.isEmpty(userChk)) {
            throw new YbBizException(ExceptType.JOIN005); //아이디를 잘못 입력
        }

        if(!userChk.getUserPw().equals(params.getUserPw())) {
            throw new YbBizException(ExceptType.JOIN002); //비밀번호를 잘못 입력
        }

        userDAO.deleteUser(userId);
        res.setSuccYn("Y");
        return res;
    }

    @Transactional
    @Override
    public List<BookingInfo> getBookingsByUserId(String userId) {
        return userDAO.selectBookingByUserId(userId);
    }

    @Transactional
    @Override
    public List<BookingInfo> getUpcomingBookingsByUserId(String userId) {
        return userDAO.selectUpcomingBookingByUserId(userId);
    }

    @Transactional
    @Override
    public List<BookingInfo> getPastBookingsByUserId(String userId) {
        return userDAO.selectPastBookingByUserId(userId);
    }

    @Override
    public List<InquiryInfo> getInquiriesByUserId(String userId) {
        return userDAO.selectInquiryByUserId(userId);
    }

    @Transactional
    @Override
    public UserLginInfo getUserInfo(String userId) {
        return userDAO.selectUser(userId);
    }



}
