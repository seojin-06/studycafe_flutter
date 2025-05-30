package com.reservation.demo.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum PaymentType {
    CREDIT_CARD,  // 신용카드
    DEBIT_CARD,   // 직불카드
    BANK_TRANSFER, // 계좌이체
    PAYPAL,       // 페이팔
    KAKAO_PAY,     // 카카오페이
    NAVER_PAY      // 네이버페이
}
