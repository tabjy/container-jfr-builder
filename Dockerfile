FROM registry.access.redhat.com/ubi8/ubi

RUN yum install -y git npm maven java-11-openjdk-devel && \
    yum clean all && \
    alternatives --config java <<< 2 && \
    alternatives --config javac <<< 2

COPY ./s2i/bin/* /usr/libexec/s2i/

RUN chmod +x /usr/libexec/s2i/*

LABEL io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"

USER 10001
