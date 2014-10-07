# Kohana Makefile
#
# PHPUnit, ApiGen, cssmin and uglifyjs are suggested, but you can override them 
# in a specific Makefile located in application/Makefile.

# user and group for the web server
USER=apache
GROUP=apache

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

# coverage
COVERAGE=$(PHPUNIT)
COVERAGEFLAGS=$(PHPUNITFLAGS) --coverage-html

# phpcs
PHPCS=phpcs
PHPCSFLAGS=

all: permissions clean minify

# Include specific Makefile
-include application/Makefile

# update permissions and SELinux context
permissions: permissions-mod permissions-selinux permissions-owner

# set mod on cache and logs
permissions-mod:
	chmod -R 777 $(CACHE) $(LOGS)

# set SELinux contexts on cache and logs
permissions-selinux:
	chcon -R -t httpd_sys_script_rw_t $(CACHE)
	chcon -R -t httpd_sys_script_ra_t $(LOGS)

# set owner on cache and logs
permissions-owner:
	chown -R $(USER):$(GROUP) $(CACHE) $(LOGS)

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
.PHONY: coverage
coverage: clean
	$(COVERAGE) $(COVERAGEFLAGS) coverage

# sniff code for errors
codesniffer:
	$(PHPCS) $(PHPCSFLAGS) application/classes \
	                       application/config \
						   application/i18n \
						   application/messages \
						   application/views

# generate the documentation
documentation:
	$(DOC) $(DOCFLAGS)

# clean the kohana cache files
clean:
	rm -f $(shell find $(CACHE) -type f -not -name '.*')
