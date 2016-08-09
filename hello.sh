#!/bin/bash
parametr1=$1
sudo -u marsel rm -rf /home/marsel/www/$1
echo "Создаем папку $parametr1"
sudo -u marsel  mkdir /home/marsel/www/$1
echo "Переходим в созданную папку"
cd /home/marsel/www/$1
echo "Сейчас находимся в папке $PWD"
sudo -u marsel git init
echo "Инициализируем репозиторий"
sudo -u marsel touch index.php
echo "Создание файла"
sudo -u marsel echo '<?php echo "Hello,world" ?>' index.php


cd /etc/apache2/sites-available
echo "Переходим в sites-available"
echo "Создаем файл"
echo "<VirtualHost *:80>
	ServerAdmin webmaster@localhost
	ServerName loc.$1
	ServerAlias loc.$1
	DocumentRoot /home/marsel/www/$1

	ErrorLog /var/log/apache2/error.log
	CustomLog /var/log/apache2/access.log combined
</VirtualHost>">> loc.$1.conf

echo "Включаем новый сайт"
a2ensite loc.$1.conf
echo "Перезапускаем апач"
service apache2 reload
echo "Настраиваем хост"
echo "127.0.0.1 loc.$1">> /etc/hosts
echo "Запускаем браузер"

if which xdg-open > /dev/null
then
  xdg-open http://loc.$1
elif which gnome-open > /dev/null
then
  gnome-open http://loc.$1
fi
exit 0
