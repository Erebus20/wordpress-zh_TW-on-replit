#!/bin/bash
# Install WordPress 中文版 on Repl.it
# Copyright © by 舒夏 All Rights Reserved.
# 2022/12/6 12:27
# 1. Create a new Repl.it as a PHP Web Server 
# 2. Update the replit.nix file to include the code in this repo
# 3. Restart the Repl
# 4. Run this command from the Replit shell:
#    bash <(curl -s https://raw.githubusercontent.com/Erebus20/wordpress-zh_TW-on-replit/main/build.sh)

echo "準備在您的 Replit 中安裝 Wordpress"

read -p "繼續?輸入Y安裝輸入N退出 <Y/n> " prompt
if [[ $prompt == "N" || $prompt == "n" || $prompt == "No" || $prompt == "no" ]]; then
  exit 0
fi

#Make sure steps 1-3 are completed before installing Wordpress
if ! [ -x "$(command -v less)" ]; then
  echo 'Error: less is not installed. Please make sure you have updated the replit.nix file and restarted the Repl.' >&2
  exit 1
fi

if ! [ -x "$(command -v wp)" ]; then
  echo 'Error: wp-cli is not installed. Please make sure you have updated the replit.nix file and restarted the Repl.' >&2
  exit 1
fi

#Make sure we're in the right place!
cd ~/$REPL_SLUG

#remove default repl.it code file
rm ~/$REPL_SLUG/index.php

#Download Wordpress!
wp core download --locale=zh_TW

#SQLITE Plugin: Download, extract and cleanup sqlite plugin for WP
curl -LG https://raw.githubusercontent.com/Erebus20/wordpress-zh_TW-on-replit/main/db.php > ./wp-content/db.php

#Create dummy config to be overruled by sqlite plugin
wp config create --skip-check --dbname=wp --dbuser=wp --dbpass=pass --extra-php <<PHP
\$_SERVER[ "HTTPS" ] = "on";
define( 'WP_HOME', 'https://$REPL_SLUG.$REPL_OWNER.repl.co' );
define( 'WP_SITEURL', 'https://$REPL_SLUG.$REPL_OWNER.repl.co' );
define ('FS_METHOD', 'direct');
define('FORCE_SSL_ADMIN', true);
PHP

# Get info for WP install
read -p "输入 Wordpress 用户名: " username
while true; do
  read -s -p "輸入 Wordpress 密碼: " password
  echo
  read -s -p "再次輸入Wordpress 密碼: " password2
  echo
  [ "$password" = "$password2" ] && break
  echo "請重新嘗試！"
done

read -p "請輸入 Wordpress Email: " email
read -p "請輸入 Wordpress 站點標題: " title

REPL_URL=$REPL_SLUG.$REPL_OWNER.repl.co

# Install Wordpress
wp core install --url=$REPL_URL --title=$title --admin_user=$username --admin_password=$password --admin_email=$email

echo "恭喜!!!"
echo "您的新WordPress網站現已設置完成! "
echo "網頁地址: https://$REPL_URL"
echo "管理員地址: https://$REPL_URL/wp-admin"
echo "管理員賬號: $username"
echo "管理員密碼: $password"
echo "點擊Run按鈕運行WordPress博客項目"
rm -rf install.sh
