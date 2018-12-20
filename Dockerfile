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