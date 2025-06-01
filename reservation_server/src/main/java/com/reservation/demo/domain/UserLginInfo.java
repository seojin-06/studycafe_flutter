package com.reservation.demo.domain;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
public class UserLginInfo {
    private String userId;
    private String userPw;
    private String userName;
    private String userEmail;
    private int pwErrCnt;
    private LocalDate regDt;
}
