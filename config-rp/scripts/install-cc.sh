
#!/bin/bash

# --------------------------------------------------------------------------------------------
# Installs CoinCooler on RP3, assuming we already installed raspbian-stretch-lite and ruby 2.5.1
# --------------------------------------------------------------------------------------------

# install desktop, so that we have chromium-browser and all that
sudo apt-get install -y raspberrypi-ui-mods rpi-chromium-mods

# fix issue with openssl support a-la https://github.com/oleganza/btcruby/issues/29
sudo ln -nfs /usr/lib/arm-linux-gnueabihf/libssl.so.1.0.2 /usr/lib/arm-linux-gnueabihf/libssl.so

# install nodejs js runtime
sudo apt install nodejs

# install sqlite
sudo apt install libsqlite3-dev

# install and configure bundler
gem install bundler
bundle config path .bundle
bundle config bin ".bundle/binstubs"
bundle config github.https true
bundle config disable_shared_gems true

# clone the coincooler repo and bundle
git clone https://github.com/assafshomer/rpcc.git coincooler
cd coincooler
bundle

# migrate sqlite3 db
bundle exec rake db:migrate
bundle exec rake db:migrate RAILS_ENV=test
bundle exec rake db:migrate RAILS_ENV=production
