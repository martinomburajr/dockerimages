FROM debian:latest

# Install git curl dnsutils wget openssh-server
RUN apt update && apt-get install -y git curl dnsutils wget openssh-server

# Install latest go
RUN wget https://raw.githubusercontent.com/canha/golang-tools-install-script/master/goinstall.sh && bash goinstall.sh --64

# Install JAVA
ENV DEBIAN_FRONTEND=noninteractive \
    JAVA_HOME=/usr/lib/jvm/java-11-oracle

RUN VERSION=11.0.2 && \
    BUILD=9 && \
    SIG=f51449fcd52f4d52b93a989c5c56ed3c && \
    apt-get update && apt-get dist-upgrade -y && \
    apt-get install apt-utils ca-certificates curl -y --no-install-recommends && \
    curl --silent --location --retry 3 --cacert /etc/ssl/certs/GeoTrust_Global_CA.pem \
        --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
        http://download.oracle.com/otn-pub/java/jdk/"${VERSION}"+"${BUILD}"/"${SIG}"/jdk-"${VERSION}"_linux-x64_bin.tar.gz \
        | tar xz -C /tmp && \
    mkdir -p /usr/lib/jvm && mv /tmp/jdk-${VERSION} "${JAVA_HOME}" && \
    apt-get autoclean && apt-get --purge -y autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    update-alternatives --install "/usr/bin/java" "java" "${JAVA_HOME}/bin/java" 1 && \
    update-alternatives --install "/usr/bin/javac" "javac" "${JAVA_HOME}/bin/javac" 1 && \
    update-alternatives --set java "${JAVA_HOME}/bin/java" && \
    update-alternatives --set javac "${JAVA_HOME}/bin/javac"


RUN apt update && apt-get install -y gnupg2

# Install Gcloud
ENV CLOUD_SDK_REPO="cloud-sdk-stretch" 
RUN echo "deb http://packages.cloud.google.com/apt ${CLOUD_SDK_REPO} main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && apt-get update &&  apt-get install -y google-cloud-sdk

# Install Cloud Build
RUN apt-get update && apt-get install -y google-cloud-sdk-cloud-build-local
## Remove this if forking repository
RUN useradd -ms /bin/bash martinomburajr
# USER martinomburajr
WORKDIR /home/martinomburajr