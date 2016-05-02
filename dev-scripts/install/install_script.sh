#!/bin/bash

# Install script for in the docker container.
cd /var/www/html/;

# php profiles/social/modules/contrib/composer_manager/scripts/init.php
# composer drupal-rebuild
# composer update --lock

EXTRA=$1

fn_sleep() {
  if [[ $LOCAL != "nopause" ]]
  then
     sleep 5
  fi
}

drush -y site-install social --db-url=mysql://root:root@db:3306/social --account-pass=admin install_configure_form.update_status_module='array(FALSE,FALSE)';
fn_sleep
echo "installed drupal"
chown -R www-data:www-data /var/www/html/
fn_sleep
echo "set the correct owner"
php -r 'opcache_reset();';
fn_sleep
echo "opcache reset"
chmod 444 sites/default/settings.php
fn_sleep
echo "settings.php"
drush pm-enable social_demo -y
fn_sleep
echo "enabled module"
drush cc drush
drush sda file user topic event eventenrollment comment # Add the demo content
#drush sdr file user topic event eventenrollment comment # Remove the demo content
drush pm-uninstall social_demo -y
