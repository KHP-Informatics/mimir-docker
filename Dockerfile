# start from a base ubuntu image
FROM ubuntu
MAINTAINER Cass Johnston <cassjohnston@gmail.com>

#######
# Setup a user for this process
#######
RUN groupadd -r mimir 
RUN useradd -ms /bin/bash -g mimir mimir

########
# Pre-reqs
########

RUN apt-get update \ 
    && apt-get install -y \
    ant \
    curl \
    openjdk-7-jdk \
    subversion \
    unzip \
    vim 


RUN mkdir /opt/grails
RUN cd /opt/grails \ 
 && curl -L "https://github.com/grails/grails-core/releases/download/v2.2.3/grails-2.2.3.zip"  >  grails-2.2.3.zip \
 && unzip grails-2.2.3.zip 

ENV GRAILS_HOME /opt/grails/grails-2.2.3  
ENV PATH $PATH:$GRAILS_HOME/bin 
ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-amd64


#######
# Mimir
#######

USER mimir
ENV HOME /home/mimir

RUN cd /home/mimir && svn co http://svn.code.sf.net/p/gate/code/mimir/tags/5.0.1 mimir-5.0.1
# Seems to be a problem where we can't locate grails plugins, so we need to specify the mavenRepo
RUN cd /home/mimir/mimir-5.0.1/mimir-web/grails-app/conf && /bin/sed -i 's/mavenCentral()/mavenCentral()\n\tmavenRepo "https:\/\/repo.grails.org\/grails\/plugins"/' BuildConfig.groovy.template
RUN cd /home/mimir/mimir-5.0.1 && ant


EXPOSE 8080

WORKDIR /home/mimir/mimir-5.0.1/mimir-cloud
ENTRYPOINT ["grails", "prod", "run-app"]
