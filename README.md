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
* minify resources (js and css)
* run PHPUnit tests
* generate the documentation
* migrate your database if you use [Phinx](http://phinx.org/)
* deploy your application
* makes you efficient at doing everything above

Installation
------------
```bash
git submodule add https://github.com/arteymix/kohana-makefile.git modules/makefile
ln -s modules/makefile/Makefile Makefile
```

Once installed, you can extend it by defining a Makefile in
`application/Makefile`:
```make
CSS=public/css/app.css
JS=public/js/app.js
CACHE+=modules/twig/cache
```

Then you run it
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
remote-tracking branch, initialize and update submodules, install composer
dependencies migrate your database and clean the cache.

Find a bug?
-----------
Open an issue or pull-request a fix on GitHub.
