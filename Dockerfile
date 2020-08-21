FROM centos:centos7.2.1511
MAINTAINER adrianp@stindustries.net

# If you need to use a proxy to get to the internet, build with:
#   docker build --build-arg CURL_OPTIONS="..."
#
# The default is empty (no special options).
#
ARG CURL_OPTIONS=""

# Prep environment
#
RUN yum -y install deltarpm

# Install build utils
#
RUN touch /var/lib/rpm/* && \
    yum -y install bison gnutls-devel gcc libidn-devel gcc-c++ bzip2 && \
    yum clean all

# wget - command line utility (installed via. RPM)
#
# https://www.cvedetails.com/cve/CVE-2014-4877/
#
RUN curl -LO ${CURL_OPTIONS} \
      http://vault.centos.org/7.0.1406/os/x86_64/Packages/wget-1.14-10.el7.x86_64.rpm && \
    yum -y install wget-1.14-10.el7.x86_64.rpm && \
    rm *.rpm

# wget - command line utility (manual install)
#
# https://www.cvedetails.com/cve/CVE-2014-4877/
#
RUN curl -LO ${CURL_OPTIONS} \
      http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/wget/wget-1.15.tar.gz && \
    tar zxf wget-1.15.tar.gz && \
    cd wget-1.15 && \
    ./configure --prefix=/opt/wget && \
    make && \
    make install && \
    cd .. && \
    rm -rf wget-1.15 && \
    rm *.tar.gz

# hpack-2.1.1 - Python lib
#
# https://www.cvedetails.com/cve/CVE-2016-6581/
#
RUN curl -LO ${CURL_OPTIONS} \
          https://pypi.python.org/packages/8c/2b/e6e2f554368785c7eb68d618fd6457625be1535e807f6abf11c7db710f34/hpack-2.1.1.tar.gz && \
        tar xvf hpack-2.1.1.tar.gz && \
        mkdir /opt/hpack && \
        cd hpack-2.1.1 && \
        cp -R . /opt/hpack && \
        cd - && \
        rm -rf hpack-2.1.1 && \
        rm -f *.tar.gz
        
# Precautionary failure with messages
#
CMD echo 'Vulnerable image' && /bin/false

# Basic labels.
# http://label-schema.org/
#
LABEL \
    org.label-schema.name="bad-dockerfile" \
    org.label-schema.description="Reference Dockerfile containing software with known vulnerabilities." \
    org.label-schema.url="http://www.stindustries.net/docker/bad-dockerfile/" \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="https://github.com/ianmiell/bad-dockerfile" \
    org.label-schema.docker.dockerfile="/Dockerfile"
