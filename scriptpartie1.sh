#!/bin/bash
# scriptpartie1.sh

echo "Installer Apache"
sudo apt update
sudo apt install apache2
echo "Installez le module PHP"
sudo apt install libapache2-mod-php
echo "Installez le SGBD MySQL"
sudo apt update
sudo apt install mysql-server
echo "Créez une BD relative à votre projet"
echo "create database bd_app; create user1 identified by '123'; grant all on db_app.* to user1@'%'; " | sudo mysql
echo "Votre application se connectera à la BD avec les paramètres de cet utilisateur & password='123'"
echo "CREATE TABLE IF NOT EXISTS client (
    clt_id int NOT NULL AUTO_INCREMENT,
    nom varchar(20) DEFAULT NULL,
    prenom varchar(20) DEFAULT NULL,
    PRIMARY KEY(clt_id)
    );
INSERT INTO client (nom, prenom) VALUES ('layouni', 'nejla'),('ali', 'ali'); show databases; show tables; SELECT * FROM client;" | mysql -u user1 -p -D db_app 
cd /var/www/html/
sudo touch liste.php
sudo chmod 777 liste.php
echo "<html>
<head><title>Ceci est une page de liste</title><meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' /></head>
<body><h2>Page de liste des client</h2><p><?php echo 'Application de Nejla Layouni'; ?></p>
<a href='client.php'>Ajouter un client</a>
<h4>Liste des clients</h4>
<table border=2><tr><th>Nom Client</th><th>Prénom Client</th><th>Actions</th></tr>
<?php
\$bdd = new PDO('mysql:host=192.168.56.20;dbname=db_app', 'user1', '123');
\$reponse = \$bdd ->query('SELECT * FROM client'); 
while (\$donnees = \$reponse ->fetch()){ ?><tr><td><?php echo \$donnees['nom']; ?></td><td><?php echo \$donnees['prenom']; ?></td><td><a href='client.php?edit=<?php echo \$donnees['clt_id']; ?>' >Modifier</a>&nbsp;&nbsp;<a href='client.php?del=<?php echo \$donnees['clt_id']; ?>'>Supprimer</a></td></tr>
<?php } ?>
</table></body></html>" > liste.php

sudo touch client.php
sudo chmod 777 client.php
echo "<html>
<head><title>Page client</title></head>
<body>
<form action='client.php' method='POST'>
<?php
try{
\$connection = new PDO('mysql:host=192.168.56.20;dbname=db_app', 'user1', '123');
\$connection->exec('set names utf8');
}catch(PDOException \$exception){
echo 'Connection error: ' . \$exception->getMessage();
}

if (isset(\$_GET['edit']) || isset(\$_GET['del'])){
\$id = \$_GET['edit'];
\$id1 = \$_GET['del'];
\$sql = 'SELECT * FROM client WHERE clt_id=:id or clt_id=:id1';
\$query = \$connection->prepare(\$sql);
\$query->execute(array(':id' => \$id,':id1' => \$id1));
 
while(\$row = \$query->fetch(PDO::FETCH_ASSOC))
{
    \$nom = \$row['nom'];
    \$prix = \$row['prenom'];
   
}
}
?>

<div>
<input type='hidden' name='id' value='<?php echo \$_GET['edit'];?>'>
<input type='hidden' name='id1' value='<?php echo \$_GET['del'];?>'>
<div><b>Nom de client</b>
<input name='nom'  type='text' value='<?php echo \$nom; ?>'
<?php if (isset(\$_GET['del'])){?> readonly <?php } ?> >
</div>
<div><b>Prénom de client</b>
<input name='prenom' type='text' value='<?php echo \$prenom; ?>'
<?php if (isset(\$_GET['del'])){?> readonly <?php } ?> >
</div>
</div>
<br/>
<?php if (isset(\$_GET['edit'])){?>
<input value='Modifier' name='modif' type='submit'><br><br>
<a href='liste.php' >Liste des clients</a>
<?php } elseif (isset(\$_GET['del'])){?>
<input value='Supprimer' name='supp' type='submit'><br><br>
<a href='liste.php' >Liste des clients</a>
<?php }else{ ?>
<input value='Ajouter' name='ajout' type='submit'><br><br>
<a href='liste.php' >Liste des clients</a>
<?php } ?>
</form>
</body>
</html>

<?php

function ajouter(\$nom, \$prenom){
global \$connection;
\$query = 'INSERT INTO client(nom, prenom) VALUES( :nom, :prenom)';
\$callToDb = \$connection->prepare(\$query);
\$nom=htmlspecialchars(strip_tags(\$nom));
\$prenom=htmlspecialchars(strip_tags(\$prenom));
\$callToDb->bindParam(':nom',\$nom);
\$callToDb->bindParam(':prenom',\$prenom);
if(\$callToDb->execute()){
header('Location:liste.php');
}
}

if( isset(\$_POST['ajout'])){
\$nom = htmlentities(\$_POST['nom']);
\$prenom = htmlentities(\$_POST['prenom']);
\$result = ajouter(\$nom, \$prenom);
echo \$result;
}


function modifier(\$id,\$nom, \$prenom{
global \$connection;
\$query = 'UPDATE client SET nom=:nom, prenom=:prenom WHERE clt_id=:id';
\$callToDb = \$connection->prepare(\$query);
\$id = \$_POST['id'];
\$nom=htmlspecialchars(strip_tags(\$nom));
\$prenom=htmlspecialchars(strip_tags(\$prenom));
\$callToDb->bindParam(':id',\$id);
\$callToDb->bindParam(':nom',\$nom);
\$callToDb->bindParam(':prenom',\$prenom);
if(\$callToDb->execute()){
header('Location:liste.php');
}
}

if( isset(\$_POST['modif'])){
\$id = \$_GET['edit'];
\$nom = htmlentities(\$_POST['nom']);
\$prenom = htmlentities(\$_POST['premon']);
\$result = modifier(\$id,\$nom, \$prix);
echo \$result;
}


function supprimer(\$id){
global \$connection;
\$query = 'DELETE FROM client WHERE clt_id=:id';
\$callToDb = \$connection->prepare(\$query);
\$id = \$_POST['id1'];
\$callToDb->bindParam(':id',\$id);
if(\$callToDb->execute()){
header('Location:liste.php');
}
}

if (isset(\$_POST['supp'])){
\$id = \$_GET['del'];
\$result = supprimer(\$id);
echo \$result;
}
?>" > client.php

