package com.reservation.demo.session;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import com.reservation.demo.enums.ExceptType;
import com.reservation.demo.exception.YbBizException;
import com.reservation.demo.utils.HttpRequestUtil;
import lombok.extern.slf4j.Slf4j;

import static com.reservation.demo.utils.HttpRequestUtil.getCurrentRequest;

//예시의 SessionStore역할
@Slf4j
public class SessionStore {

    private static HttpSession getSession() {
        HttpServletRequest request = getCurrentRequest();

        if (request == null) {
            log.error("getCurrentRequest()가 null을 반환했습니다!");
            return null;
        }

        HttpSession session = request.getSession();
        log.info("세션 ID: {}", session.getId());
        return session;
    }

    private static boolean exists(final SessionKeys sessionKeys) {
        return getSession().getAttribute(sessionKeys.name()) != null;
    }

    public static void put(final SessionKeys sessionKeys, final Object object) {
        if(!sessionKeys.usageClass.isInstance(object)) {
            throw new YbBizException(ExceptType.SESS001);
        }
        getSession().setAttribute(sessionKeys.name(), object);

        log.info("세션에 저장: key={}, value={}, JSESSIONID={}", sessionKeys.name(), object, getSession().getId());
    }

    public static void remove(final SessionKeys sessionKeys) {
        getSession().removeAttribute(sessionKeys.name());
    }

    public static Object get(final SessionKeys sessionKeys) {
        return exists(sessionKeys) ? getSession().getAttribute(sessionKeys.name()) : null;
    }

    public static <T> T getAs(SessionKeys sessionKeys, final Class<T> clazz) {
        if (!sessionKeys.usageClass.isAssignableFrom(clazz)) {
            throw new YbBizException(ExceptType.SESS001); // 세션타입이 일치하지 않습니다.
        }
        return (T) get(sessionKeys);
    }
}
