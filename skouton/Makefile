#! make

build-skouton:
	docker build -t skouton .

build-klivanion:
	docker build -t klivanion . -f Dockerfile.klivanion

start-klivanion:
	docker run -d --name=klivanion -p 3838:3838 klivanion

stop-klivanion:
	docker stop klivanion
	docker rm -f klivanion

install-bibcap-apps:
	docker run -d --name=bibcap --user=root -p 3838:3838 \
		-v $$(pwd)/scripts/install_bibcap.sh:/install_bibcap.sh \
		skouton tail -f /dev/null
	docker exec bibcap bash -c "/install_bibcap.sh"

start-bibcap-apps:
	docker start bibcap
	docker exec -d bibcap bash -c "/usr/bin/shiny-server.sh"

clean-bibcap-apps:
	docker stop bibcap
	docker rm -f bibcap
