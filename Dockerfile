FROM maven:3.6.0-jdk-8-alpine as builder
COPY  . /root/app/
WORKDIR /root/app
RUN mvn dependency:resolve
RUN mvn install

FROM oracle/graalvm-ce:1.0.0-rc14 as graalvm
COPY --from=builder /root/app/ /home/app/
WORKDIR /home/app
RUN native-image --no-server \
                 --class-path target/hello-world.jar \
                 -H:EnableURLProtocols=http \
                 -H:Name=hello-world \
                 -H:Class=com.jdrew1303.tinywizard.DemoApplication \
                 --allow-incomplete-classpath

# this is a special container for graalvm containing zlib, glibc, 
# libssl and openssl. these are used quite a bit by java applications
# (and graal applications).
FROM cescoffier/native-base:latest
EXPOSE 8080
COPY --from=graalvm /home/app/hello-world .
ENTRYPOINT ["./hello-world"]
