FROM centos:7

RUN yum -y update && yum -y install epel-release && yum -y install https://centos7.iuscommunity.org/ius-release.rpm && \
    yum install -y bzip2 \
    gcc-c++ \
    gettext \
    git2u \
    git2u-core \
    make \
    nodejs \
    python36-setuptools \
    python36-virtualenv \
    rsync && \
    mkdir /app

ENV venvname ""
ENV venvpath "/opt/venvs/"
ENV packages ""

VOLUME /out

COPY scripts/make-venv.sh /app
RUN chmod +x /app/make-venv.sh

WORKDIR "/app/"

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/app/make-venv.sh"]
