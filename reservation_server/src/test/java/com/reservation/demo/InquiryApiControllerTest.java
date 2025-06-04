package com.reservation.demo;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
public class InquiryApiControllerTest {
    @Autowired
    private MockMvc mockMvc;

    @Test
    void inquiry_success() throws Exception {
        String json = """
             {
                 "userId": "userT",
                 "inquiryTitle": "좌석 예약 관련 문의드립니다.",
                 "inquiryType": "BOOKING",
                 "inquiryContent": "좌석 예약이 안돼요!"
             }
             """;

        mockMvc.perform(post("/api/user/board/inquiryProc")
                        .contentType(MediaType.APPLICATION_JSON)
                        .characterEncoding("UTF-8")
                        .content(json))
                .andExpect(status().isOk());
    }
}
