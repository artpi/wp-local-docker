# WordPress Docker Development Environment

This is a Docker based local development environment for WordPress. It is designed to be used with a production site. It contains a docker image - virtual environment to run Wordpress installation the same way on all computers.
It also contains an assortment of scripts that can be ran in this virtual environment. These tools help to keep your WordPress instalation in GIT.

This repository runs the site on your local computer. You will be able to develop site without internet - and what is more important - without a risk of breaking production.

## Developing WordPress

All the files you should concern yourself about are in `./wp-content`. There is a most recent Database dump in `./db-dump/production-dump.sql`.

## Setup with an existing production site.

1. Make sure you have [Docker toolbox for windows](https://docs.docker.com/toolbox/toolbox_install_windows/) (**important: select 'install git for windows' during installation. You will need GIT as well**) or [Docker for mac](https://docs.docker.com/docker-for-mac/install/) installed.
1. After docker installation restart computer please.
1. *Windows only*: Docker installs "Oracle VM Virtualbox Manager". Open it,
	- Go to Settings->Network->Advanced->Port Forwarding
	- Set up a rule with Host IP 127.0.0.1, Host port 80 and guest port 80
	- [Image here](https://cloudup.com/cUdYgc0gsoi)
	- if "default" image is running, stop it and start it 
1. Open "Docker quickstart terminal" on Win or Terminal.app on mac.
1. Set up your SSH [Github](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/), [Bitbucket](https://confluence.atlassian.com/bitbucket/set-up-an-ssh-key-728138079.html). Add keys to your account where this repository is.
1. Navigate to where you want to have your project on disk using `cd` command. Example: `cd /c/Users/artpi/Desktop/project` in case of windows and "Docker quickstart terminal"
1. `git clone https://github.com/artpi/wp-local-docker`
1. `cd wp-local-docker`
1. `docker-compose up -d`
1. Set up databases and WordPress
   - Enter the container: `docker-compose exec --user www-data phpfpm bash`
   - Set everything up: `/var/scripts/setup.sh`
1. Once everything is set up, you can see the site under [http://localhost](http://localhost)

### Multisite.
If you have a multisite, the short tutorial is:
1. `docker-compose up`
1. `docker-compose exec --user www-data phpfpm /var/scripts/setup.sh`
1. Now you have to edit wordpress/wp-config.php
```
// This is assuming you have your whole network under `artpi.pl`

define( 'WP_ALLOW_MULTISITE', true );
define( 'MULTISITE', true );
define( 'SUBDOMAIN_INSTALL', true );
$base = '/';
define( 'PRODUCTION_DOMAIN_CURRENT_SITE', 'artpi.pl' );
define( 'DOMAIN_CURRENT_SITE', 'dev.local' );
define( 'PATH_CURRENT_SITE', '/' );
define( 'SITE_ID_CURRENT_SITE', 1 );
define( 'BLOG_ID_CURRENT_SITE', 1 );
```
1. Add `127.0.0.1   dev.local` and `127.0.0.1   subdomain.dev.local` for every subdomain in `/etc/hosts`
1. Now run `docker-compose exec --user www-data phpfpm /var/scripts/import-db-from-prod-dump.sh` to set up everything.
1. You are good.

## Running scripts on container

There are some scripts in [bin/docker](./bin/docker) directory. To run them, you have to enter the virtual machine command line:
`docker-compose exec --user www-data phpfpm bash`

And then you can just run them `/var/scripts/scriptname`.


# Advanced tools

## Rebasing

This container has a script to rebase your content to mirror production server of your site. WordPress modifies stuff locally, so you will have to rebase it from time to time.

1. Download db dump from production PHPMyAdmin and save in `./db-dump/production-dump.sql`
2. Commit that file to GIT
3. Copy `./bin/docker/default-config.sh` to `./bin/docker/config.sh`. Change variables.
4. Run `/var/scripts/rebase.sh` inside container. It will download all files from ftp that are different than your wp-content dir and delete the ones that are deleted.
5. Commit that as a rebase
6. Profit.

## Administrative Tools

We've bundled a simple administrative override file to aid in local development where appropriate. This file introduces both [phpMyAdmin](https://www.phpmyadmin.net/) and [phpMemcachedAdmin](https://github.com/elijaa/phpmemcachedadmin) to the Docker network for local administration of the database and object cache, respectively.

You can run this atop a standard Docker installation by specifying _both_ the standard and the override configuration when initializing the service:

```
docker-compose -f docker-compose.yml -f admin-compose.yml up
```

The database tools can be accessed [on port 8092](http://localhost:8092).

The cache tools can be accessed [on port 8093](http://localhost:8093).

## Docker Compose Overrides File

Adding a `docker-compose.override.yml` file alongside the `docker-compose.yml` file, with contents similar to
the following, allows you to change the domain associated with the cluster while retaining the ability to pull in changes from the repo.

```
version: '3'
services:
  phpfpm:
    extra_hosts:
      - "dashboard.localhost:172.18.0.1"
  elasticsearch:
    environment:
      ES_JAVA_OPTS: "-Xms2g -Xmx2g"
```

## WP-CLI

Add this alias to `~/.bash_profile` to easily run WP-CLI command.

```
alias dcwp='docker-compose exec --user www-data phpfpm wp'
```

Instead of running a command like `wp plugin install` you instead run `dcwp plugin install` from anywhere inside the
`<my-project-name>` directory, and it runs the command inside of the php container.

There is also a script in the `/bin` directory that will allow you to execute WP CLI from the project directory directly: `./bin/wp plugin install`.

## SSH Access

You can easily access the WordPress/PHP container with `docker-compose exec`. Here's a simple alias to add to your `~/.bash_profile`:

```
alias dcbash='docker-compose exec --user root phpfpm bash'
```

This alias lets you run `dcbash` to SSH into the PHP/WordPress container.

Alternatively, there is a script in the `/bin` directory that allows you to SSH in to the environment from the project directory directly: `./bin/ssh`.

## MailCatcher

MailCatcher runs a simple local SMTP server which catches any message sent to it, and displays it in its built-in web interface. All emails sent by WordPress will be intercepted by MailCatcher. To view emails in the MailCatcher web interface, navigate to `http://localhost:1080` in your web browser of choice.

## Credits

This project is heavily modified fork of [wp-local-docker](https://github.com/10up/wp-local-docker)
