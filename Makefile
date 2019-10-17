#! make

IMAGE=kth-library/kontarion

.PHONY: all 1.0.0 release latest start

all: latest

latest: 1.0.0
	docker tag $(IMAGE):1.0.0 $(IMAGE):latest

1.0.0: 
	docker build -t $(IMAGE):1.0.0 1.0.0

release:
	docker push $(IMAGE) $(IMAGE):1.0.0

start-ide:
	@docker run -d --name mywebide \
		--env USERID=$$UID \
		--env PASSWORD=kontarion \
		--publish 8787:8787 \
		--volume $$(pwd):/home/rstudio \
		--volume $$HOME/.Renviron:/home/rstudio/.Renviron:ro \
		kth-library/kontarion /init
	@firefox http://localhost:8787 &


