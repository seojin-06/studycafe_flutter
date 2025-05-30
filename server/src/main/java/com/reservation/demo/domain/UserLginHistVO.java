package com.reservation.demo.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserLginHistVO {
    private String userId; // 유저 아이디
    private String ipAddr; // 아이피 주소
}
