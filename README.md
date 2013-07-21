CTHN Wiki Factory
=================

Yes, this thing is building CTHN wikis. Awesome, uh? The source repository is the wiki-data Repository, so if you want to make changes on the content, make the changes there and commit your stuff. After that, this repository comes in handy, which will generate static pages (and dynamich PHP clobber if you really want to) from the markdown files. You usually don't need this repository, but if you want to have an offline instance or your name is otih, you definitively need this :)


== Generate the pages ==
Set up a cronjob and execute the script `scripts/generate_pages.rb`. A new folder `public_html` will appear magically. Dont forget to pull the changes with `git submodule update` before running this script.

== Deployment ==
The relevant settings for Nginx is allready in the `scripts/nginx.conf` file. So just copy/paste this in your config, adjust to your needs and restart the HTTP server.
