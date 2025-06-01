package com.reservation.demo.domain;

import com.reservation.demo.enums.TicketType;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
public class TicketInfo {
    private String ticketId; // PK 또는 유일값
    private String userId;   // 어떤 유저의 티켓인지 연결

    private LocalDate purchaseDate;
    private LocalDate expireDate;

    private String paymentMethod;

    private TicketType ticketType; // 예: 시간권, 기간권, 일일권 등

    private boolean expiredFlag;

    // 유틸 메서드
    public boolean isExpired() {
        return !expireDate.isAfter(LocalDate.now());
    }

    public String getTicketTypeName() {
        return ticketType.name();  // DAY_PASS, MONTHLY_PASS 이런거 리턴
    }
}
