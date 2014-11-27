kohana-makefile
===============
Automate common boring tasks related to the Kohana framework.

This Makefile is designed to increase productivity when doing web development
under the Kohana framework. It allow you to set the permissions and much more.

Such a Makefile is very practical for settings permissions and SELinux context
on a production server on which you have SSH access.

So far, it
----------
* detects Kohana environment if providen by a `.htaccess` file
* cleans the cache
* set permissions and SELinux contexts
* minify js and css resources
* run [PHPUnit](https://phpunit.de/) tests
* generate the documentation with [ApiGen](http://apigen.org)
* migrate your database if you use [Phinx](http://phinx.org/)
* deploy your application using git, composer and Phinx
* makes you efficient at doing everything above

Installation
------------
Get the `Makefile` from GitHub:
```bash
wget https://raw.githubusercontent.com/arteymix/kohana-makefile/master/Makefile
```

If you need to add a target of adjust a flag, you can proceed in a specific
Makefile in `application/Makefile`, this one is automatically included if found.
```make
# Specific overrides in application/Makefile

CSS=public/css/app.css
JS=public/js/app.js

# add a cache folder
CACHE+=modules/twig/cache

# override executables
PHPUNIT=vendor/bin/phpunit
PHINX=vendor/bin/phinx
```

Then, you have a bunch of tools you can use
```bash
make clean         # delete the cache
make codesniffer   # sniff the code for errors
make deployment    # deploy the application
make documentation # generate the documentation
make migration     # migrate the database using Phinx
make minify        # minify resources in assets/js/* and assets/css/*
make permissions   # fix permissions and SELinux contexts on cache and logs
make test          # test your application
```

Deployment
----------
Makefile worries about your application deployment if you are using
[git](https://git-scm.com) and [composer](http://getcomposer.org):
```bash
make deployment
```
Assuming you deploy your code using SSH, it will pull the code from the
remote-tracking branch, initialize and update submodules recursively, install
Composer dependencies migrate your database clean the cache and fix the
permissions.

Found a bug?
-----------
Open an issue or pull-request a fix on GitHub.
