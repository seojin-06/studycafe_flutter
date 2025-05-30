package com.reservation.demo.repository;

import com.reservation.demo.domain.TicketInfo;
import com.reservation.demo.dto.TicketBuyReq;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface TicketDAO {
    // 1. 이용권 추가
    void insertTicket(final TicketBuyReq params);

    // 2. 중복 구매 방지
    int checkEnable(final String userId);

    // 3. ticketId 중복 조회
    int ticketIdExists(final String ticketId);

    // 4. 이용권 구매 여부 업데이트
    void updateTicketPurchase(final String userId);

    // 5. 이용권 만료 여부 업데이트
    void updateTicketExpire(final String userId);

    TicketInfo selectTicketInfoByUserId(final String userId);
}
