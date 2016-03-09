# TODO:
# - plex-pass container
# - test a reboot restarts all containers


# config
SABNZBD_IMAGE = joemiller/sabnzbd
SONARR_IMAGE  = joemiller/sonarr
DELUGE_IMAGE  = joemiller/deluge

CONTAINERS = sabnzbd sonarr deluge

# aggregate tasks
build_all: build_sabnzbd build_sonarr build_deluge ## build all containers

create_all: create_sabnzbd create_sonarr create_deluge ## create and start all containers

stop_all:  ## stop all containers
	docker stop $(CONTAINERS)

restart_all:  ## restart all containers
	docker restart $(CONTAINERS)

remove_all:  ## remove all containers
	docker rm $(CONTAINERS)

# sabnzbd
build_sabnzbd:  ## build the sabnzbd container
	docker build -t $(SABNZBD_IMAGE) --pull=true --no-cache=true sabnzbd

create_sabnzbd:  ## create and start the sabnzbd container
	docker run -d --name sabnzbd --restart=always \
		-p 8085:8085 \
		-v /files:/files \
		-v /etc/sabnzbd:/config \
		$(SABNZBD_IMAGE)

# sonarr
build_sonarr:  ## build the sonarr container
	docker build -t $(SONARR_IMAGE) --pull=true --no-cache=true sonarr

create_sonarr:  ## create and start the sonarr container
	docker run -d --name sonarr --restart=always \
		-p 8989:8989 \
		-v /files:/files \
		-v /etc/sonarr:/config \
		$(SONARR_IMAGE)

# deluge
build_deluge:  ## build the deluge container
	docker build -t $(DELUGE_IMAGE) --pull=true --no-cache=true deluge

create_deluge:  ## create and start the deluge container
	docker run -d --name deluge --restart=always \
		-p 8083:8083 \
		-p 53160:53160 \
		--net=host \
		-v /files:/files \
		-v /etc/deluge:/config \
		$(DELUGE_IMAGE)

# helpers
help: ## print list of tasks and descriptions
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

.PHONY: all
