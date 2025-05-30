package com.reservation.demo.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.reservation.demo.enums.InquiryType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@JsonIgnoreProperties(ignoreUnknown = true)
public class InquiryReq {
    private String inquiryId;

    @NotBlank  // 사용자 ID: null + "" + " " 다 막기
    private String userId;

    @NotBlank  // 제목도 null/빈 문자열 방지
    private String inquiryTitle;

    @NotNull   // Enum (문의 유형): null만 체크
    private InquiryType inquiryType;

    @NotBlank  // 내용도 비어있으면 안 됨
    private String inquiryContent;
}
