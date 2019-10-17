# kontarion

![Open BI Analytics Platform for Bibliometrics](logo.png)

`kontarion` is a dockerized Open BI Analytics Platform for reproducible open research work. It can be customized for data science workflows within different domains, and is currently profiled towards analytical workflows within *Bibliometrics*. 

It therefore has various packages to support various bibliometrics workflows pre-installed. Connectivity has been set up to enable working with various data sources, including MS SQL Server databases. 

## What does it contain?

It is packaged as a docker image which consists of a Debian OS base with a full software stack of versioned R and Python components layered on top, in order to support Data Science work aiming at developing and publishing analytics. It is also able to support data analysis work involving machine learning and algorithmic intelligence applications. 

## License

The platform is an AGPL-licensed portable dockerized software stack supporting reproducible research efforts within the bibliometrics domain but also support analytics workflows in other domains. It is based fully on free and open source licensed software.

It can be used entirely through the web browser and/or at the CLI and it can run locally or deployed at a server in the cloud.

# Data Science using R

To support data science work using R, the web-variant of the RStudio IDE is included as well as a Shiny server. This means that it comes with a curated and pre-installed set of various assorted packages (including web-enabled RStudio with Shiny and rmarkdown support). Specific packages to support workflows within bibliometric analytics are included, for example packages from [ROpenSci.org](https://ROpenSci.org).

# Data Science using Python

To support data science work using Python, a set of packages are provided including the open source version of Anaconda, which is a high performance distribution and includes over 100 of the most popular Python packages for data science. 

Additionally, it provides access to many hundreds of Python and R packages that can easily be installed using the conda dependency and environment manager, which is included in Anaconda.

# Usage

You can download and run `kontarion` locally using the following command, provided you have `docker` and `make` installed first:

		make start-ide

This will start the web-based RStudio Web Open Source Edition. 

Use credentials for user/login: `rstudio/kontarion` when logging in.

The `kontarion` platform can also be used for purposes other than functioning as an IDE, such as:

- an application server (for `shiny` based web applications etc)
- an API server (for `plumber`-based REST APIs)
- a CLI execution context for automating tasks (syncing data / setting up data flows, scheduling jobs etc)

## Running apps

TODO: document and provide Makefile target

## Running APIs

TODO: document and provide Makefile target

## Running and scheduling tasks/jobs

TODO: document and provide Makefile target

# Developers

If you are a developer or system administrator, you might be interested in building it from source, extending it or downloading and running `kontarion` locally.

This requires that you have [installed Docker Community Edition](https://docs.docker.com/v17.09/engine/installation/).

Once you have `docker` installed, to start `kontarion` locally, link a local volume (in this example, the current working directory, `$(pwd)`) to the container, start it and point your browser to it with these CLI commands:

```bash
# start kontarion services to run the RStudio Open Source Web Edition
# mount your .Renviron file with environment variables ... 
# use DBUSER and DBPASS to set your MS SQL Server credentials
docker run -d --name mywebide \
	--env USERID=$UID \
	--env PASSWORD=kontarion \
	--publish 8787:8787 \
	--volume $(pwd):/home/rstudio \
	--volume ~/.Renviron:/home/rstudio/.Renviron \
	kthb/kontarion /init

# use login rstudio:rstudio
firefox http://localhost:8787 &

```

The first command will start the container in the background so you can visit `http://localhost:8787` with your web browser and log in with username:password as `rstudio:kontarion`.

You can also then run the CLI if you wish with:

```bash
docker exec -it mywebide bash

```

A CLI/shell/terminal is available also from within the IDE's own UI.

You can list the full set of included R packages with:

```bash
docker exec -it mywebide \
	R --quiet -e "cat(rownames(installed.packages()))"

```

## Building from source

To build `kontarion` locally from source, use something like this:

		# starting from scratch
		mkdir ~/repos
		cd ~repos    
		git clone git@github.com:KTH-Library/kontarion.git
		make

		# if you want to time the build, use...
		time make
    
This takes around 19 minutes on a modern laptop.

Use `docker images | grep kontarion` to inspect the resulting image, its total size is around 7 GB.


## Common configuration options:

Use a custom user named after your user on the host, and password specified in the `PASSWORD` environmental variable, and give the user root permissions (add to sudoers) and work on files in the ~/foo working directory:

```bash
docker run -d --name mywebide \
	-p 8787:8787 \
	-e ROOT=TRUE \
	-e USERID=$UID \
	-e USER=$USER \
	-e PASSWORD=yourpasswordhere \
	-v $(pwd)/foo:/home/$USER/foo \
	-w /home/$USER/foo \
	kthb/kontarion /init

```

### Using Shiny

To use the image as a Shiny server, you can override the startup command to use `/usr/bin/shiny-server.sh`:

```bash
docker run -d --name myshinyapp \
	-p 3838:3838 \
	kthb/kontarion /usr/bin/shiny-server.sh

firefox http://localhost:3838 &

``` 

This will launch the default Shiny app in the container (see the Dockerfile for deployment details).

To deploy your own app you can expose a directory on the host with your app to the container. For mapping the host directory use the option `-v <host_dir>:<container_dir>`. The following command will use the present working directory as the Shiny app directory.

```bash
docker run -d --name myshinyapp \
	-p 3838:3838 \
	-v $(pwd)/:/srv/shiny-server/ \
	kthb/kontarion /usr/bin/shiny-server.sh

firefox http://localhost:3838 &
```

If you have a Shiny app in a subdirectory of your present working directory named appdir, you can now use a web browser to access the app by visiting http://localhost:3838/appdir/

# Using Python

TODO: cover more scenarios...

## Jupyter Notebook server

You can start a Jupyter Notebook server and interact with Anaconda via your browser:

		docker run -it -p 8888:8888 kthb/kontarion /bin/bash -c "/opt/conda/bin/conda install jupyter -y --quiet && mkdir /opt/notebooks && /opt/conda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser"

You can then view the Jupyter Notebook by opening http://localhost:8888 in your browser, or http://my-docker-machine-ip:8888 if you are using a Docker Machine.
