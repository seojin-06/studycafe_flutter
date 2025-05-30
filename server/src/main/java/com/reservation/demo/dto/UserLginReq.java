package com.reservation.demo.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.validation.constraints.NotEmpty;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@JsonIgnoreProperties(ignoreUnknown = true)
public class UserLginReq extends BaseReq {
    @NotEmpty
    private String userId; // 사용자ID

    @NotEmpty
    private String userPw; // 사용자PW
}
