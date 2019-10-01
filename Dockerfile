FROM registry.access.redhat.com/ubi8/ubi

RUN INSTALL_PKGS="git npm maven java-11-openjdk-devel" && \
    yum install -y $INSTALL_PKGS && \
    yum clean all -y && \
    # configure to use java 11 by default
    alternatives --config java > /dev/null <<< 2 && \
    alternatives --config javac > /dev/null <<< 2

ENV S2I_ROOT=/usr/libexec/s2i
ENV APP_ROOT=/opt/app-root
ENV PATH=${APP_ROOT}/bin:${PATH}
ENV HOME=${APP_ROOT}

RUN mkdir -p ${APP_ROOT} ${APP_ROOT}/src ${APP_ROOT}/bin ${APP_ROOT}/lib
# we don't have permisson to create such a symbolic link in assmeble
RUN ln -sf ${APP_ROOT}/lib/web-client /web-client 

COPY ./s2i/bin/ ${S2I_ROOT}

RUN chmod +x ${S2I_ROOT}/* && \
    chmod -R u+x ${APP_ROOT}/bin && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} && \
    chmod -R g=u /etc/passwd

ENTRYPOINT [ "/usr/libexec/s2i/uid_entrypoint" ]

USER 10001

WORKDIR ${APP_ROOT}

LABEL io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"