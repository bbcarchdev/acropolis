## Acropolis
## A toolkit for building knowledge graphs

## Author: Mo McRoberts <mo.mcroberts@bbc.co.uk>
##
## Copyright (c) 2017 BBC
##
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##
##      http://www.apache.org/licenses/LICENSE-2.0
##
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.

ACLOCAL_AMFLAGS = -I m4

DIST_SUBDIRS = m4 libcluster liblod libsql liburi libmq \
	anansi quilt twine spindle docbook-html5 docs libawsclient

SUBDIRS = @subdirs@ docbook-html5 docs

BRANCH ?= develop
DOCS_BRANCH ?= gh-pages

DEVELOP_SUBMODULES = m4 anansi libcluster liblod libmq libsparqlclient \
	libsql liburi quilt spindle twine libawsclient
DOCS_MODULES = docs docbook-html5

checkout:
	@for submod in $(DEVELOP_SUBMODULES) ; do \
		echo "+++ Checking out the latest version of $$submod on $(BRANCH)" >&2 ; \
		cd $$submod && \
		git checkout $(BRANCH) && \
		git pull origin $(BRANCH) && \
		$(MAKE) checkout BRANCH=$(BRANCH) || exit $? && \
		cd .. ; \
	done
	@for submod in $(DOCS_SUBMODULES) ; do \
		echo "+++ Checking out the latest version of $$submod on $(DOCS_BRANCH)" >&2 ; \
		cd $$submod && \
		git checkout $(DOCS_BRANCH) && \
		git pull origin $(DOCS_BRANCH) && \
		cd .. ; \
	done
