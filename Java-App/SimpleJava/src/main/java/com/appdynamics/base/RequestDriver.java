package com.appdynamics.base;

/**
 * Created by jennifer.li on 4/24/16.
 */

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import java.net.MalformedURLException;
import java.net.URL;

@Path("/")
public class RequestDriver {

    @GET
    @Path("/crossnodeapp")
    @Produces(MediaType.TEXT_PLAIN)
    public String crossNodeApp() {
        String response = new String();
        try {
            response = GetResponseHeader.getResponseHeaer(new URL("http://nodejs_app:3000"));
            System.out.println(response);
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
        return response;
    }

    @GET
    @Path("/crosspythonapp")
    @Produces(MediaType.TEXT_PLAIN)
    public String crossPythonApp() {
        String response = new String();
        try {
            response = GetResponseHeader.getResponseHeaer(new URL("http://python_app:9000"));
            System.out.println(response);
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
        return response;
    }

    @GET
    @Path("/crossphpapp")
    @Produces(MediaType.TEXT_PLAIN)
    public String crossPHPApp() {
        String response = new String();
        try {
            response = GetResponseHeader.getResponseHeaer(new URL("http://php_app:80/info.php"));
            System.out.println(response);
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
        return response;
    }
}
