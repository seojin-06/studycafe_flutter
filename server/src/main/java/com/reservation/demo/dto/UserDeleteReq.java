package com.reservation.demo.dto;

import jakarta.validation.constraints.NotEmpty;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserDeleteReq {
    @NotEmpty
    private String userId; // 사용자ID

    @NotEmpty
    private String userPw; // 사용자PW
}
