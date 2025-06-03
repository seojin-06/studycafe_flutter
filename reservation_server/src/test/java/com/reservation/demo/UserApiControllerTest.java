package com.reservation.demo;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

@SpringBootTest
@AutoConfigureMockMvc
public class UserApiControllerTest {
    @Autowired
    private MockMvc mockMvc;

    @Test
    void testUserSignup_success() throws Exception {
        String json = """
                {
                    "userName": "testUser",
                    "userId": "userT",
                    "userPw": "1111",
                    "userPwChk": "1111",
                    "userEmail": "test@mail.com"
                }
                """;

        mockMvc.perform(post("/api/user/jnProc")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json))
                .andExpect(status().isOk());
    }

    @Test
    void testUserLogin_success() throws Exception {
        String json = """
        {
            "userId": "userT",
            "userPw": "w5WelLp/8Gyb3pQNLxbsoA=="
        }
        """;

        mockMvc.perform(post("/api/user/loginProc")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.userId").value("userT")); // 필요에 따라 수정
    }
}
