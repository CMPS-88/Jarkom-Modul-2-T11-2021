# Jarkom-Modul-2-T11_2021

Nama Anggota | NRP
------------------- | --------------		
Justin Alfonsius Sitanggang | 05311840000043
Daniel Evan | 05311940000016
Calvin Manuel | 05311940000049


## Soal 1
EniesLobby akan dijadikan sebagai DNS Master, Water7 akan dijadikan DNS Slave, dan Skypie akan digunakan sebagai Web Server. Terdapat 2 Client yaitu Loguetown, dan Alabasta. Semua node terhubung pada router Foosha, sehingga dapat mengakses internet

### Jawaban
Untuk soal pertama ini kami membuat topologi sesuai dengan yang diperintahkan dalam soal.
<br> <img src="/ss/1.JPG">

Selanjutnya pada node ```Foosha``` kami menjalankan perintah ```iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.47.0.0/16``` untuk melakukan masquerade IP, dan setelah itu kami menjalankan perintah ```echo nameserver 192.168.122.1 > /etc/resolv.conf``` di setiap node yang lain, agar dapat terhubung dengan Foosha

## Soal 2
Luffy ingin menghubungi Franky yang berada di EniesLobby dengan denden mushi. Kalian diminta Luffy untuk membuat website utama dengan mengakses ```franky.yyy.com``` dengan alias ```www.franky.yyy.com``` pada folder kaizoku

### Jawaban
Pada soal kedua ini kami menuju ke node Ennies Lobby dan melakukan konfigurasi sebagai berikut :
```
apt-get update
apt-get install bind9 -y
echo -e 'zone "franky.t11.com" {\n    type master;\n    notify yes;\n    also-notify { 10.47.2.3; };\n    allow-transfer { 10.47.2.3; };\n    file "/etc/bind/kaizoku/franky.t11.com";\n};' >> /etc/bind/named.conf.local 
mkdir /etc/bind/kaizoku
cp /etc/bind/db.local /etc/bind/kaizoku/franky.t11.com
echo -e ';\n; BIND data file for local loopback interface\n;\n$TTL\t604800\n@       IN      SOA     franky.t11.com. root.franky.t11.com. (\n                              2         ; Serial\n                         604800         ; Refresh\n                          86400         ; Retry\n                        2419200         ; Expire\n                         604800 )       ; Negative Cache TTL\n;\n@       IN      NS      franky.t11.com.\n@       IN      A       10.47.2.2\nwww       IN      CNAME       franky.t11.com.\nsuper       IN      A       10.47.2.4\nwww.super       IN      CNAME       super.franky.t11.com.\n@       IN      AAAA    ::1' > /etc/bind/kaizoku/franky.t11.com
service bind9 restart
```
- ```apt-get update``` : berfungsi untuk melakukan update terhadap package pada node
- ```apt-get install bind9 -y``` : berfungsi untuk menginstall bind9 pada node
- ```echo -e 'zone "franky.t11.com" {\n    type master;\n    notify yes;\n    also-notify { 10.47.2.3; };\n    allow-transfer { 10.47.2.3; };\n    file "/etc/bind/kaizoku/franky.t11.com";\n};' >> /etc/bind/named.conf.local ``` : berfungsi untuk membuat zone pada file ```/etc/bind/named.conf.local```, sehingga dapat menjadi seperti berikut ini
```
zone "franky.t11.com" {
    type master;
    notify yes;
    also-notify { 10.47.2.3; };
    allow-transfer { 10.47.2.3; };
    file "/etc/bind/kaizoku/franky.t11.com";
};
```
- ```mkdir /etc/bind/kaizoku``` : berfungsi untuk membuat folder kaizoku pada /etc/bind/
- ```cp /etc/bind/db.local /etc/bind/kaizoku/franky.t11.com``` : berfungsi untuk melakukan copy file ```/etc/bind/db.local``` ke file ```/etc/bind/kaizoku/franky.t11.com```
- ```echo -e ';\n; BIND data file for local loopback interface\n;\n$TTL\t604800\n@       IN      SOA     franky.t11.com. root.franky.t11.com. (\n                              2         ; Serial\n                         604800         ; Refresh\n                          86400         ; Retry\n                        2419200         ; Expire\n                         604800 )       ; Negative Cache TTL\n;\n@       IN      NS      franky.t11.com.\n@       IN      A       10.47.2.2\nwww       IN      CNAME       franky.t11.com.\nsuper       IN      A       10.47.2.4\nwww.super       IN      CNAME       super.franky.t11.com.\n@       IN      AAAA    ::1' > /etc/bind/kaizoku/franky.t11.com``` : berfungsi untuk mengatur konfigurasi pada file /etc/bind/kaizoku/franky.t11.com yang nantinya menjadi seperti ini :
```
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     franky.t11.com. root.franky.t11.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      franky.t11.com.
@       IN      A       10.47.2.2
www       IN      CNAME       franky.t11.com.
super       IN      A       10.47.2.4
www.super       IN      CNAME       super.franky.t11.com.
@       IN      AAAA    ::1
```
- ```service bind9 restart``` : berfungsi untuk melakukan restart pada bind9

*note : pada pengaturan /etc/bind/kaizoku/franky.t11.com dijadikan satu dengan soal nomor 3 sehingga terlihat ada pengaturan untuk super.franky.t11.com*

Setelah itu kami melakukan perintah berikut ini di node Loguetown dan Alabasta yang merupakan node client<br>
```sed -i "1inameserver 10.47.2.2" /etc/resolv.conf```<br>
perintah tersebut berarti memasukkan IP EniesLobby ke ```etc/resolv.conf``` milik Loguetown dan Alabasta agar mereka dapat terhubung ke EniesLobby

<br> <img src="/ss/2.JPG">

## Soal 3
Setelah itu buat subdomain ```super.franky.yyy.com``` dengan alias ```www.super.franky.yyy.com``` yang diatur DNS nya di EniesLobby dan mengarah ke Skypie

### Jawaban
Untuk soal nomor 3 kami menggunakan perintah sebagai berikut :
- Pada EniesLobby
```
echo -e ';\n; BIND data file for local loopback interface\n;\n$TTL\t604800\n@       IN      SOA     franky.t11.com. root.franky.t11.com. (\n                              2         ; Serial\n                         604800         ; Refresh\n                          86400         ; Retry\n                        2419200         ; Expire\n                         604800 )       ; Negative Cache TTL\n;\n@       IN      NS      franky.t11.com.\n@       IN      A       10.47.2.2\nwww       IN      CNAME       franky.t11.com.\nsuper       IN      A       10.47.2.4\nwww.super       IN      CNAME       super.franky.t11.com.\n@       IN      AAAA    ::1' > /etc/bind/kaizoku/franky.t11.com
service bind9 restart
```
yang penting dari perintah diatas adalah konfigurasi berikut :
```
super       IN      A       10.47.2.4
www.super       IN      CNAME       super.franky.t11.com.
```
Sehingga subdomain super. akan mengarah ke skypie

<br> <img src="/ss/3.JPG">

## Soal 4
Buat juga reverse domain untuk domain utama

### Jawaban
Untuk soal nomor 4 kami menjalankan perintah berikut
- Pada EniesLobby
```
echo -e 'zone "2.47.10.in-addr.arpa" {\n\ttype master;\n\tfile "/etc/bind/kaizoku/2.47.10.in-addr.arpa";\n};' >> /etc/bind/named.conf.local
cp /etc/bind/db.local /etc/bind/kaizoku/2.47.10.in-addr.arpa
echo -e ';\n; BIND data file for local loopback interface\n;\n$TTL\t604800\n@       IN      SOA     franky.t11.com. root.franky.t11.com. (\n                              2         ; Serial\n                         604800         ; Refresh\n                          86400         ; Retry\n                        2419200         ; Expire\n                         604800 )       ; Negative Cache TTL\n;\n2.47.10.in-addr.arpa.       IN      NS      franky.t11.com.\n2           IN      PTR franky.t11.com.\n@       IN      AAAA    ::1' > /etc/bind/kaizoku/2.47.10.in-addr.arpa
service bind9 restart
```
perintah<br>
```
echo -e 'zone "2.47.10.in-addr.arpa" {\n\ttype master;\n\tfile "/etc/bind/kaizoku/2.47.10.in-addr.arpa";\n};' >> /etc/bind/named.conf.local
```
Berfungsi untuk mengkonfigurasi /etc/bind/named.conf.local, sehingga berbentuk seperti berikut :
```
zone "2.47.10.in-addr.arpa" {
        type master;
        file "/etc/bind/kaizoku/2.47.10.in-addr.arpa";
};
```
sedangkan perintah ```cp /etc/bind/db.local /etc/bind/kaizoku/2.47.10.in-addr.arpa``` bertujuan untuk melakukan copy file konfigurasi yang selanjutnya dimasukkan konfigurasi sebagai berikut :
```
echo -e ';\n; BIND data file for local loopback interface\n;\n$TTL\t604800\n@       IN      SOA     franky.t11.com. root.franky.t11.com. (\n                              2         ; Serial\n                         604800         ; Refresh\n                          86400         ; Retry\n                        2419200         ; Expire\n                         604800 )       ; Negative Cache TTL\n;\n2.47.10.in-addr.arpa.       IN      NS      franky.t11.com.\n2           IN      PTR franky.t11.com.\n@       IN      AAAA    ::1' > /etc/bind/kaizoku/2.47.10.in-addr.arpa
```
yang apabila dijalankan akan berbentuk sebagai berikut :
```
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     franky.t11.com. root.franky.t11.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
2.47.10.in-addr.arpa.       IN      NS      franky.t11.com.
2               IN      PTR franky.t11.com.
@       IN      AAAA    ::1
```
Terakhir kita restart bind9
- Pada Loguetown dan Alabasta
Pada Loguetown dan Alabasta kita jalankan perintah berikut untuk memastikan bahwa reverse DNS berfungsi dengan baik
```
apt-get install dnsutils -y
host -t PTR 10.47.2.2
```

<br> <img src="/ss/4.JPG">

## Soal 5
Supaya tetap bisa menghubungi Franky jika server EniesLobby rusak, maka buat Water7 sebagai DNS Slave untuk domain utama

### Jawaban
Untuk membuat DNS Slave kami menjalankan perintah berikut :
- Pada EniesLobby
```
echo -e 'zone "franky.t11.com" {\n    type master;\n    notify yes;\n    also-notify { 10.47.2.3; };\n    allow-transfer { 10.47.2.3; };\n    file "/etc/bind/kaizoku/franky.t11.com";\n};' >> /etc/bind/named.conf.local 
service bind9 restart
```
Perintah echo digunakan untuk mencetak perintah berikut pada file /etc/bind/named.conf.local
```
zone "franky.t11.com" {
    type master;
    notify yes;
    also-notify { 10.47.2.3; };
    allow-transfer { 10.47.2.3; };
    file "/etc/bind/kaizoku/franky.t11.com";
};
```

- Pada Water7
```
apt-get update -y
apt-get install bind9 -y
echo -e 'zone "franky.t11.com" {\n    type slave;\n    masters { 10.47.2.2; };\n    file "/var/lib/bind/franky.t11.com";\n};' >> /etc/bind/named.conf.local
service bind9 restart
```
Perintah echo digunakan untuk mencetak perintah berikut pada file /etc/bind/named.conf.local
```
zone "franky.t11.com" {
    type slave;
    masters { 10.47.2.2; };
    file "/var/lib/bind/franky.t11.com";
};
```
<br> <img src="/ss/5.JPG">
<br> <img src="/ss/6.JPG">

## Soal 6
Setelah itu terdapat subdomain ```mecha.franky.yyy.com``` dengan alias ```www.mecha.franky.yyy.com``` yang didelegasikan dari EniesLobby ke Water7 dengan IP menuju ke Skypie dalam folder sunnygo

### Jawaban
Pada soal ini kami menjalankan perintah sebagai berikut :
- Pada EniesLobby
```
sed -i "17ins1             IN      A       10.47.2.3" /etc/bind/kaizoku/franky.t11.com
sed -i "18imecha           IN      NS      ns1" /etc/bind/kaizoku/franky.t11.com
sed -i "s_dnssec-validation auto;_//dnssec-validation auto;_g" /etc/bind/named.conf.options
sed -i "22i     allow-query{any;};" /etc/bind/named.conf.options
service bind9 restart
```
Dua perintah berikut bertujuan untuk memasukkan konfigurasi pada file /etc/bind/kaizoku/franky.t11.com
```
sed -i "17ins1             IN      A       10.47.2.3" /etc/bind/kaizoku/franky.t11.com
sed -i "18imecha           IN      NS      ns1" /etc/bind/kaizoku/franky.t11.com
```
Sehingga menjadi sebagai berikut
```
ns1             IN      A       10.47.2.3
mecha           IN      NS      ns1
```

Sedangkan untuk dua perintah berikut bertujuan untuk mengubah setting pada file ```/etc/bind/named.conf.options```
```
sed -i "s_dnssec-validation auto;_//dnssec-validation auto;_g" /etc/bind/named.conf.options
sed -i "22i     allow-query{any;};" /etc/bind/named.conf.options
```
Sehingga menjadi 
```
//dnssec-validation auto;
allow-query{any;};
```
Selanjutnya kita restart bind9

- Pada Water7
Pada Water7 kami menjalankan perintah berikut :
```
sed -i "s_dnssec-validation auto;_//dnssec-validation auto;_g" /etc/bind/named.conf.options
sed -i "22i     allow-query{any;};" /etc/bind/named.conf.options
sed -i '8izone "mecha.franky.t11.com" {\n        type master;\n        file "/etc/bind/sunnygo/mecha.franky.t11.com";\n};' /etc/bind/named.conf.local
mkdir /etc/bind/sunnygo
cp /etc/bind/db.local /etc/bind/sunnygo/mecha.franky.t11.com
echo -e ';\n; BIND data file for local loopback interface\n;\n$TTL    604800\n@       IN      SOA     mecha.franky.t11.com. root.mecha.franky.t11.com. (\n                              2         ; Serial\n                         604800         ; Refresh\n                          86400         ; Retry\n                        2419200         ; Expire\n                         604800 )       ; Negative Cache TTL\n;\n@       IN      NS      mecha.franky.t11.com.\n@       IN      A       10.47.2.4\n@       IN      AAAA    ::1' > /etc/bind/sunnygo/mecha.franky.t11.com
sed -i "14iwww     IN      CNAME   mecha.franky.t11.com." /etc/bind/sunnygo/mecha.franky.t11.com
service bind9 restart
```
dua perintah awal digunakan untuk mengkonfigurasi file ```/etc/bind/named.conf.options```
```
sed -i "s_dnssec-validation auto;_//dnssec-validation auto;_g" /etc/bind/named.conf.options
sed -i "22i     allow-query{any;};" /etc/bind/named.conf.options
```
sehingga menjadi seperti berikut
```
        //dnssec-validation auto;
allow-query{any;};
```
Perintah berikut digunakan untuk mengkonfigurasi file /etc/bind/named.conf.local
```
sed -i '8izone "mecha.franky.t11.com" {\n        type master;\n        file "/etc/bind/sunnygo/mecha.franky.t11.com";\n};' /etc/bind/named.conf.local
```
sehingga menjadi seperti berikut
```
zone "mecha.franky.t11.com" {
        type master;
        file "/etc/bind/sunnygo/mecha.franky.t11.com";
};
```

Dua perintah berikut ini digunakan untuk membuat folder ```sunnygo``` dan membuat file konfigurasi
```
mkdir /etc/bind/sunnygo
cp /etc/bind/db.local /etc/bind/sunnygo/mecha.franky.t11.com
```

Sedangkan perintah berikut digunakan untuk mengkonfigurasi file ```etc/bind/sunnygo/mecha.franky.t11.com```
```
echo -e ';\n; BIND data file for local loopback interface\n;\n$TTL    604800\n@       IN      SOA     mecha.franky.t11.com. root.mecha.franky.t11.com. (\n                              2         ; Serial\n                         604800         ; Refresh\n                          86400         ; Retry\n                        2419200         ; Expire\n                         604800 )       ; Negative Cache TTL\n;\n@       IN      NS      mecha.franky.t11.com.\n@       IN      A       10.47.2.4\n@       IN      AAAA    ::1' > /etc/bind/sunnygo/mecha.franky.t11.com
sed -i "14iwww     IN      CNAME   mecha.franky.t11.com." /etc/bind/sunnygo/mecha.franky.t11.com
```
Sehingga menjadi
```
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     mecha.franky.t11.com. root.mecha.franky.t11.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      mecha.franky.t11.com.
@       IN      A       10.47.2.4
www     IN      CNAME   mecha.franky.t11.com.
@       IN      AAAA    ::1
```
Selanjutnya kita restart bind9

<br> <img src="/ss/7.JPG">
## Soal 7
Untuk memperlancar komunikasi Luffy dan rekannya, dibuatkan subdomain melalui Water7 dengan nama ```general.mecha.franky.yyy.com``` dengan alias ```www.general.mecha.franky.yyy.com``` yang mengarah ke Skypie

### Jawaban
Caranya kami konfigurasi di Water7:
```
echo -e ';\n; BIND data file for local loopback interface\n;\n$TTL    604800\n@       IN      SOA     mecha.franky.t11.com. root.mecha.franky.t11.com. (\n                              2         ; Serial\n                         604800         ; Refresh\n                          86400         ; Retry\n                        2419200         ; Expire\n                         604800 )       ; Negative Cache TTL\n;\n@       IN      NS      mecha.franky.t11.com.\n@       IN      A       10.47.2.4\n@       IN      AAAA    ::1' > /etc/bind/sunnygo/mecha.franky.t11.com
```

## Soal 8
Setelah melakukan konfigurasi server, maka dilakukan konfigurasi Webserver. Pertama dengan webserver ```www.franky.yyy.com```. Pertama, luffy membutuhkan webserver dengan DocumentRoot pada ```/var/www/franky.yyy.com```

### Jawaban
Caranya adalah menkonfigurasi pada EniesLobby dengan cara :
```
sed -i "s_DocumentRoot /var/www/html_DocumentRoot /var/www/franky.t11.com_g" /etc/apache2/sites-available/franky.t11.com.conft

```

## Soal 9
Setelah itu, Luffy juga membutuhkan agar url ```www.franky.yyy.com/index.php/home``` dapat menjadi menjadi ```www.franky.yyy.com/home```. 

### Jawaban
Caranya adalah menkonfigurasi pada Skypie
```
sed -i '16iAlias "/home" "/var/www/franky.t11.com/index.php/home"' /etc/apache2/sites-available/franky.t11.com.conf

```

## Soal 10
Setelah itu, pada subdomain ```www.super.franky.yyy.com```, Luffy membutuhkan penyimpanan aset yang memiliki DocumentRoot pada ```/var/www/super.franky.yyy.com```

### Jawaban
Caranya dengan menkonfigurasi pada Skypie : 
```
sed -i '23iAlias "/js" "/var/www/super.franky.t11.com/public/js"' /etc/apache2/sites-available/super.franky.t11.com.conf

```

## Soal 11
Akan tetapi, pada folder ```/public```, Luffy ingin hanya dapat melakukan directory listing saja.

### Jawaban
Caranya dengan menkonfigurasi kode di Skypie:
```
sed -i "16i<Directory /var/www/super.franky.t11.com/public>\n    Options +Indexes\n</Directory>" /etc/apache2/sites-available/super.franky.t11.com.conf

```

## Soal 12
Tidak hanya itu, Luffy juga menyiapkan error file ```404.html``` pada folder ```/error``` untuk mengganti error kode pada apache

### Jawaban
Caranya dengan menkonfigurasi di Skypie dengan : 
```
sed -i "19i<Directory /var/www/super.franky.t11.com/error>\n    Options -Indexes\n</Directory>" /etc/apache2/sites-available/super.franky.t11.com.conf
sed -i "22iErrorDocument 404 /error/404.html" /etc/apache2/sites-available/super.franky.t11.com.conf

```
## Soal 13
Luffy juga meminta Nami untuk dibuatkan konfigurasi virtual host. Virtual host ini bertujuan untuk dapat mengakses file asset ```www.super.franky.yyy.com/public/js``` menjadi ```www.super.franky.yyy.com/js```

### Jawaban
Melakukan konfigurasi dengan cara berikut :
```
sed -i "15iServerAlias www.super.franky.t11.com" /etc/apache2/sites-available/super.franky.t11.com.conf

```

## Soal 14
Dan Luffy meminta untuk web ```www.general.mecha.franky.yyy.com``` hanya bisa diakses dengan port 15000 dan port 15500

### Jawaban
Melakukan konfigurasi dengan cara berikut :
```
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/15000-general.mecha.franky.t11.com.conf

sed -i "s_DocumentRoot /var/www/html_DocumentRoot /var/www/general.mecha.franky.t11_g" /etc/apache2/sites-available/15000-general.mecha.franky.t11.com.conf
sed -i 1d /etc/apache2/sites-available/15000-general.mecha.franky.t11.com.conf
sed -i "1i<VirtualHost *:15000>" /etc/apache2/sites-available/15000-general.mecha.franky.t11.com.conf
sed -i "14iServerName general.mecha.franky.t11.com" /etc/apache2/sites-available/15000-general.mecha.franky.t11.com.conf
sed -i "15iServerAlias www.general.mecha.franky.t11.com" /etc/apache2/sites-available/15000-general.mecha.franky.t11.com.conf

cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/15500-general.mecha.franky.t11.com.conf

sed -i "s_DocumentRoot /var/www/html_DocumentRoot /var/www/general.mecha.franky.t11_g" /etc/apache2/sites-available/15500-general.mecha.franky.t11.com.conf
sed -i 1d /etc/apache2/sites-available/15500-general.mecha.franky.t11.com.conf
sed -i "1i<VirtualHost *:15500>" /etc/apache2/sites-available/15500-general.mecha.franky.t11.com.conf
sed -i "14iServerName general.mecha.franky.t11.com" /etc/apache2/sites-available/15500-general.mecha.franky.t11.com.conf
sed -i "15iServerAlias www.general.mecha.franky.t11.com" /etc/apache2/sites-available/15500-general.mecha.franky.t11.com.conf
sed -i "6iListen 15000" /etc/apache2/ports.conf
sed -i "7iListen 15500" /etc/apache2/ports.conf

a2ensite 15000-general.mecha.franky.t11.com.conf
a2ensite 15500-general.mecha.franky.t11.com.conf

```

## Soal 15
dengan autentikasi username luffy dan password onepiece dan file di ```/var/www/general.mecha.franky.yyy```

### Jawaban
Pertama membuat file php pada Skypie dengan username luffy dan password onepiece
```
echo -e '<?php\nif (isset($_POST["submit"])) {\n$username = $_POST["username"];\n$password = $_POST["password"];\nif ($username == "luffy" && $password == "onepiece"){\nheader("Location: http://www.general.mecha.franky.t11.com:15000/file");\ndie();\n}\nelse {\necho "salah";\n}\n}\n?>\n<!DOCTYPE html>\n<html>\n<head>\n<title>Form</title>\n</head>\n<body>\n<form action = "" method = "post">\nusername : <input type = "text" name = "username"/>\n<br><br>\npassword : <input type = "password" name = "password"/>\n<br><br>\n<input type = "submit" name = "submit" value = "Submit">\n</form>\n</body>\n</html>' > /var/www/general.mecha.franky.t11/index.php

```

Maka akan menghasilkan seperti berikut:
```
<?php
if (isset($_POST['submit'])) {
 $username = $_POST['username'];
 $password = $_POST['password'];
 if ($username == "luffy" && $password == "onepiece"){ 
  header("Location: http://www.general.mecha.franky.t11.com:15000/file");
  die();
 }
 else {
  echo "salah";
 }
}
?>
<!DOCTYPE html>
<html>
 <head>
  <title>Form</title>
 </head>

 <body>
  
  <!-- form tag to create form -->
  <form action = "" method = "post">
   
   username : <input type = "text" name = "username"/>
    
   <br><br>
   
   password : <input type = "password" name = "password"/>
   
   <br><br>
   
   <input type = "submit" name = "submit" value = "Submit">
  </form>
 
 </body>
</html>

```

## Soal 16
Dan setiap kali mengakses IP Skypie akan dialihkan secara otomatis ke ```www.franky.yyy.com```

### Jawaban
Melakukan konfigurasi terhadap Skypie dengan cara berikut :
```
echo -e "<VirtualHost *:80>\nServerName 10.47.2.4\nRedirect permanent / http://www.franky.t11.com/\n</VirtualHost>" > /etc/apache2/sites-available/000-default.conf

```

## Soal 17
Dikarenakan Franky juga ingin mengajak temannya untuk dapat menghubunginya melalui website ```www.super.franky.yyy.com```, dan dikarenakan pengunjung web server pasti akan bingung dengan randomnya images yang ada, maka Franky juga meminta untuk mengganti request gambar yang memiliki substring “franky” akan diarahkan menuju ```franky.png```

### Jawaban
Membuat konfigurasi di file .htaccess:
```
a2enmod rewrite
service apache2 restart
touch /var/www/super.franky.t11.com/.htaccess
echo -e "RewriteEngine On\nRewriteCond %{REQUEST_URI} !^/public/images/franky.png$\nRewriteCond %{REQUEST_FILENAME} !-d \nRewriteRule ^(.*)franky(.*)$ http://super.franky.t11.com/public/images/franky.png [R=301,L]" > /var/www/super.franky.t11.com/.htaccess
sed -i "22i<Directory /var/www/super.franky.t11.com>\n     Options +FollowSymLinks -Multiviews\n     AllowOverride All\n </Directory>" /etc/apache2/sites-available/super.franky.t11.com.conf
service apache2 restart

```

## Kendala
1. Ada beberapa konfigurasi yang belum kami mengerti sehingga harus mencari referensi dan memakan banyak waktu.
2. Ada beberapa perintah bash yang belum kami mengerti sehingga kami harus mencoba-coba untuk beberapa perintah bash.
