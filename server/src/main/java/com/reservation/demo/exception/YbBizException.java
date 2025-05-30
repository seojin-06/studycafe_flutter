package com.reservation.demo.exception;

import com.reservation.demo.enums.ExceptType;
import lombok.Getter;

@Getter
public class YbBizException extends RuntimeException{
    private ExceptType error;

    //단순 생성자가 아니라 부모클래스인 Exception의 생성자도 호출하는 구조 -> super
    public YbBizException(ExceptType e) {
        //e에서 오류 메시지를 가져와서 부모 클래스인 exception에 저장
        super(e.getMessage());
        this.error = e;
    }
}
