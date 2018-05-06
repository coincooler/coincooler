
#!/bin/bash

# --------------------------------------------------------------------------------------------
# Installs CoinCooler on RP3
# --------------------------------------------------------------------------------------------

# rname the machine
sudo sed -i 's/raspberrypi/coincooler/g' /etc/hostname
sudo sed -i 's/raspberrypi/coincooler/g' /etc/hosts

# install nodejs js runtime, sqlite and srm
sudo apt install nodejs libsqlite3-dev secure-delete

# fix issue with openssl support a-la https://github.com/oleganza/btcruby/issues/29
sudo ln -nfs /usr/lib/arm-linux-gnueabihf/libssl.so.1.0.2 /usr/lib/arm-linux-gnueabihf/libssl.so

# install and configure bundler
gem install bundler
bundle config path .bundle
bundle config bin ".bundle/binstubs"
bundle config github.https true
bundle config disable_shared_gems true

# clone the coincooler repo and bundle
git clone https://github.com/assafshomer/rpcc.git
cd coincooler
bundle

# migrate sqlite3 db
bundle exec rake db:migrate
bundle exec rake db:migrate RAILS_ENV=test
bundle exec rake db:migrate RAILS_ENV=production

# precompile assets
bundle exec rake assets:precompile

# run tests
bundle exec rspec spec

# copy over config files
sudo cp ~/coincooler/config-rp/scripts/.aliases ~/.aliases
sudo cp ~/coincooler/config-rp/launchers/CoinCooler ~/Desktop
sudo cp ~/coincooler/config-rp/launchers/coincooler.desktop /usr/share/raspi-ui-overrides/applications

# quicklaunch hack
read -d '' String <<"EOF"
# coincooler
source .aliases
if [ ! -f /home/pi/coincooler/tmp/pids/server.pid ]; then
    coincooler
fi
EOF

# Save to ~/.bashrc
echo -e "\n${String}" >> ~/.bashrc
