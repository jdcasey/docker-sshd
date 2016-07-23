FROM centos

MAINTAINER John Casey <jdcasey@commonjava.org>

ADD https://github.com/Yelp/dumb-init/releases/download/v1.1.1/dumb-init_1.1.1_amd64 /usr/local/bin/dumb-init

RUN yum -y update \
    && yum -y install lsof openssh-server openssh-client screen \
    && yum clean all \
    && chmod +x /usr/local/bin/* \
    && groupadd ssh \
    && useradd -g ssh ssh \
    && cp -rf /etc/skel /home/ssh \
    && mkdir /home/ssh/.ssh /var/log/ssh \
    && chown -R ssh.ssh /etc/ssh /home/ssh \
    && chmod 700 /home/ssh/.ssh 

EXPOSE 22

VOLUME /etc/ssh /home/ssh/.ssh /var/log/ssh

USER root

ENTRYPOINT ["/usr/local/bin/dumb-init", "/usr/sbin/sshd", "-D", "-E", "/var/log/ssh/sshd.log", "-o", "PermitRootLogin=no"]

