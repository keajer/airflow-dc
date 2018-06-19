FROM keajer/ubuntu-python3.6.1
MAINTAINER kevinyukan@gmail.com

# Airflow
ENV AIRFLOW_VERSION=1.8.0
ENV AIRFLOW_HOME=/usr/local/airflow


RUN apt-get update
RUN apt-get install -y python3 python-dev python3-dev
RUN apt-get install -y build-essential libssl-dev libffi-dev libxml2-dev libxslt1-dev libsasl2-dev zlib1g-dev python-pip
RUN apt-get install -y python3-pip
RUN pip3 install --upgrade pip

RUN useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow

RUN pip3 install airflow[crypto,celery,postgres,hive,jdbc,s3]==$AIRFLOW_VERSION
RUN pip3 install redis

COPY workflow/scripts/boostrap.sh ${AIRFLOW_HOME}/boostrap.sh
COPY workflow/config/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg

COPY requirements.txt ${AIRFLOW_HOME}/requirements.txt

RUN pip3 install -r ${AIRFLOW_HOME}/requirements.txt

# RUN apt-get install -y openssh-server sudo
# RUN sudo adduser airflow sudo

RUN chown -R airflow: ${AIRFLOW_HOME}

COPY workflow/scripts/airflow-webserver.conf /etc/init/

# use the project folder 
# COPY worklow/dags ${AIRFLOW_HOME}/dags

USER airflow
WORKDIR ${AIRFLOW_HOME}
ENTRYPOINT ["./boostrap.sh"]
