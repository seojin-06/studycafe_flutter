package com.reservation.demo.service;

import com.reservation.demo.domain.UserVO;
import com.reservation.demo.dto.BaseUpdateResponse;
import com.reservation.demo.dto.TicketBuyReq;
import com.reservation.demo.dto.UserLginReq;

public interface TicketService {
    // 이용권 구매
    BaseUpdateResponse purchaseTicket(TicketBuyReq params) throws Exception;
}
