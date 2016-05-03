package com.appdynamics.base;

import java.lang.reflect.Type;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

/**
 * Created by jennifer.li on 4/26/16.
 */
public class GetResponseHeader {
    public static String getResponseHeaer(URL url){
        StringBuilder response = new StringBuilder();

        try {
            Gson gson = new Gson();
            HttpURLConnection connection = (HttpURLConnection)url.openConnection();
            connection.setRequestMethod("GET");
            int statusCode = connection.getResponseCode();
            response.append("{\"status\": " + statusCode + ", " );

            // Get Header Fields
            Map<String, List<String>> header_map = connection.getHeaderFields();
            String header_json = gson.toJson(header_map);
            response.append("\"headers\":" + header_json + ",");

            connection.disconnect();

            // Get Request Fields
            Map<String, List<String>> request_map = connection.getRequestProperties();
            String request_json = gson.toJson(request_map);
            response.append("\"request\":" + request_json + "}");

        } catch (Exception e){
            response.append(e.toString());
            e.printStackTrace();
        }

        return response.toString();
    }
}
