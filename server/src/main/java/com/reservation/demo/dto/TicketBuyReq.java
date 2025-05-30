package com.reservation.demo.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.reservation.demo.enums.TicketType;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@JsonIgnoreProperties(ignoreUnknown = true)
public class TicketBuyReq {

    private String ticketId;

    @NotEmpty
    private String userId;

    private LocalDate purchaseDate;

    private LocalDate expireDate;

    @NotEmpty
    private String paymentMethod;

    @NotNull
    private TicketType ticketType;

    private boolean isExpired;

    public void setExpireDate() {
        if (this.ticketType != null) {
            this.expireDate = LocalDate.now().plus(this.ticketType.getValidityPeriod());
        }
    }
}
