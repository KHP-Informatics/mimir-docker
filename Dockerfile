# start from a base ubuntu image
FROM ubuntu
MAINTAINER Cass Johnston <cassjohnston@gmail.com>

########
# Pre-reqs
########

RUN apt-get update \ 
    && apt-get install -y \
    ant \
    curl \
    openjdk-7-jdk \
    subversion \
    unzip 


RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN mkdir /opt/grails
RUN cd /opt/grails \ 
 && curl -L "https://github.com/grails/grails-core/releases/download/v2.2.3/grails-2.2.3.zip"  >  grails-2.2.3.zip \
 && unzip grails-2.2.3.zip \
 && export GRAILS_HOME=/opt/grails/grails-2.2.3 \
 && export PATH=$PATH:$GRAILS_HOME/bin \
 && export PATH=$PATH:$GRAILS_HOME/bin


#######
# Mimir
#######


RUN cd /opt && svn co http://svn.code.sf.net/p/gate/code/mimir/tags/5.0.1 mimir-5.0.1
RUN cd /opt/mimir-5.0.1 && ant


#EXPOSE 80
#
## We can't use apachectl as an entrypoint because it starts apache and then exits, taking your container with it. 
## Instead, use supervisor to monitor the apache process
#RUN mkdir -p /var/log/supervisor
#
#ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf 
#
#CMD ["/usr/bin/supervisord"]]
#


