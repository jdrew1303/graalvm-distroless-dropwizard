package com.jdrew1303.tinywizard;

import io.dropwizard.Application;
import io.dropwizard.setup.Environment;

public class DemoApplication extends Application<DemoConfiguration> {
    public static void main(String[] args) throws Exception {
        new DemoApplication().run(args);
    }

    @Override
    public void run(DemoConfiguration config, Environment env) throws Exception {
        ExampleApi api = new ExampleApi();
        env.jersey().register(api);
    }
}
