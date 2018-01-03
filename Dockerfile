FROM centos:7

ENTRYPOINT [ "/init" ]

ENV DOCKERGEN_VERSION 0.7.3
ENV FILEBEAT_VERSION 6.1.1

RUN yum -y install epel-release \
        && yum -y install supervisor \
        && yum -y install https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-x86_64.rpm \
        && yum -y clean all

RUN curl -fsSL https://github.com/jwilder/docker-gen/releases/download/${DOCKERGEN_VERSION}/docker-gen-linux-amd64-${DOCKERGEN_VERSION}.tar.gz \
        | tar -xzf - -C /usr/bin

COPY docker/ /
