package com.reservation.demo.controller;

import com.reservation.demo.domain.InquiryInfo;
import com.reservation.demo.domain.UserLginInfo;
import com.reservation.demo.domain.UserVO;
import com.reservation.demo.dto.BaseUpdateResponse;
import com.reservation.demo.dto.InquiryReq;
import com.reservation.demo.dto.InquiryUpdateReq;
import com.reservation.demo.dto.UserLginReq;
import com.reservation.demo.enums.InquiryType;
import com.reservation.demo.service.InquiryService;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api")
public class InquiryApiController {
    private final InquiryService inquiryService;

    @PostMapping("user/board/inquiryProc")
    @Operation(summary = "문의 작성", description = "문의 작성 처리")
    public BaseUpdateResponse inquiryProcess(@RequestBody @Validated InquiryReq params) throws Exception {
        log.info("inquiry request: {}", params.getInquiryTitle());
        return inquiryService.inquiryProcess(params);
    }

    @GetMapping("/user/inquiryTypes")
    @Operation(summary = "문의 타입 리스트 조회", description = "문의 등록할 때 필요한 문의 타입 리스트를 반환합니다.")
    public ResponseEntity<List<String>> getInquiryTypes() {
        List<String> inquiryTypes = Arrays.stream(InquiryType.values())
                .map(Enum::name)
                .toList();

        return ResponseEntity.ok(inquiryTypes);
    }

    @PostMapping("user/board/inquiryUpdateProc")
    @Operation(summary = "문의 수정", description = "문의 수정 처리")
    public BaseUpdateResponse updateInquiry(@RequestBody @Validated InquiryUpdateReq params) throws Exception {
        BaseUpdateResponse res = new BaseUpdateResponse();

        try {
            res = inquiryService.updateInquiry(params);
            log.info("inquiry update success");
        } catch (Exception e) {
            log.error("inquiry update fail: {}", e.getMessage(), e);  // 예외 전체 출력
            res.setSuccYn("N");
        }
        return res;
    }

    @PostMapping("user/board/inquiryDeleteProc")
    @Operation(summary = "문의 취소", description = "문의 취소 처리")
    public BaseUpdateResponse cancelInquiry(@RequestBody String inquiryIdRaw) throws Exception {
        String inquiryId = inquiryIdRaw.replaceAll(".*inquiryId\":\"(.*?)\".*", "$1").trim();
        BaseUpdateResponse res = new BaseUpdateResponse();

        try {
            res = inquiryService.cancelInquiry(inquiryId);
            log.info("inquiry Cancel success");
        } catch (Exception e) {
            log.error("inquiry Cancel fail: {}", e.getMessage(), e);  // 예외 전체 출력
            res.setSuccYn("N");
        }
        return res;
    }

    @GetMapping("/user/inquiryInfo/{inquiryId}")
    @Operation(summary = "문의 내역 확인", description = "문의 내역 확인 화면으로 이동")
    public ResponseEntity<?> inquiryInfo(@PathVariable("inquiryId") String inquiryId, HttpSession session) {
        log.info("inquiry detail info request - inquiryId: {}", inquiryId);

        InquiryInfo inquiryInfo = inquiryService.getInquiryById(inquiryId);

        if (inquiryInfo == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("문의 내역을 찾을 수 없습니다!");
        } else {
            log.info("inquiry info: {}", inquiryInfo);
            log.info("inquiry info: {}", inquiryInfo.getInquiryId());
        }

        return ResponseEntity.ok(inquiryInfo);
    }
}
