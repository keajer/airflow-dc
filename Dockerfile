FROM keajer/ubuntu-python3.6.1
MAINTAINER kevinyukan@gmail.com

# Airflow
ENV AIRFLOW_VERSION=1.8.0
ENV AIRFLOW_HOME=/usr/local/airflow

RUN useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow

RUN pip3 install airflow[crypto,celery,postgres,hive,jdbc,s3]==$AIRFLOW_VERSION
RUN pip3 install redis

COPY scripts/airflow-webserver.conf /etc/init/
COPY scripts/boostrap.sh ${AIRFLOW_HOME}/boostrap.sh
COPY config/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg

# RUN apt-get install -y openssh-server sudo
# RUN sudo adduser airflow sudo

RUN chown -R airflow: ${AIRFLOW_HOME}

# use the project folder 
COPY  airflow-dags ${AIRFLOW_HOME}/dags
RUN pip3 install -r ${AIRFLOW_HOME}/dags/requirements.txt

USER airflow
WORKDIR ${AIRFLOW_HOME}
ENTRYPOINT ["./boostrap.sh"]
