#!/bin/bash
# scriptpartieM.sh

echo "Installez le SGBD MySQL"
sudo apt update
sudo apt install mysql-server
echo "Créez une BD relative à votre projet"
echo "create database bd_app; create user user1 identified by '123'; grant all on bd_app.* to user1@'%'; " | sudo mysql
echo "Votre application se connectera à la BD avec les paramètres de cet utilisateur & password='123'"
echo "CREATE TABLE IF NOT EXISTS client (
    clt_id int NOT NULL AUTO_INCREMENT,
    nom varchar(20) DEFAULT NULL,
    prenom varchar(20) DEFAULT NULL,
    PRIMARY KEY(clt_id)
    );
INSERT INTO client (nom, prenom) VALUES ('layouni', 'nejla'),('ali', 'ali'); show databases; show tables; SELECT * FROM client;" | mysql -u user1 -p -D bd_app -h 192.168.56.23 -P 3306 
