package com.reservation.demo.domain;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serial;
import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
public class UserVO implements Serializable {
    @Serial
    private static final long serialVersionUID = 2359662639401792272L;

    private String lginYn;
    private TicketInfo ticketInfo;
    private UserLginInfo lginData;
}
