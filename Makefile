# Kohana Makefile
#
# wget and git are required
# phpunit, cssmin and uglifyjs are suggested
#
# You may use a different minifier based on what's available 
# on your system.

# user and group for the web server
USER=apache
GROUP=apache

# kohana files
KOHANA=index.php .gitignore example.htaccess composer.json application/bootstrap.php
VERSION=3.3

# modules
MODULES=auth cache database orm

# cache and logs folders
CACHE=application/cache
LOGS=application/logs

# documentation
DOC=apigen
DOCFLAGS=

# css and js minifier
CSSM=cssmin
CSSMFLAGS=

JSM=uglifyjs
JSMFLAGS=

# css and js files
CSS=$(shell find assets/css/ -type f -name '*.css' -not -name '*.min.css')
JS=$(shell find assets/js/ -type f -name '*.js' -not -name '*.min.js')

# phpunit
PHPUNIT=phpunit
PHPUNITFLAGS=

# phpcs
PHPCS=phpcs
PHPCSFLAGS=

all: permissions clean minify

# Include specific Makefile
-include application/Makefile

# initialize a git repository
.git:
	git init

# install kohana
install: $(KOHANA) assets/css assets/js application .git system $(addprefix modules/, $(MODULES))

# create assets folders
assets/%:
	mkdir -p $@

application:
	mkdir -p application/{cache,classes,config,i18n,logs,messages,views}
	touch application/{cache,logs}/.gitignore

# install kohana core
system:
	git submodule add https://github.com/kohana/core.git system

# install kohana module
modules/%:
	git submodule add https://github.com/kohana/$(notdir $@).git $@

# download kohana file
$(KOHANA):
	wget https://raw.githubusercontent.com/kohana/kohana/$(VERSION)/master/$@

# update permissions and SELinux context
permissions:
	chown -R $(USER):$(GROUP) $(CACHE) $(LOGS)
	chmod -R 777 $(CACHE) $(LOGS)
ifeq ($(shell selinuxenabled; echo $$?), 0)
	chcon -R -t httpd_sys_script_rw_t $(CACHE)
	chcon -R -t httpd_sys_script_ra_t $(LOGS)
endif

# minify resources
minify: $(patsubst %.css, %.min.css, $(CSS)) $(patsubst %.js, %.min.js, $(JS))

%.min.css: %.css
	$(CSSM) $(CSSMFLAGS) $< > $@

%.min.js: %.js
	$(JSM) $(JSMFLAGS) $< > $@

# run unit tests
test: clean
	$(PHPUNIT) $(PHPUNITFLAGS)

# produce an html coverage
coverage: clean
	$(PHPUNIT) $(PHPUNITFLAGS) --coverage-html coverage

# generate the documentation
documentation:
	$(DOC) $(DOCFLAGS)

# sniff code for errors
codesniffer:
	$(PHPCS) $(PHPCSFLAGS) application/classes \
	                       application/config \
						   application/i18n \
						   application/messages \
						   application/views

# clean the kohana cache files
clean:
	rm -f $(shell find $(CACHE) -type f -not -name '.*')
