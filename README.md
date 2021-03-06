# TRLN Argon Rails Engine

The TRLN Argon Rails Engine provides additional templates, styles, search
builder behaviors, catalog controller overrides, and other features to
bootstrap a Blacklight catalog for the TRLN shared catalog index.

# Developing

We use [Engine Cart](https://github.com/cbeer/engine_cart) to run a development instance.  To run with `engine_cart`, clone this repository and change into the directory, then run:

       $ bundle exec rake engine_cart:prepare
       $ bundle exec rake engine_cart:server 
       $ # if you already have something on port 3000 and want to use a different port
    $ bundle exec rake engine_cart:server['-p 3001']

The TRLN Argon Blacklight catalog should now be available at [http://localhost:3000](http://localhost:3000) (or a different port if you used the second form).

## Creating a Rails Application using the TRLN Argon Engine.

This is what you want to do if you are intending to customize an application using the engine for a local catalog instance, it's not needed for development.

1. Create a new Rails application:

        $ rails new my_terrific_catalog

2. Install Blacklight and Argon, run the Blacklight and Argon generators.

Add the folliwing lines to your Gemfile:

```
gem 'blacklight', "~> 6.7"
gem 'trln_argon', git: 'https://github.com/trln/trln_argon'
```

3. Run the following:

        $ bundle install
        $ bundle exec rails generate blacklight:install --devise --marc
        $ bundle exec rails generate trln_argon:install
        $ bundle exec rake db:migrate

At this point, you have a rails application with all the trln_argon stuff installed, and you can run it with

    $ bundle exec puma -d

### Running in 'production' mode for speed (but not really *for production*, mind you)

Running a Rails application in production mode has a number of benefits, one
being that the application is not constantly checking to see if parts of it
have changed, that it has less verbose logging, etc.  If you are demoing the
project, you might want to use this mode, but note this is not a guide to
putting this engine into production, because it's not really secure long-term.
So do this at your own risk!

1. Create a secret key to use

        $ python -c 'import hashlib; import os; dg=hashlib.sha256(); dg.update("this is my r4dical secret"); dg.update(os.urandom(24)); print(dg.hexdigest())'

2. Edit `./start.sh`, taking the output of the above command and setting it as the value of `SECRET_KEY_BASE`, being sure to wrap it in quotes.

3. Precompile the assets:

        $ bundle exec rake assets:precompile

4. Run the application

        $ ./start.sh

5. Set up a web server to proxy the application and serve static assets

e.g. in Apache

```
<VirtualHost *.80>
    ServerName my.argon.hostname
    DocumentRoot /path/to/argon/public
    ProxyRequests Off
    ProxyPass ! /assets
    ProxyPass / http://localhost:3000/
    ProxyPassReverse / http://localhost:3000/
</VirtualHost>
```

Alternately, if you don't want to fiddle with Apache or NGINX, 
[Caddy](https://caddyserver.com/) is a standalone web server that is available for a number of platforms; this project contains a `Caddyfile` that listens on port 8080 and do pretty much the above, i.e. serve assets out of `public/assets` and proxy everything else back to Rails.  If `caddy` is installed, you can just run it in the application directory, like so:

        $ caddy

## About the `trln_argon:install` generator task

You can see what the generator does in this file: [install_generator.rb](https://github.com/trln/trln_argon/blob/master/lib/generators/trln_argon/install_generator.rb)


## Customizing your application

### Basic Settings

The Argon engine will add a configuration file to customize your application. Copy the sample file to use it

```
cp config/local_env.yml.sample config/local_env.yml
```

You will need to change settings in this file so that features like record rollup and filtering to just your local collection will work as expected.

```
SOLR_URL: http://127.0.0.1:8983/solr/trln
LOCAL_INSTITUTION_CODE: unc
APPLICATION_NAME: TRLN Argon
PREFERRED_RECORDS: "unc, trln"
REFWORKS_URL: "http://www.refworks.com.libproxy.lib.unc.edu/express/ExpressImport.asp?vendor=SearchUNC&filter=RIS%20Format&encoding=65001&url="
ROOT_URL: 'https://discovery.trln.org'
ARTICLE_SEARCH_URL: 'http://libproxy.lib.unc.edu/login?url=http://unc.summon.serialssolutions.com/search?s.secure=f&s.ho=t&s.role=authenticated&s.ps=20&s.q='
CONTACT_URL: 'https://library.unc.edu/ask/'
```

### Changing Styles

Sass variables and other styles may be overridden in:
`your_app/assets/stylesheets/trln_argon.scss`  See
`assets/stylesheet/application.scss` for other stylesheets that are imported.

### Changing field labels and other UI text.

Both Blacklight and the Argon engine use a translation files for many UI text
elements. This makes it easy to change text that appears throughout the UI.

You can see the default Argon translations in
[trln_argon.en.yml](https://github.com/trln/trln_argon/blob/master/config/locales/trln_argon.en.yml).
You can override any of these values by adding your own translations to a
locales file in your application, such as in config/locales/blacklight.en.yml.

### Changing blacklight configurations related to search, metadata display, and faceting.

The Argon engine sets a number of blacklight configurations to default settings
so that your catalog will work out of the box. If you want to change the
default number of records per page, change the order or selection of available
facets, or change the order or selection of metadata to display on brief or
full records, you will need to modify your application's CatalogController in
app/controllers/catalog_controller.rb.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
