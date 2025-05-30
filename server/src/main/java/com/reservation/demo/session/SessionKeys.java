package com.reservation.demo.session;

import com.reservation.demo.domain.UserVO;
import lombok.RequiredArgsConstructor;

//세션 키 상수 관리
//세션 키 값을 한 곳에서 관리하여 실수를 줄임
@RequiredArgsConstructor
public enum SessionKeys {
    USER_VO("회원정보", UserVO.class);

    public final String desc;
    public final Class usageClass;
}
