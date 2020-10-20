FROM rocker/verse:3.6.2

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

# add GTK2+ system lib required for CITAN

RUN apt-get update && apt-get install -y \
  libgtk2.0-dev

RUN install2.r --error \
	microdemic \
	scholar \
	CITAN \
	sas7bdat \
	haven \
	SAScii \
	rscopus

#RUN install2.r --error \
#	leiden \
#	rex

RUN R -e 'remotes::install_github("ropensci/crevents", dependencies = TRUE)'

RUN export ADD=shiny && bash /etc/cont-init.d/add

RUN apt-get update && apt-get install -y \
    xtail

COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
COPY shiny-server.sh /usr/bin/shiny-server.sh
COPY rserver.conf /etc/rstudio/rserver.conf
COPY login.html /etc/rstudio/login.html

# shinycannon, shinyloadtest, shinytest

RUN apt-get -y update && apt-get install -y --no-install-recommends \
	apache2-utils  # for ab (apache benchmark tool)

RUN mkdir -p /tmp/cannon

ENV TMPDIR /tmp/cannon

RUN mkdir -p $TMPDIR && cd $TMPDIR && \
	wget https://s3.amazonaws.com/rstudio-shinycannon-build/2019-11-22-20:24:21_1.0.0-9b22a92/deb/shinycannon_1.0.0-9b22a92_amd64.deb && \
	dpkg -i shinycannon_1.0.0-9b22a92_amd64.deb 

RUN R -e "remotes::install_github('rstudio/shinyloadtest')"

RUN install2.r --error \
	RSelenium \
	shinytest
	
RUN rm -rf $TMPDIR

RUN R -e 'remotes::install_github("kth-library/dblp", dependencies=TRUE)'
RUN R -e 'remotes::install_github("kth-library/XsearchLIBRIS", dependencies=TRUE)'
RUN R -e 'remotes::install_github("kth-library/bibliomatrix", dependencies = TRUE)'

RUN R -e 'ktheme::install_fonts_linux("/usr/local/share/fonts")'

RUN cd /srv/shiny-server && \
	rm -rf * && \
	mkdir -p /var/lib/shiny-server/bookmarks/shiny && \
    chown -R shiny.shiny /var/log/shiny-server && \
    chmod -R o+w /var/lib/shiny-server/ /var/log/shiny-server/ && \
    chmod -R o+r /srv/shiny-server/ /opt/shiny-server/ /etc/shiny-server/ && \
	chmod -R o+wr /usr/local/lib/R/site-library/bibliomatrix/shiny-apps/abm/www/cache && \
	ln -s /usr/local/lib/R/site-library/bibliomatrix/shiny-apps/abm/* /srv/shiny-server

RUN apt-get update && apt-get install -y \
    xtail

COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
COPY shiny-server.sh /usr/bin/shiny-server.sh
COPY rserver.conf /etc/rstudio/rserver.conf
COPY login.html /etc/rstudio/login.html

EXPOSE 8888
EXPOSE 3838

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]

# NB: if running with the shiny server, launch using this command: /usr/bin/shiny-server.sh
# NB: if running loadtest, launch using this command: "init"