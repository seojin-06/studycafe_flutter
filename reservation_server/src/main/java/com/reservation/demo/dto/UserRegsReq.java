package com.reservation.demo.dto;

import jakarta.validation.constraints.NotEmpty;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserRegsReq {
    @NotEmpty
    private String userId; // 사용자ID

    @NotEmpty
    private String userPw; // 사용자PW

    @NotEmpty
    private String userPwChk;

    @NotEmpty
    private String userName; // 사용자 이름

    @NotEmpty
    private String userEmail; // 사용자 이메일
}