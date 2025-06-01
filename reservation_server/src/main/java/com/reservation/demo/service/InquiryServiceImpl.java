package com.reservation.demo.service;

import com.reservation.demo.domain.BookingInfo;
import com.reservation.demo.domain.InquiryInfo;
import com.reservation.demo.dto.BaseUpdateResponse;
import com.reservation.demo.dto.InquiryReq;
import com.reservation.demo.dto.InquiryUpdateReq;
import com.reservation.demo.repository.InquiryDAO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
@Slf4j
@RequiredArgsConstructor
public class InquiryServiceImpl implements InquiryService{
    private final InquiryDAO inquiryDAO;

    @Transactional
    @Override
    public BaseUpdateResponse inquiryProcess(InquiryReq params) throws Exception {
        BaseUpdateResponse res = new BaseUpdateResponse();
        log.info("inquiry request: {}", params.getInquiryTitle());

        try {
            params.setInquiryId(generateUniqueInquiryId());
            inquiryDAO.insertInquiry(params);
        } catch (Exception e) {
            log.error("inquiry error: ", e);  // 예외 발생시 로그 기록
            throw new Exception("문의 작성에 실패하였습니다.");
        }

        log.info("inquiry success: {}", params.getInquiryId());
        res.setSuccYn("Y");
        return res;
    }

    public String generateUniqueInquiryId() {
        String inquiryId = UUID.randomUUID().toString().replace("-", "");
        while (inquiryDAO.inquiryIdExists(inquiryId) > 0) {  // DB에서 이미 존재하는지 확인
            inquiryId = UUID.randomUUID().toString().replace("-", "");
        }
        return inquiryId;
    }


    @Transactional
    @Override
    public BaseUpdateResponse updateInquiry(InquiryUpdateReq params) throws Exception {
        BaseUpdateResponse res = new BaseUpdateResponse();

        try {
            inquiryDAO.updateInquiry(params);
        } catch (Exception e) {
            log.error("inquiry update error: ", e);  // 예외 발생시 로그 기록
            throw new Exception("문의 작성 수정에 실패하였습니다.");
        }

        res.setSuccYn("Y");
        return res;
    }

    @Transactional
    @Override
    public BaseUpdateResponse cancelInquiry(String inquiryId) throws Exception {
        BaseUpdateResponse res = new BaseUpdateResponse();
        log.info("inquiry delete request: inquiryId={}", inquiryId);

        InquiryInfo inquiryInfo = inquiryDAO.selectInquiryById(inquiryId);

        if (inquiryInfo == null) {
            throw new Exception("해당 문의를 찾을 수 없습니다.");
        }

        // 문의 취소
        try {
            inquiryDAO.cancelInquiry(inquiryId);
        } catch (Exception e) {
            log.error("booking update error: ", e);  // 예외 발생시 로그 기록
            throw new Exception("문의 취소에 실패하였습니다.");
        }

        res.setSuccYn("Y");
        return res;
    }

    @Transactional
    @Override
    public InquiryInfo getInquiryById(String inquiryId) {
        return inquiryDAO.selectInquiryById(inquiryId);
    }
}
