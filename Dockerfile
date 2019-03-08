FROM jenkinsxio/builder-maven:0.1.275

# Add extra yum repositories
RUN curl -sL https://rpm.nodesource.com/setup_11.x | bash -
RUN curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo

# Install conversion tools
RUN yum -y install \
  gcc openssl-devel \
  gcc-c++ make \
  node-js \
  perl \
  yarn \
  ImageMagick \
  ffmpeg \
  ffmpeg2theora \
  ufraw \
  poppler-utils \
  libreoffice \
  libwpd-tools \
  perl-Image-ExifTool \
  ghostscript \
  && yum clean all

# Install gulp a
RUN npm install -g node-gyp gulp bower && \
  chown -R 1001:0 $HOME && \
  chmod -R g+rw $HOME
RUN echo '{ "allow_root": true }' > /root/.bowerrc

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
RUN cd /opt && git clone https://github.com/nuxeo/nuxeo-jenkins-x-cli.git && \
  cd nuxeo-jenkins-x-cli && \
  git checkout master && \
  npm install && \
  npm run prepare && \
  npm run postprepare
RUN ln -s /opt/nuxeo-jenkins-x-cli/lib/njx.js /usr/bin/njx
