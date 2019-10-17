FROM rocker/verse:3.6.1

# add ODBC driver for MS SQL Server
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    apt-transport-https \
    gdebi-core \
    libcurl4-openssl-dev \
    libssl-dev \
    apt-utils

# add MS ODBC Driver
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get -y -q update && \
    apt-get -y -q dist-upgrade && \
    ACCEPT_EULA=Y apt-get -y install msodbcsql17 && \
    ACCEPT_EULA=Y apt-get -y install mssql-tools

# add python support
RUN apt-get install -y \
	wget bzip2 ca-certificates \
	libglib2.0-0 libxext6 libsm6 libxrender1 \
	git mercurial subversion

ENV PATH /opt/conda/bin:$PATH

RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-5.3.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

# add zombie reaper
RUN apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean
    
# add R packages
RUN install2.r --error \
	roadoi \
	rAltmetric \
	tsibble \
	plotly \
	igraph \
	networkD3 \
	wosr \
	bibliometrix \
	visNetwork \
	configr \
	shinydashboard \
	flexdashboard \
	config \
	RSQLite \
	rappdirs \
	plumber \
	reticulate \
	odbc \
	ggthemes

EXPOSE 8888
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
