package com.reservation.demo.controller;

import com.reservation.demo.annotation.LoginCheck;
import com.reservation.demo.domain.UserVO;
import com.reservation.demo.session.SessionKeys;
import com.reservation.demo.session.SessionStore;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/api")
public class HomeController {
    @RequestMapping({"/", "/index"})
    public String mainPage(HttpSession session, Model model) {
        log.info("index session ID: {}", session.getId());
        UserVO userVO = (UserVO) session.getAttribute("USER_VO");
        log.info("index USER_VO: {}", userVO);
        model.addAttribute("USER_VO", userVO);
        return "index";
    }
}
