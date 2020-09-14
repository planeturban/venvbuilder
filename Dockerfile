FROM centos:7

RUN yum -y update && yum -y install epel-release && yum -y install https://repo.ius.io/ius-release-el$(rpm -E '%{rhel}').rpm \
    yum install -y bzip2 \
    gcc-c++ \
    gettext \
    git2u \
    git2u-core \
    make \
    nodejs \
    python-setuptools \
    python-virtualenv && \
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
