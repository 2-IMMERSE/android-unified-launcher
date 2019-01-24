# Copyright 2019 British Broadcasting Corporation
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#   http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

DOCKER_IMAGE := bbcrd-android-builder

# User that the build is run as (non-root)
CLIENTAPI_USER:=android
BUILD_DIR:=$(CURDIR)

# If no make target is specified, ensure 'MAKECMDGOALS' contains 'build'
ifeq ($(strip $(MAKECMDGOALS)),)
	MAKECMDGOALS := build
endif

ifdef http_proxy
    BUILD_PROXY = --build-arg http_proxy=$(http_proxy)
    RUN_PROXY += --env http_proxy=$(http_proxy)
endif

ifdef https_proxy
    BUILD_PROXY += --build-arg https_proxy=$(https_proxy)
    RUN_PROXY += --env https_proxy=$(https_proxy)
endif

ifndef LAUNCHER_DEPLOYMENT_BASE_URL
    # LAUNCHER_DEPLOYMENT_BASE_URL must be defined for all targets except 'dockerimage' and 'info' targets
    ifeq ($(filter clean dockerimage info,$(MAKECMDGOALS)),)
		$(error 'LAUNCHER_DEPLOYMENT_BASE_URL' environment variable is required)
    endif
endif

ifndef CLIENT_DEPLOYMENT_BASE_URL
    # CLIENT_DEPLOYMENT_BASE_URL must be defined for all targets except 'dockerimage' and 'info' targets
    ifeq ($(filter clean dockerimage info,$(MAKECMDGOALS)),)
		$(error 'CLIENT_DEPLOYMENT_BASE_URL' environment variable is required)
    endif
endif

.PHONY: dockerimage $(MAKECMDGOALS) shell info

default: $(MAKECMDGOALS)

info:
	@echo "2-Immerse Companion Application Builder"
	@echo "---------------------------------------"
	@echo "Makefile targets:"
	@echo "  build               Builds both android applications."
	@echo "  dockerimage         Just builds the docker image used for building the apps"
	@echo "  shell               Launches a bash session hosted by the docker container for debugging"
	@echo ""
	@echo "Environment variables:"
	@echo "  LAUNCHER_DEPLOYMENT_BASE_URL (Required) URL of directory where the launcher web app is deployed"
	@echo "  CLIENT_DEPLOYMENT_BASE_URL   (Required) URL of directory where the 2-IMMERSE client-api is deployed"
	@echo "  DOCKER_IMAGE_NAME            (Optional) Name to use for docker image for building firmware"
	@echo ""
	@echo "Example:"
	@echo ""
	@echo "  make LAUNCHER_DEPLOYMENT_BASE_URL=https://origin.platform.2immerse.eu/unified-launcher \\"
	@echo "       CLIENT_DEPLOYMENT_BASE_URL=https://origin.platform.2immerse.eu/client-api/master/dist"

dockerimage: Dockerfile Makefile
	docker build  $(BUILD_PROXY) -t $(DOCKER_IMAGE) .

build: dockerimage
	docker run $(RUN_PROXY) --rm -it \
	--env LAUNCHER_DEPLOYMENT_BASE_URL=$(LAUNCHER_DEPLOYMENT_BASE_URL) \
	--env CLIENT_DEPLOYMENT_BASE_URL=$(CLIENT_DEPLOYMENT_BASE_URL) \
	-v $(BUILD_DIR):/build \
	$(DOCKER_IMAGE) \
	make -C /build/src $(MAKECMDGOALS)

clean: dockerimage
	docker run $(RUN_PROXY) --rm -it \
	--env LAUNCHER_DEPLOYMENT_BASE_URL=$(LAUNCHER_DEPLOYMENT_BASE_URL) \
	--env CLIENT_DEPLOYMENT_BASE_URL=$(CLIENT_DEPLOYMENT_BASE_URL) \
	-v $(BUILD_DIR):/build \
	$(DOCKER_IMAGE) \
	make -C /build/src $(MAKECMDGOALS)

shell: dockerimage
	docker run $(RUN_PROXY) --rm -it \
	--env LAUNCHER_DEPLOYMENT_BASE_URL=$(LAUNCHER_DEPLOYMENT_BASE_URL) \
	--env CLIENT_DEPLOYMENT_BASE_URL=$(CLIENT_DEPLOYMENT_BASE_URL) \
	-v $(BUILD_DIR):/build \
	$(DOCKER_IMAGE) \
	bash
