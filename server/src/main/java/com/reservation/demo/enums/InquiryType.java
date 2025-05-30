package com.reservation.demo.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum InquiryType {
    BOOKING("예약 관련"),
    PAYMENT("결제 관련"),
    CANCELLATION("취소 관련"),
    GENERAL("일반 문의");

    final String description;
}
