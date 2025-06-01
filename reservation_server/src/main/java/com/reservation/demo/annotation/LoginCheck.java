package com.reservation.demo.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface LoginCheck {
    boolean required() default false; // 로그인 체크 필수 여부
    boolean isMaster() default false; // 마스터 계정 권한 체크 여부
}
