package com.reservation.demo.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.reservation.demo.enums.InquiryType;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@JsonIgnoreProperties(ignoreUnknown = true)
public class InquiryUpdateReq {
    @NotNull
    private String inquiryId; // PK 또는 유일값

    @NotNull
    private String userId;   // 어떤 유저의 문의인지 연결

    private InquiryType inquiryType; // 문의 유형 (예: 예약 관련, 결제 관련 등)
    private String inquiryTitle; // 문의 제목
    private String inquiryContent; // 문의 내용
}
