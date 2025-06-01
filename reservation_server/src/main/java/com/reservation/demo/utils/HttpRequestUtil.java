package com.reservation.demo.utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

public class HttpRequestUtil {
    //현재 request 가져오기
    public static HttpServletRequest getCurrentRequest() {
        try {
            return ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
        } catch (Exception e) {
            return null;
        }
    }

    //현재 세션 가져오기
    public static HttpSession getSession() {
        return getCurrentRequest().getSession();
    }

    //현재 클라이언트 접속 IP 가져오기
    public static String getClientIP() {
        HttpServletRequest request = getCurrentRequest();

        String ip = request.getHeader("X-Forwarded-For");

        if (ip == null) {
            ip = request.getHeader("Proxy-Client-IP");
        }

        if (ip == null) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }

        if (ip == null) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }

        if (ip == null) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }

        //최종적으로 모든 헤더에서 IP를 찾지 못하면 직접 가져온다
        //이 코드만으로는 클라이언트가 프록시나 VPN을 사용할 경우 제대로된 IP를 가져오지 못할 수 있음
        //위의 헤더를 추가로 체크해서 실제 클라이언트의 아이피를 가져오는 방식
        if (ip == null) {
            ip = request.getRemoteAddr();
        }

        return ip;
    }
}
