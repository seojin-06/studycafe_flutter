package com.reservation.demo.utils;

import com.reservation.demo.domain.UserVO;
import com.reservation.demo.session.SessionKeys;
import com.reservation.demo.session.SessionStore;
import org.springframework.stereotype.Component;

@Component
public class SessionUtil {
    public static UserVO getUserVO() {
        UserVO userVO = SessionStore.getAs(SessionKeys.USER_VO, UserVO.class);
        return ObjectUtil.isEmpty(userVO) ? new UserVO() : userVO;
    }

    public static void setUserVO(UserVO userVO) {
        SessionStore.put(SessionKeys.USER_VO, userVO);
    }

    public static boolean isLogin() {
        return "Y".equals(getUserVO().getLginYn());
    }

    public static void removeUserVO() {
        SessionStore.remove(SessionKeys.USER_VO);
    }
}
