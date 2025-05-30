package com.reservation.demo.utils;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.springframework.util.ObjectUtils;

//json처리
public class ObjectUtil {
    private static final ObjectMapper objectMapper = new ObjectMapper();
    private static Gson gson = new Gson();

    //빈값 여부
    public static boolean isEmpty(Object obj) {
        return ObjectUtils.isEmpty(obj);
    }

    public static boolean isNotEmpty(Object obj) {
        return !ObjectUtils.isEmpty(obj);
    }

    //빈값일때 대체값 지정
    public static Object nvl(Object obj, String defaultValue) {
        return isNotEmpty(obj) ? obj : defaultValue;
    }

    public static <T> T jsonToObject(String jsonString, Class<T> clazz) throws Exception {
        return objectMapper.readValue(jsonString, clazz);
    }

    public static String objectToJsonString(Object obj) throws Exception{
        return objectMapper.writeValueAsString(obj);
    }

    public static JsonObject toJson(final String p) throws Exception {
        JsonParser jsonParser = new JsonParser();
        Object obj = jsonParser.parse(p);
        JsonObject jo = (JsonObject) obj;
        return jo;
    }
}
