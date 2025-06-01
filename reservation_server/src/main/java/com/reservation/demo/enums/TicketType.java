package com.reservation.demo.enums;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.time.LocalDate;
import java.time.Period;

@Getter
@RequiredArgsConstructor
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum TicketType {

    DAY_PASS(10000, Period.ofDays(1)),
    MONTHLY_PASS(200000, Period.ofMonths(1)),
    YEARLY_PASS(2000000, Period.ofYears(1));

    private final int price;
    private final Period validityPeriod;

    public LocalDate calculateExpireDate(LocalDate purchaseDate) {
        return purchaseDate.plus(validityPeriod);
    }
}

