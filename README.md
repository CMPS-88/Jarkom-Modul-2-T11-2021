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

## Soal 3
Setelah itu buat subdomain ```super.franky.yyy.com``` dengan alias ```www.super.franky.yyy.com``` yang diatur DNS nya di EniesLobby dan mengarah ke Skypie

### Jawaban

## Soal 4
Buat juga reverse domain untuk domain utama

### Jawaban

## Soal 5
Supaya tetap bisa menghubungi Franky jika server EniesLobby rusak, maka buat Water7 sebagai DNS Slave untuk domain utama

### Jawaban

## Soal 6
Setelah itu terdapat subdomain ```mecha.franky.yyy.com``` dengan alias ```www.mecha.franky.yyy.com``` yang didelegasikan dari EniesLobby ke Water7 dengan IP menuju ke Skypie dalam folder sunnygo

### Jawaban

## Soal 7
Untuk memperlancar komunikasi Luffy dan rekannya, dibuatkan subdomain melalui Water7 dengan nama ```general.mecha.franky.yyy.com``` dengan alias ```www.general.mecha.franky.yyy.com``` yang mengarah ke Skypie

### Jawaban

## Soal 8
Setelah melakukan konfigurasi server, maka dilakukan konfigurasi Webserver. Pertama dengan webserver ```www.franky.yyy.com```. Pertama, luffy membutuhkan webserver dengan DocumentRoot pada ```/var/www/franky.yyy.com```

### Jawaban


## Soal 9
Setelah itu, Luffy juga membutuhkan agar url ```www.franky.yyy.com/index.php/home``` dapat menjadi menjadi ```www.franky.yyy.com/home```. 

### Jawaban


## Soal 10
Setelah itu, pada subdomain ```www.super.franky.yyy.com```, Luffy membutuhkan penyimpanan aset yang memiliki DocumentRoot pada ```/var/www/super.franky.yyy.com```

### Jawaban

## Soal 11
Akan tetapi, pada folder ```/public```, Luffy ingin hanya dapat melakukan directory listing saja.

### Jawaban

## Soal 12
Tidak hanya itu, Luffy juga menyiapkan error file ```404.html``` pada folder ```/error``` untuk mengganti error kode pada apache

### Jawaban

## Soal 13
Luffy juga meminta Nami untuk dibuatkan konfigurasi virtual host. Virtual host ini bertujuan untuk dapat mengakses file asset ```www.super.franky.yyy.com/public/js``` menjadi ```www.super.franky.yyy.com/js```

### Jawaban

## Soal 14
Dan Luffy meminta untuk web ```www.general.mecha.franky.yyy.com``` hanya bisa diakses dengan port 15000 dan port 15500

### Jawaban

## Soal 15
dengan autentikasi username luffy dan password onepiece dan file di ```/var/www/general.mecha.franky.yyy```

### Jawaban

## Soal 16
Dan setiap kali mengakses IP Skypie akan dialihkan secara otomatis ke ```www.franky.yyy.com```

### Jawaban

## Soal 17
Dikarenakan Franky juga ingin mengajak temannya untuk dapat menghubunginya melalui website ```www.super.franky.yyy.com```, dan dikarenakan pengunjung web server pasti akan bingung dengan randomnya images yang ada, maka Franky juga meminta untuk mengganti request gambar yang memiliki substring “franky” akan diarahkan menuju ```franky.png```

### Jawaban

## Kendala
1. Ada beberapa konfigurasi yang belum kami mengerti sehingga harus mencari referensi dan memakan banyak waktu.
2. Ada beberapa perintah bash yang belum kami mengerti sehingga kami harus mencoba-coba untuk beberapa perintah bash.
