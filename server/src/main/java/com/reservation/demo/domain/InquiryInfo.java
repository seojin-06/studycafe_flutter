package com.reservation.demo.domain;

import com.reservation.demo.enums.InquiryType;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class InquiryInfo {
    private String inquiryId; // PK 또는 유일값
    private String userId;   // 어떤 유저의 문의인지 연결
    private String inquiryTitle; // 문의 제목
    private InquiryType inquiryType; // 문의 유형 (예: 예약 관련, 결제 관련 등)
    private String inquiryContent; // 문의 내용
}
