package com.reservation.demo.config;

import com.reservation.demo.interceptor.LoginCheckInterceptor;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@RequiredArgsConstructor
@Configuration
public class WebConfig implements WebMvcConfigurer {
    //웹 구성에 대해 지정하는 내용이 담김
    //WebMvcConfig 인터페이스를 구현하여 이 파일을 작성

    private final LoginCheckInterceptor loginCheckInterceptor;

    @Override
    public void addResourceHandlers(final ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/static/**")  // static 리소스를 처리하는 경로
                .addResourceLocations("classpath:/static/");  // static 파일 위치
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(loginCheckInterceptor)
                .excludePathPatterns("/css/**")  // css 리소스를 제외
                .excludePathPatterns("/js/**")   // js 리소스를 제외
                .excludePathPatterns("/images/**");  // images 리소스도 제외하고 싶다면
    }

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("http://localhost:8083")  // 👈 Flutter 실행 포트
                .allowedMethods("*")
                .allowCredentials(true);
    }
}