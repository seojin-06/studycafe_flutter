package com.reservation.demo.repository;

import com.reservation.demo.domain.InquiryInfo;
import com.reservation.demo.domain.TicketInfo;
import com.reservation.demo.dto.InquiryReq;
import com.reservation.demo.dto.InquiryUpdateReq;
import com.reservation.demo.dto.TicketBuyReq;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface InquiryDAO {
    // 1. 이용권 추가
    void insertInquiry(final InquiryReq params);

    // 2. Id 중복 조회
    int inquiryIdExists(final String inquiryId);

    // 4. 특정 예약 상세 조회
    InquiryInfo selectInquiryById(final String inquiryId);

    // 5. 예약 수정 (날짜/객실 변경)
    void updateInquiry(final InquiryUpdateReq params);

    // 6. 예약 취소
    void cancelInquiry(final String inquiryId);
}
