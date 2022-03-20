#!/bin/bash
set e
apt-get update
test -f "autoproj_install" || wget -nv https://raw.githubusercontent.com/rock-core/autoproj/stable/bin/autoproj_install
export AUTOPROJ_OSDEPS_MODE=all
export AUTOPROJ_BOOTSTRAP_IGNORE_NONEMPTY_DIR=1
yes y | ruby autoproj_install
source env.sh
autoproj bootstrap git http://github.com/romulogcerqueira/sonar_simulation-buildconf.git
sed -i '26s/ssh/http/' /usr/app/sonar_simulation/autoproj/init.rb
sed -i '27s/ssh/http/' /usr/app/sonar_simulation/autoproj/init.rb
cd /usr/app/sonar_simulation
yes n | aup
amake
