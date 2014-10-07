kohana-makefile
===============

Automate common boring tasks related to the Kohana framework.

This Makefile is designed to increase productivity when doing web development
under the Kohana framework. It allow you to set the permissions and much more.

Such a Makefile is very practical for settings permissions and SELinux context
on a production server on which you have SSH access.

So far, it
----------
* cleans the cache
* minify resources (js and css)
* run PHPUnit tests
* generate the documentation
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
CACHE += modules/twig/cache
```

Then you run it
```bash
make test        # run PHPUnit
make clean       # delete the cache
make minify      # minify resources in assets/js/* and assets/css/*
make permissions # fix permissions and SELinux contexts on cache and logs
```

That would be really nice to have such a tool bundled with Kohana, so whenever
it gets interesting, I will submit it.
