FROM centos:7 (ub or ub8 : red hat universal base image)
MAINTAINER Sander <mail@yo.com>

# Add repo file

COPY ./yo.repo /etc/yum.repos.d/

# Install cool software

RUN yum --assumeyes update && \
yum --assumeyes install bash nmap iproute && \
yum clean all

ENTRYPOINT ["/usr/bin/nmap"]
CMD ["-sn", "172.17.0.0/24"] (these are arguments for entry point in exec format, it must be array style “arg1”, “arg2”, ”arg3”, so the entrypoint is nmap -sn 172.17.0.0/24)
