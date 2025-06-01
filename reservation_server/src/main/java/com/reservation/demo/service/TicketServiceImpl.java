package com.reservation.demo.service;

import com.reservation.demo.domain.TicketInfo;
import com.reservation.demo.domain.UserLginInfo;
import com.reservation.demo.domain.UserVO;
import com.reservation.demo.dto.BaseUpdateResponse;
import com.reservation.demo.dto.TicketBuyReq;
import com.reservation.demo.repository.TicketDAO;
import com.reservation.demo.repository.UserDAO;
import com.reservation.demo.utils.HttpRequestUtil;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class TicketServiceImpl implements TicketService{
    private final TicketDAO ticketDAO;
    private final UserDAO userDAO;

    @Transactional
    @Override
    public BaseUpdateResponse purchaseTicket(TicketBuyReq params) throws Exception {
        BaseUpdateResponse res = new BaseUpdateResponse();

        // 해당 유저가 이용권을 구매했는지 체크
        boolean isAvailable = ticketDAO.checkEnable(params.getUserId()) == 0;

        if (!isAvailable) {
            throw new Exception("이미 이용권을 구매하셨습니다.");
        }

        try {
            params.setTicketId(generateUniqueTicketId());
            params.setPurchaseDate(LocalDate.now());
            params.setExpireDate();
            params.setExpired(false);
            ticketDAO.insertTicket(params);
            ticketDAO.updateTicketPurchase(params.getUserId());
        } catch (Exception e) {
            log.error("ticket purchase error: ", e);  // 예외 발생시 로그 기록
            throw new Exception("예약에 실패하였습니다.");
        }

        // 티켓 구매 로직 끝난 뒤
        UserVO updatedUserVO = new UserVO();
        updatedUserVO.setLginYn("Y");
        UserLginInfo loginResult = userDAO.selectUser(params.getUserId());
        updatedUserVO.setLginData(loginResult);
        TicketInfo updatedTicket = ticketDAO.selectTicketInfoByUserId(params.getUserId());
        log.info("updatedTicket: {}", updatedTicket);
        updatedUserVO.setTicketInfo(updatedTicket);

        // 세션 갱신
        HttpSession session = HttpRequestUtil.getSession();
        session.setAttribute("USER_VO", updatedUserVO);
        log.info("session USER_VO update: {}", updatedUserVO.getLginData().getUserId());

        res.setSuccYn("Y");
        return res;
    }

    public String generateUniqueTicketId() {
        String bookingId = UUID.randomUUID().toString().replace("-", "");
        while (ticketDAO.ticketIdExists(bookingId) > 0) {  // DB에서 이미 존재하는지 확인
            bookingId = UUID.randomUUID().toString().replace("-", "");
        }
        return bookingId;
    }
}
