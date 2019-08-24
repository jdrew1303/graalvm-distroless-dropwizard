FROM maven:3.6.0-jdk-8-alpine as builder
COPY  . /root/app/
WORKDIR /root/app
RUN mvn dependency:resolve
RUN mvn install

FROM oracle/graalvm-ce:1.0.0-rc16 as graalvm
COPY --from=builder /root/app/ /home/app/
WORKDIR /home/app
RUN native-image --allow-incomplete-classpath \
                -H:EnableURLProtocols=http \
                -H:+AllowVMInspection \
                -H:+ReportUnsupportedElementsAtRuntime \
                -H:ReflectionConfigurationFiles=src/main/docker/reflect.yml \
                -H:Name=tinywizard \
                -H:Class=com.jdrew1303.tinywizard.DemoApplication \
                -jar target/tinywizard.jar
RUN ls -lsh ./target
RUN chmod 777 tinywizard

# this is a special container for graalvm containing zlib, glibc, 
# libssl and openssl. these are used quite a bit by java applications
# (and graal applications).
FROM cescoffier/native-base:latest
EXPOSE 8080
COPY --from=graalvm /home/app/tinywizard .
CMD ["./tinywizard", "--report-unsupported-elements-at-runtime", ]
