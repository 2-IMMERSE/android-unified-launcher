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
.PHONY: build run deploy pre-build cordova-clean clean default

default: build

# TODO: Enable these two lines once this code has been added to a repository
#pre-build: $(shell [ -e ".config.xml.prev" -a "`git show @:./config.xml`" != "`cat .config.xml.prev 2> /dev/null`" ] && echo "cordova-clean")
#	git show @:./config.xml > .config.xml.prev
pre-build: 
	cordova prepare --no-insight
	[ -d platforms/android ] || cordova platform add android --no-insight

build: pre-build
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
