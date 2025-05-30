package com.reservation.demo.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@JsonIgnoreProperties(ignoreUnknown = true)
public class BookingReq {
    private String bookingId;

    @NotEmpty
    private String userId;

    @NotNull
    private String branch;

    @NotNull
    private String seatNumber;

    @NotNull
    private LocalDate usingDate;

    private LocalDateTime checkin;

    private LocalDateTime checkout;

    private String request;
}
