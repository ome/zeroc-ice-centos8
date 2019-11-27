FROM centos:8
LABEL maintainer="ome-devel@lists.openmicroscopy.org.uk"

RUN yum install -y -q \
    bzip2-devel \
    expat-devel \
    gcc \
    gcc-c++ \
    libmcpp \
    make \
    openssl-devel \
    patch \
    python3 \
    python3-devel \
    python3-wheel \
    unzip

# Use the Ice 3.7 repo for mcpp-devel only
RUN curl -sSfL https://zeroc.com/download/ice/3.7/el8/zeroc-ice3.7.repo > /etc/yum.repos.d/zeroc-ice3.7.repo && \
    yum install -y -q mcpp-devel

RUN mkdir /dist
ADD build.sh src_dbinc_atomic.h.patch /
CMD ["/build.sh"]
