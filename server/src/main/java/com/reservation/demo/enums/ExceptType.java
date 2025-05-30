package com.reservation.demo.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@Getter
@RequiredArgsConstructor
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum ExceptType {
    //ExceptType은 애플리케이션에서 발생하는 오류를 체계적으로 관리하는 Enum이야!
    //HttpStatus, 오류 코드, 메시지를 미리 정의해 두고 예외 발생 시 쉽게 사용할 수 있도록 도와줌
    //일관된 예외 처리를 가능하게 해서 유지보수성을 높여줌!

    //API 오류
    RUNTIME_EXCEPTION(HttpStatus.BAD_REQUEST, "E001", "런타임 오류가 발생하였습니다."),
    ACCESS_DENIED_EXCEPTION(HttpStatus.UNAUTHORIZED, "E0002", "권한이 없습니다."),
    INTERNAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "E0003", "서버 통신중 오류가 발생하였습니다."),

    //BIZ 오류
    //로그인
    LGIN001(HttpStatus.UNAUTHORIZED, "LGIN001", "로그인이 필요합니다."),
    LGIN002(HttpStatus.UNAUTHORIZED, "LGIN002", "아이디 또는 비밀번호를 잘못 입력하였습니다."),
    LGIN003(HttpStatus.UNAUTHORIZED, "LGIN003", "비밀번호 5회 이상 잘못 입력하였습니다."),

    //회원가입
    JOIN001(HttpStatus.UNAUTHORIZED, "JOIN001", "회원가입에 실패하였습니다."),
    JOIN002(HttpStatus.UNAUTHORIZED, "JOIN002", "비밀번호가 일치 하지 않습니다."),
    JOIN003(HttpStatus.UNAUTHORIZED, "JOIN003", "유효한 형태의 ID 또는 이름이 아닙니다."),
    JOIN004(HttpStatus.UNAUTHORIZED, "JOIN004", "중복된 ID 입니다."),
    JOIN005(HttpStatus.UNAUTHORIZED, "JOIN005", "아이디를 잘못 입력하였습니다."),

    //세션
    SESS001(HttpStatus.UNAUTHORIZED, "SESS001", "세션 타입이 일치하지 않습니다.");

    private final HttpStatus status;  // HTTP 상태 코드 (ex: 400, 401, 500 등)
    private final String code;        // 내부적으로 사용할 오류 코드 (ex: "E0001", "LGIN001" 등)
    private final String message;     // 클라이언트에게 보여줄 오류 메시지
}
