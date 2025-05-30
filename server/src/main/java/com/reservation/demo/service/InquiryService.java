package com.reservation.demo.service;

import com.reservation.demo.domain.InquiryInfo;
import com.reservation.demo.dto.BaseUpdateResponse;
import com.reservation.demo.dto.InquiryReq;
import com.reservation.demo.dto.InquiryUpdateReq;

public interface InquiryService {
    public BaseUpdateResponse inquiryProcess(InquiryReq params) throws Exception;  // 예약 생성
    public BaseUpdateResponse updateInquiry(InquiryUpdateReq params) throws Exception; // 예약 수정
    public BaseUpdateResponse cancelInquiry(String inquiryId) throws Exception;                     // 예약 취소
    public InquiryInfo getInquiryById(String bookingId);
}
