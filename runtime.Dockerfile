FROM rh-jmc-team/container-jfr AS build

FROM registry.access.redhat.com/ubi8/ubi

RUN INSTALL_PKGS="java-11-openjdk" && \
    yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

ENV APP_ROOT=/opt/app-root
ENV PATH=${APP_ROOT}/bin:${PATH}
ENV HOME=${APP_ROOT}

COPY --from=build ${APP_ROOT}/bin/ ${APP_ROOT}/bin/
COPY --from=build ${APP_ROOT}/lib/ ${APP_ROOT}/lib/

USER 10001

ENV JAVA_OPTS="-Dcom.sun.management.jmxremote.port=9091 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
CMD [ "/opt/app-root/bin/container-jfr" ]
