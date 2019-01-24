# Copyright 2019 British Telecommunications plc
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

INDEX_HTML=www/index.html
INDEX_HTML_TEMPLATE=index.html.template
SYNCKIT_COMMIT=4da11f417e2bdb2ade240a471931677a844856ea
#SYNCKIT_COMMIT=db5a81cc1aa53fa9b37097f0c237dfdf1d02ad00
HBBTV_ORIG_COMMIT=64e86762aa5427cb9adbff744902197e3e260a55

.PHONY: build run deploy pre-build cordova-clean clean default

default: build

# TODO: Enable these two lines once this code has been added to a repository
#pre-build: synckit $(shell [ -e ".config.xml.prev" -a "`git show @:./config.xml`" != "`cat .config.xml.prev 2> /dev/null`" ] && echo "cordova-clean")
#	git show @:./config.xml > .config.xml.prev
pre-build: synckit cordova-plugin-hbbtv
	git config --global user.email "you@example.com"
	git config --global user.name "Your Name"
	git -C synckit checkout -q -f $(SYNCKIT_COMMIT)
	[ "`git -C cordova-plugin-hbbtv rev-parse @^{tree}`" = "1818f8a5b409577780aff2eb911229aa34d7e3e6" ] || { git -C cordova-plugin-hbbtv checkout -q -f $(HBBTV_ORIG_COMMIT) ; git -C cordova-plugin-hbbtv am ../cordova-plugin-hbbtv.am ; }
	cordova prepare --no-insight
	[ -d platforms/android ] || cordova platform add android --no-insight

synckit:
	git clone -n https://github.com/2-IMMERSE/cordova-synckit-android.git synckit
#	git clone -n git@gitlab-ext.irt.de:2-immerse/synckit.git synckit

cordova-plugin-hbbtv:
	git clone -n https://github.com/fraunhoferfokus/cordova-plugin-hbbtv.git cordova-plugin-hbbtv

$(INDEX_HTML): $(INDEX_HTML_TEMPLATE)
	mkdir -p $(dir $(INDEX_HTML))
	cat $(INDEX_HTML_TEMPLATE) | sed -e "s|###LAUNCHER_DEPLOYMENT_BASE_URL###|$(LAUNCHER_DEPLOYMENT_BASE_URL)|" \
	-e "s|###CLIENT_DEPLOYMENT_BASE_URL###|$(CLIENT_DEPLOYMENT_BASE_URL)|" > $(INDEX_HTML)

build: $(INDEX_HTML) pre-build
	cordova build android --no-insight

run: pre-build
	cordova run android --no-insight

cordova-clean:
	rm -fr platforms
	rm -fr plugins
	rm -fr .config.xml.prev
	rm -fr package-lock.json
	rm -fr node_modules

clean: cordova-clean
	rm -fr synckit
	rm -fr cordova-plugin-hbbtv
	rm -f $(INDEX_HTML)
