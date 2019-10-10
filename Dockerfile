FROM registry.access.redhat.com/ubi8/ubi

RUN INSTALL_PKGS="npm maven java-11-openjdk-devel" && \
    yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y
   
# configure to use java 11 by default
RUN alternatives --install /usr/bin/java java /usr/lib/jvm/java-11-openjdk/bin/java 0 && \
    alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-11-openjdk/bin/javac 0 && \
    alternatives --set java /usr/lib/jvm/java-11-openjdk/bin/java && \
    alternatives --set javac /usr/lib/jvm/java-11-openjdk/bin/javac

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk

ENV S2I_ROOT=/usr/libexec/s2i
ENV APP_ROOT=/opt/app-root
ENV PATH=${APP_ROOT}/bin:${PATH}
ENV HOME=${APP_ROOT}

RUN mkdir -p ${APP_ROOT} ${APP_ROOT}/src ${APP_ROOT}/bin ${APP_ROOT}/lib
# we don't have permisson to create such a symbolic link in assmeble
RUN ln -sf ${APP_ROOT}/lib/web-client /web-client 

ARG NPM_REGISTRY
ARG NPM_CA_FILE

RUN if [[ -n "$NPM_REGISTRY" ]]; then \
        echo "registry=$NPM_REGISTRY" >> $HOME/.npmrc; \
    fi

RUN if [[ -n "$NPM_CA_FILE" ]]; then \
        curl $NPM_CA_FILE -o $HOME/.npm-ca.cert && echo "cafile=$HOME/.npm-ca.cert" >> $HOME/.npmrc; \
    fi

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