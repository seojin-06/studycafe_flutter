package com.reservation.demo.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum BranchType {
    SEOUL_A,
    SEOUL_B,
    SEOUL_C,
    YONGIN_A,
    SUWON_A,
    SUWON_B
}
