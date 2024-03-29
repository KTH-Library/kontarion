#! make

include env-docker

IMAGE=kthb/kontarion

.PHONY: all

all: latest

devel:
	docker build -t $(IMAGE):devel --build-arg GITHUB_PAT=${GITHUB_PAT} .

scan:
	docker run -v /var/run/docker.sock:/var/run/docker.sock -v $$HOME/.trivy:/root/.cache/ aquasec/trivy:0.46.0 --timeout 10m image kthb/kontarion

latest:
	docker build -t $(IMAGE) --build-arg GITHUB_PAT=${GITHUB_PAT} .

start-ide:
	docker run -d --name mywebide \
		--env ROOT=true \
		--env USER=rstudio \
		--env PASSWORD=kontarion \
		--env USERID=$$(id -u) \
		--env GROUPID=$$(id -g) \
		--publish 8787:8787 \
		--volume $$HOME/.Renviron:/home/rstudio/.Renviron \
		--volume $$(pwd)/login.html:/etc/rstudio/login.html:ro \
		--volume $$(pwd)/rserver.conf:/etc/rstudio/rserver.conf \
		--volume $$(pwd)/home:/home/rstudio/home \
		$(IMAGE) /init
#		--user $$(id -u):$$(id -g) \

clean-ide:
	@docker stop mywebide
	@docker rm mywebide

start-app:
	docker run -d --name myapp \
		--env USERID=$$(id -u) \
		--env GROUPID=$$(id -g) \
		--env ABM_API="http://myapp:8080" \
		--publish 8000:8000 \
		--env-file $$HOME/.Renviron \
		--volume $$HOME/.Renviron:/root/.Renviron:ro \
		--volume $$HOME/.config:/root/.config:ro \
		$(IMAGE) R -e "bibliomatrix::run_app('abm', port = 8000, host = '0.0.0.0')" 

start-api:
	docker run -d --name myapi \
		--env USERID=$$(id -u) \
		--env GROUPID=$$(id -g) \
		--publish 8080:8080 \
		--env-file $$HOME/.Renviron \
		--volume $$HOME/.Renviron:/root/.Renviron:ro \
		--workdir /usr/local/lib/R/site-library/bibliomatrix/plumber/abm \
		$(IMAGE) R -e "bibliomatrix::run_api(port = 8080, host = '0.0.0.0')"

clean-app:
	@docker stop myapp
	@docker rm myapp

clean-api:
	@docker stop myapi
	@docker rm myapi

