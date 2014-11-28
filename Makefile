# Kohana Makefile
#
# PHPUnit, ApiGen, cssmin and uglifyjs are suggested, but you can override them
# in a specific Makefile located in application/Makefile.
#
# Environment is inferred from .htaccess 'SetEnv KOHANA_ENV' directive.

# Get Kohana environment from .htaccess
ENV?=$(shell grep -oPs "SetEnv\s+KOHANA_ENV\s+\K\w+" .htaccess)

# user and group for the web server
USER=apache
GROUP=apache

# composer executable
COMPOSER=composer

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

# phinx
PHINX=phinx
PHINXFLAGS=

# phpunit
PHPUNIT=phpunit
PHPUNITFLAGS=

# coverage
COVERAGE=$(PHPUNIT)
COVERAGEFLAGS=$(PHPUNITFLAGS) --coverage-html

# phpcs
PHPCS=phpcs
PHPCSFLAGS=

# do nothing..
all:

# include specific Makefile
-include application/Makefile

# sniff code for errors
codesniffer:
	$(PHPCS) $(PHPCSFLAGS) application/classes \
		application/config \
		application/i18n \
		application/messages \
		application/views

# produce an html coverage
coverage: clean
	$(PHPUNIT) $(PHPUNITFLAGS) --coverage-html coverage

# deploy an application
deployment: deployment-git deployment-composer migration clean permissions

# pull and update submodules
deployment-git:
	git pull
	git submodule sync --recursive
	git submodule update --init --recursive

# update composer packages
deployment-composer:
	$(COMPOSER) install

# generate the documentation
documentation:
	$(DOC) $(DOCFLAGS)

# clean the kohana cache files
clean:
	rm -f $(shell find $(CACHE) -type f -not -name '.*')

# migrate the current environment
migration: migration-$(shell echo $(ENV) | tr [:upper:] [:lower:])

# migrate the database
migration-%:
	$(PHINX) $(PHINXFLAGS) migrate --environment $(patsubst migration-%,%,$@)

# minify resources
minify: $(patsubst %.css, %.min.css, $(CSS)) $(patsubst %.js,%.min.js,$(JS))

%.min.css: %.css
	$(CSSM) $(CSSMFLAGS) $< > $@

%.min.js: %.js
	$(JSM) $(JSMFLAGS) $< > $@

# update permissions and SELinux context
permissions: permissions-mod permissions-selinux permissions-owner

permissions-mod:
	chmod -R 777 $(CACHE) $(LOGS)

permissions-selinux:
	chcon -R -t httpd_sys_script_rw_t $(CACHE)
	chcon -R -t httpd_sys_script_ra_t $(LOGS)

permissions-owner:
	chown -R $(USER):$(GROUP) $(CACHE) $(LOGS)

# run unit tests
test: migration-testing clean
	$(PHPUNIT) $(PHPUNITFLAGS)
