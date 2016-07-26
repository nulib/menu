Metadata Editor - Northwestern University Library
=========

Server configuration:
- 1-4 Core CPU
- 4GB RAM
- 50GB storage
- RHEL
- nginx
- Passenger
- RVM
- Ruby 2.1
- Git
- mySQL

You'll need to install ImageMagick as well. The easiest way to use homebrew: brew install --with-libtiff imagemagick

Development Env
- start delayed jobs: `rake jobs:work`
- You may need to install the libv8 gem using `-- --with-system-v8` to make sure all the gems install (OSX only)

Attribution
------
menu uses the [jquery.xmleditor](https://github.com/UNC-Libraries/jquery.xmleditor), developed at UNC Chapel Hill Libraries by Ben Pennell and Mike Daines.
