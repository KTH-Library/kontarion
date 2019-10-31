#! make

IMAGE=kthb/kontarion

.PHONY: all 1.0.0 release latest start

all: latest

latest: 
	docker build -t $(IMAGE) .

1.0.0: 
	docker build -t $(IMAGE):1.0.0 1.0.0

release:
	docker login
	docker push $(IMAGE)
	docker push $(IMAGE):1.0.0

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
