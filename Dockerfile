FROM jenkinsxio/builder-maven:0.1.155

# Install your tools and libraries
RUN yum install -y gcc openssl-devel
# Install NodeJS
RUN yum install -y gcc-c++ make
RUN curl -sL https://rpm.nodesource.com/setup_6.x 
RUN yum install -y nodejs npm --enablerepo=epel 
RUN npm install -g node-gyp bower

# Install conversion tools
RUN yum -y upgrade && yum -y install \
  perl \
  ImageMagick \
  ffmpeg \
  ffmpeg2theora \
  ufraw \
  poppler-utils \
  libreoffice \
  libwpd-tools \
  perl-Image-ExifTool \
  ghostscript

# Install gulp a
RUN npm install -g gulp grunt grunt-cli polymer-cli bower yo && \
  rm -rf /var/lib/apt/lists/* && \
  chown -R 1001:0 $HOME && \
  chmod -R g+rw $HOME

# Install ts-node
RUN npm install -g ts-node

#Install yarn
RUN curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo
RUN yum install -y yarn

#==================
# Chrome webdriver
#==================
# Credits to https://github.com/elgalu/docker-selenium
ENV CHROME_DRIVER_VERSION="2.38" \
  CHROME_DRIVER_BASE="chromedriver.storage.googleapis.com" \
  CPU_ARCH="64"
ENV CHROME_DRIVER_FILE="chromedriver_linux${CPU_ARCH}.zip"
ENV CHROME_DRIVER_URL="https://${CHROME_DRIVER_BASE}/${CHROME_DRIVER_VERSION}/${CHROME_DRIVER_FILE}"
RUN  wget -nv -O chromedriver_linux${CPU_ARCH}.zip ${CHROME_DRIVER_URL} \
  && unzip chromedriver_linux${CPU_ARCH}.zip \
  && rm chromedriver_linux${CPU_ARCH}.zip \
  && chmod 755 chromedriver \
  && mv chromedriver /usr/local/bin/ \
  && chromedriver --version

#==============
# Install njx
#==============
# Checkout njx sources and build them
RUN git clone https://github.com/nuxeo/nuxeo-jenkins-x-cli.git && \
  cd nuxeo-jenkins-x-cli && \
  git checkout master && \
  npm install && \
  npm run prepare && \
  cd lib && ln -n njx.js njx
RUN ln -s /home/jenkins/nuxeo-jenkins-x-cli/lib/njx.js /usr/bin/njx