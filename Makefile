#! make

IMAGE=kthb/kontarion

.PHONY: all 1.0.0 release latest start

all: latest

latest: 1.0.0
	docker tag $(IMAGE):1.0.0 $(IMAGE):latest

1.0.0: 
	docker build -t $(IMAGE):1.0.0 1.0.0

release:
	docker login
	docker push $(IMAGE)
	docker push $(IMAGE):1.0.0

start-ide:
	@docker run -d --name mywebide \
		--env ROOT=TRUE \
		--env USERID=$$UID \
		--env PASSWORD=kontarion \
		--publish 8787:8787 \
		--volume $$(pwd):/home/rstudio \
		--volume $$HOME/.Renviron:/home/rstudio/.Renviron \
		$(IMAGE) /init
	@sleep 5
	@firefox http://localhost:8787 &

clean-ide:
	@docker stop mywebide
	@docker rm mywebide
