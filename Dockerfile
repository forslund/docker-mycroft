FROM ubuntu:18.04

ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive

RUN mkdir /opt/mycroft
# Install Server Dependencies for Mycroft
RUN set -x \
	&& sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get -y install git python3 python3-pip locales sudo \
	&& pip3 install future msm \
	# Checkout Mycroft
	&& git clone https://github.com/forslund/mycroft-core.git /opt/mycroft-core \
	&& cd /opt/mycroft-core \
        && git checkout testing/behave \
	&& mkdir /opt/mycroft/skills \
	# git fetch && git checkout dev && \ this branch is now merged to master
	&& CI=true /opt/mycroft-core/dev_setup.sh --allow-root -sm \
	&& apt-get -y autoremove \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl https://forslund.github.io/mycroft-desktop-repo/mycroft-desktop.gpg.key | apt-key add - 2> /dev/null && \
    echo "deb http://forslund.github.io/mycroft-desktop-repo bionic main" > /etc/apt/sources.list.d/mycroft-desktop.list
RUN apt-get update && apt-get install -y mimic

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /opt/mycroft-core
COPY startup.sh /opt/mycroft-core
ENV PYTHONPATH $PYTHONPATH:/mycroft/ai

RUN mkdir ~/.mycroft
RUN ./bin/mycroft-msm default
RUN touch /opt/mycroft/skills/.msm
RUN echo "PATH=$PATH:/opt/mycroft/bin" >> $HOME/.bashrc \
        && echo "source /opt/mycroft/.venv/bin/activate" >> $HOME/.bashrc

RUN chmod +x /opt/mycroft-core/start-mycroft.sh \
	&& chmod +x /opt/mycroft-core/startup.sh
EXPOSE 8181

ENTRYPOINT "/opt/mycroft-core/startup.sh"
