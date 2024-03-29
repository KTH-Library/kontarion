
<!-- README.md is generated from README.Rmd. Please edit that file -->

# kontarion <img src="https://raw.githubusercontent.com/KTH-Library/kontarion/master/kontarion.png" align="right" />

`kontarion` is a containerized Open BI Analytics Platform for
reproducible open research work. It can be customized for data science
workflows within different domains, and is currently profiled towards
analytical workflows within *Bibliometrics*.

It therefore has various packages to support various bibliometrics
workflows pre-installed. Connectivity has been set up to enable working
with various data sources, including MS SQL Server databases.

## What does it contain?

It is packaged as a container image which consists of a Linux OS base
with a full software stack of versioned R and Python components layered
on top, in order to support Data Science work aiming at developing and
publishing analytics. It is also able to support data analysis work
involving machine learning and algorithmic intelligence applications.

It is an extension building on this
[base](https://github.com/rocker-org/rocker-versioned2/wiki/ml-verse_5a4d24ef3e8d)
from <https://rocker-project.org/>.

# Data Science using R and Python

To support data science work using R, the web-variant of the RStudio IDE
is included as well as a Shiny server. This means that it comes with a
curated and pre-installed set of various assorted packages (including
web-enabled RStudio with Shiny, plumber and quarto/rmarkdown support).
Specific packages to support workflows within bibliometric analytics are
included, for example packages from
[ROpenSci.org](https://ROpenSci.org).

To support data science work using Python, a set of packages are
available including the open source version of Anaconda, which is a high
performance distribution which includes over 100 of the most popular
Python packages for data science.

Additionally, it provides access to many hundreds of Python and R
packages that can easily be installed using the conda dependency and
environment manager, which is included in Anaconda.

# Quick start

Running locally requires that you have support for running containers,
for example using [Docker Community
Edition](https://docs.docker.com/engine/install/ubuntu/) or
[Podman](https://podman.io/). Depending on your base operating system
the installation procedures differ, but are well documented online.

Once you have `docker` installed, you can download and run `kontarion`
locally using the following commands, provided you have `docker` and
`make` installed first:

``` bash
# starting from scratch
mkdir ~/repos
cd ~/repos
git clone git@github.com:KTH-Library/kontarion.git
cd kontarion
make start-ide
```

The last command will download the image layers (container image),
representing the `ghcr.io/KTH-Library/kontarion` Container Image. The
`make start-ide` will run the statements in the Makefile that starts the
web-based RStudio Web Open Source Edition.

Use credentials for user/login: `rstudio/kontarion` when logging in.

Strictly speaking the `make` and `git` tools are not needed to launch
the container, but the Makefile contains a target called “`start-ide`”
which specifies some switches to the startup command, including the
password to use and the location of your local `.Renviron` file which
hold your database connection credentials.

The “`start-ide`” Makefile target wraps the following command, which you
can run directly if you prefer (without requiring `git` or `make`):

``` bash
docker run -d --name mywebide \
    --env ROOT=TRUE \
    --env USERID=$(id -u) \
    --env PASSWORD=kontarion \
    --publish 8787:8787 \
    --volume $(pwd)/home:/home/rstudio \
    --volume $HOME/.Renviron:/home/rstudio/.Renviron \
    ghcr.io/KTH-Library/kontarion /init
```

Note that this command assumes several things:

- you have a directory named `home` under your present working
  directory, representing your rstudio home directory (this will be the
  case if you have checked out the kontarion github repo from
  `git@github.com:KTH-Library/kontarion.git` and then changed your
  present working directory into this folder)
- you have your `.Renviron` file in your system home directory (normally
  the location is available in the `HOME` system environment variable)
  and that your `.Renviron` file holds your database credentials in
  environment variables named DBHOST, DBNAME, DBUSER and DBPASS
- the command `id -u` returns the user id on the system

NB: This command may need to be amended on systems where these
assumptions are not valid. If you get an initialization error that says
“Unable to connect to service”, please check the above assumptions and
modify the command to work for your setup.

Having `git` and `make` available on your host system allows you to make
changes, re-build the system or extend it and contribute these changes
back to the GitHub repository, should you wish to do so.

# Usage

If you are a developer or system administrator, you might be interested
in downloading and running `kontarion` locally but also in building it
from source, extending it or contributing your changes.

Once you have `docker` or `podman` with `buildah` installed, to start
`kontarion` locally, link a local volume (in this example, a `home`
sub-folder under the current working directory, `$(pwd)`) to the
container, start it and point your browser to it with these CLI
commands:

``` bash
# start kontarion services to run the RStudio Open Source Web Edition
# mount your .Renviron file with the environment variables into the container... 
# use DBHOST, DBNAME, DBUSER and DBPASS to define your MS SQL Server connection credentials

docker run -d --name mywebide \
    --env ROOT=TRUE \
    --env USERID=$(id -u) \
    --env PASSWORD=kontarion \
    --publish 8787:8787 \
    --volume $(pwd)/home:/home/rstudio \
    --volume ~/.Renviron:/home/rstudio/.Renviron \
    ghcr.io/KTH-Library/kontarion /init

# after a couple of seconds, use login rstudio:kontarion
firefox http://localhost:8787 &
```

The first command will start the container in the background so you can
visit `http://localhost:8787` with your web browser and log in with
username:password as `rstudio:kontarion`.

### Common configuration options:

Use a custom user named after your user on the host, and password
specified in the `PASSWORD` environmental variable, and give the user
root permissions (add to sudoers) and work on files in the ~/foo working
directory:

``` bash
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

Available options are documented in more detail
[here](https://rocker-project.org/images/versioned/rstudio.html#how-to-use).

## Building from source

To build `kontarion` locally from source, starting from scratch, use
something like this:

        # starting from scratch
        mkdir ~/repos
        cd ~/repos
        git clone git@github.com:KTH-Library/kontarion.git
        cd kontarion
        make

        # if you want to time the build, use...
        time make

Use `docker images | grep kontarion` to inspect the resulting image
(which is what is downloaded from [GitHub Container
Registry](https://github.com/orgs/KTH-Library/packages) if just issuing
`make start-ide` and not building from source).

If you wish you can access the CLI if you wish on the running `mywebide`
container:

``` bash
docker exec -it mywebide bash
```

A CLI/shell/terminal is available also from within the IDE’s own UI.

You can list the full set of included R packages by executing a command
against the running container like so:

``` bash
docker exec -it mywebide \
    R --quiet -e "cat(rownames(installed.packages()))"
```

## Non-interactive usage

The `kontarion` platform can also be used for purposes other than
functioning as an IDE, such as running non-interactive services:

- a *web application server* (for `shiny` based web applications etc)
- an *API server* (for `plumber`-based REST APIs)
- a *report server* (to render quarto or Rmarkdown-based content into
  HTML / PDF / Office document-oriented and other supported document
  formats)
- a *CLI execution context* for automating tasks (syncing data / setting
  up data flows, scheduling jobs etc)

### Running web apps

To use the image as a Shiny server, you can override the startup command
to use `/usr/bin/shiny-server.sh`:

``` bash
docker run -d --name myshinyapp \
    -p 3838:3838 \
    ghcr.io/KTH-Library/kontarion /usr/bin/shiny-server.sh

firefox http://localhost:3838 &
```

This will launch the default Shiny app in the container (see the
Dockerfile for deployment details).

To deploy your own app you can expose a directory on the host with your
app to the container. For mapping the host directory use the option
`-v <host_dir>:<container_dir>`. The following command will use the
present working directory as the Shiny app directory.

``` bash
docker run -d --name myshinyapp \
    -p 3838:3838 \
    -v $(pwd)/:/srv/shiny-server/ \
    kthb/kontarion /usr/bin/shiny-server.sh

firefox http://localhost:3838 &
```

If you have a Shiny app in a subdirectory of your present working
directory named appdir, you can now use a web browser to access the app
by visiting <http://localhost:3838/appdir/>

## Jupyter Notebook server

You can start a Jupyter Notebook server and interact with Anaconda via
your browser:

``` bash
docker run -it -p 8888:8888 \
  ghcr.io/KTH-Library/kontarion /bin/bash -c "/opt/conda/bin/conda install jupyter -y --quiet && mkdir /opt/notebooks && /opt/conda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser"
```

You can then view the Jupyter Notebook by opening
<http://localhost:8888> in your browser, or
<http://my-docker-machine-ip:8888> if you are using a Docker Machine.

# Contributions

[![Get the GitHub CLI
Badge](https://img.shields.io/badge/CLI-GitHub%20CLI%20Friendly-blue.svg)](https://hub.github.com)

The [GitHub CLI tool](https://hub.github.com) can be used for
reproducible collaboration workflows when collaborating on this (or any
other) repo, for whatever reason - such as for convenience and
automation support or perhaps because someone is handing out CLI badges
and you want one ;).

Usage example while at the CLI, if you want to add a feature branch that
provides command line support for using this R package along with usage
examples:

    $ hub clone KTH-Library/kontarion
    $ cd kontarion

    # create a topic branch
    $ git checkout -b add-new-feature

    # make changes and test locally ... then ...

    $ git commit -m "done with my new feature"

    # It's time to fork the repo!
    $ hub fork --remote-name=origin
    → (forking repo on GitHub...)
    → git remote add origin git@github.com:YOUR_USER/kontarion.git

    # push the changes to your new remote
    $ git push origin add-new-feature

    # open a pull request for the topic branch you've just pushed
    $ hub pull-request
    → (opens a text editor for your pull request message)

## License

The platform is an AGPL3-licensed portable dockerized software stack
supporting reproducible research efforts and analytics within the
bibliometrics domain but it also support analytics workflows in other
domains. It is based fully on free and open source licensed software.

It can be used entirely through the web browser and/or at the CLI and it
can run locally or be deployed at a server in the cloud to support users
who do not want to or need to run locally or install the dependencies
(docker, make etc).
