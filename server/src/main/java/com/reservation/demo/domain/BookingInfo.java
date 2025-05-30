package com.reservation.demo.domain;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
public class BookingInfo {
    private String bookingId;
    private String userId;

    private String branch;
    private String seatNumber;
    private LocalDate usingDate;
    private LocalDateTime checkin;
    private LocalDateTime checkout;
    private String request;
}
