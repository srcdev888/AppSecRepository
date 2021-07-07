FROM psiinon/bodgeit:latest

# Support passing of CxIAST URL via argument, to be used to download the agent from CxIAST server
ARG IAST_URL=192.168.137.70:8380
ENV ENV_IAST_URL=${IAST_URL}

# Install curl and unzip packages
RUN apt-get -y update
RUN apt-get install -y curl unzip

# Download the CxIAST java agent to home folder
RUN curl -o /home/cxiast-java-agent.zip http://${ENV_IAST_URL}/iast/compilation/download/JAVA && \
    unzip /home/cxiast-java-agent.zip -d /home/cxiast-java-agent && \
    rm -rf /home/cxiast-java-agent.zip && \
    chmod +x /home/cxiast-java-agent/cx-launcher.jar

# Add the javaagent options to the tomcat catalina opts
ENV CATALINA_OPTS="-javaagent:/home/cxiast-java-agent/cx-launcher.jar -Xverify:none"