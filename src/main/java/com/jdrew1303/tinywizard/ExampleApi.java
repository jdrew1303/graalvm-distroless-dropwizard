package com.jdrew1303.tinywizard;

import com.codahale.metrics.annotation.Timed;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("/")
@Produces(MediaType.TEXT_PLAIN)
public class ExampleApi {

    @GET
    @Timed
    public String hello() {
        return "Boom! It's a tiny wizard app! :) ";
    }

}
