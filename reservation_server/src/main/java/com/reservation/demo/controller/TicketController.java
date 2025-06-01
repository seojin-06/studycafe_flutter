package com.reservation.demo.controller;

import com.reservation.demo.domain.UserVO;
import com.reservation.demo.dto.BaseUpdateResponse;
import com.reservation.demo.dto.TicketBuyReq;
import com.reservation.demo.enums.InquiryType;
import com.reservation.demo.enums.PaymentType;
import com.reservation.demo.enums.TicketType;
import com.reservation.demo.service.TicketService;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/api")
public class TicketController {
    private final TicketService ticketService;

    @PostMapping("/ticketProc")
    @ResponseBody
    public BaseUpdateResponse ticketProcess(@RequestBody @Validated TicketBuyReq params) throws Exception {
        BaseUpdateResponse res = new BaseUpdateResponse();

        try {
            res = ticketService.purchaseTicket(params);
            log.info("ticket purchase success");
        } catch (Exception e) {
            log.error("ticket purchase fail: {}", e.getMessage(), e);
            res.setSuccYn("N");
        }

        return res; // 이제 이건 JSON으로 응답됨
    }

    @GetMapping("/ticketTypes")
    public ResponseEntity<List<String>> getTicketTypes() {
        List<String> ticketTypes = Arrays.stream(TicketType.values())
                .map(Enum::name)
                .toList();

        return ResponseEntity.ok(ticketTypes);
    }

    @GetMapping("/paymentTypes")
    public ResponseEntity<List<String>> getPaymentTypes() {
        List<String> paymentTypes = Arrays.stream(PaymentType.values())
                .map(Enum::name)
                .toList();

        return ResponseEntity.ok(paymentTypes);
    }
}
