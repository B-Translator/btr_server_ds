#!/bin/bash -x

### make a clone of /var/www/btr to /var/www/btr_dev
/usr/local/src/btr_server/ds/cfg/dev/clone.sh btr btr_dev

### don't redirect http:// to https://
sed -i /etc/apache2/sites-enabled/btr_dev.conf \
    -e 's/RedirectPermanent/#RedirectPermanent/'

### comment out the configuration of the database 'btr_db' so that
### the internal test database can be used instead for translations
sed -i /var/www/btr_dev/sites/default/settings.php \
    -e '/$databases..btr_db/,+8 s#^/*#//#'

### set $base_url to http://
sed -i /var/www/btr_dev/sites/default/settings.php \
    -e '/$base_url/ s#https://#http://#'

### add a test user
drush @btr_dev user-create user1 --password=pass1 \
      --mail='user1@example.org' > /dev/null 2>&1

### register a test oauth2 client on btr_server
drush @btr_dev oauth2-client-add test1 12345 \
    'https://btranslator.net/oauth2-client-php/authorized.php'