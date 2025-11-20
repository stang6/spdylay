#!/bin/bash


vpsip=`ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk 'NR==1 { print $1}'`
apt-get update -y
apt-get upgrade -y
apt-get install -y make autoconf automake autotools-dev libtool pkg-config zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libevent-dev g++ unzip squid3 monit wget 

mkdir tmp
cd tmp
wget https://github.com/tatsuhiro-t/spdylay/archive/master.zip
unzip master
cd spdy*
autoreconf -i
automake
autoconf
./configure
make
cd src
mkdir /etc/shrpx
cp shrpx /etc/shrpx/
cat >>/etc/shrpx/shrpx.conf<<EOF
frontend=199.119.205.3,44300
backend=127.0.0.1,8000
private-key-file=/etc/shrpx/avpn.cc.key
certificate-file=/etc/shrpx/avpn.cc.crt
spdy-proxy=yes
daemon=yes
accesslog=yes
workers=32
EOF
sed -i 's/frontend=199.119.205.3/frontend='$vpsip'/g' /etc/shrpx/shrpx.conf

cat >>/etc/shrpx/avpn.cc.crt<<EOF
-----BEGIN CERTIFICATE-----
MIIExTCCA62gAwIBAgISESGrXMRO68vQxx4lGWcJBYSoMA0GCSqGSIb3DQEBCwUA
MEwxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSIwIAYD
VQQDExlBbHBoYVNTTCBDQSAtIFNIQTI1NiAtIEcyMB4XDTE0MTAyNDE0MjczMVoX
DTE5MTAyNDA1MjMwMlowNzEhMB8GA1UECxMYRG9tYWluIENvbnRyb2wgVmFsaWRh
dGVkMRIwEAYDVQQDDAkqLmF2cG4uY2MwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQDJib/Ywt7aeOV5Wvd/8tV4mksB8ilAyrG4zQMdTvsrjzvpt/jhpf8+
howGSuqt7MSNmFI5Sg1ILoYQUf4UC7plPszG/wpwTU85b2wCeoAAoeMv8+ew6Otc
ylWQHh6aBcSRJ74WfaKsDV91GzqzIh6j3IaNPuqfHY2CnAQuTVDYQ2DZ1y/SvMPR
7kb6LJbcUoCU3RQ7dyzMnMMFInSApCp4K36p+guopHw8fTTPOnFaJxzAV7sJZv7A
9DNEeya3vdX+nMUtuMJa2TykulLewPaiyE3pvxCXFicp6FabhOhXAlNLhFj7RTUl
iS8vukJbX2NpD14T9b3RwaCN4VjYlvP5AgMBAAGjggG0MIIBsDAOBgNVHQ8BAf8E
BAMCBaAwSQYDVR0gBEIwQDA+BgZngQwBAgEwNDAyBggrBgEFBQcCARYmaHR0cHM6
Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wHQYDVR0RBBYwFIIJKi5h
dnBuLmNjggdhdnBuLmNjMAkGA1UdEwQCMAAwHQYDVR0lBBYwFAYIKwYBBQUHAwEG
CCsGAQUFBwMCMD4GA1UdHwQ3MDUwM6AxoC+GLWh0dHA6Ly9jcmwyLmFscGhhc3Ns
LmNvbS9ncy9nc2FscGhhc2hhMmcyLmNybDCBiQYIKwYBBQUHAQEEfTB7MEIGCCsG
AQUFBzAChjZodHRwOi8vc2VjdXJlMi5hbHBoYXNzbC5jb20vY2FjZXJ0L2dzYWxw
aGFzaGEyZzJyMS5jcnQwNQYIKwYBBQUHMAGGKWh0dHA6Ly9vY3NwMi5nbG9iYWxz
aWduLmNvbS9nc2FscGhhc2hhMmcyMB0GA1UdDgQWBBSk3iUkkIrtIhU0PBLPKYH+
xAfq6TAfBgNVHSMEGDAWgBT1zdU8CFD5ak86t5faVoPmadJo9zANBgkqhkiG9w0B
AQsFAAOCAQEAZs+SXiQ1mVccUa9a0zBhifJJfqQZ5ob3uf8hRzEuqQFtuMuASsHT
4cK0Zum68X8sMVnQ3dVaFDA3DgJKnsNn+Q/+jDKse8AUrh/j5qs5lPnX5H+BTGIP
0PQ4sg5A68tDPbUqASxKweLAg5v0tJzxHP5+eogBnLz0bKLzdk2ADuddCSPCZChO
X0iQa7KDdr+/u8UMW9PzO6EEvQMLDH+WenRL1kgg6VZluz3QdNHNvMlj3BIt4cmg
3+MYriUkamE58211yS3C5TfnP3pxN2HoW4pLUTNqyYIjHzUyap5JHvxyTXxS2hec
CF/aZwT04CT5Cr9UzNAN8hb4xQWYDViTPQ==
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIETTCCAzWgAwIBAgILBAAAAAABRE7wNjEwDQYJKoZIhvcNAQELBQAwVzELMAkG
A1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExEDAOBgNVBAsTB1Jv
b3QgQ0ExGzAZBgNVBAMTEkdsb2JhbFNpZ24gUm9vdCBDQTAeFw0xNDAyMjAxMDAw
MDBaFw0yNDAyMjAxMDAwMDBaMEwxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9i
YWxTaWduIG52LXNhMSIwIAYDVQQDExlBbHBoYVNTTCBDQSAtIFNIQTI1NiAtIEcy
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2gHs5OxzYPt+j2q3xhfj
kmQy1KwA2aIPue3ua4qGypJn2XTXXUcCPI9A1p5tFM3D2ik5pw8FCmiiZhoexLKL
dljlq10dj0CzOYvvHoN9ItDjqQAu7FPPYhmFRChMwCfLew7sEGQAEKQFzKByvkFs
MVtI5LHsuSPrVU3QfWJKpbSlpFmFxSWRpv6mCZ8GEG2PgQxkQF5zAJrgLmWYVBAA
cJjI4e00X9icxw3A1iNZRfz+VXqG7pRgIvGu0eZVRvaZxRsIdF+ssGSEj4k4HKGn
kCFPAm694GFn1PhChw8K98kEbSqpL+9Cpd/do1PbmB6B+Zpye1reTz5/olig4het
ZwIDAQABo4IBIzCCAR8wDgYDVR0PAQH/BAQDAgEGMBIGA1UdEwEB/wQIMAYBAf8C
AQAwHQYDVR0OBBYEFPXN1TwIUPlqTzq3l9pWg+Zp0mj3MEUGA1UdIAQ+MDwwOgYE
VR0gADAyMDAGCCsGAQUFBwIBFiRodHRwczovL3d3dy5hbHBoYXNzbC5jb20vcmVw
b3NpdG9yeS8wMwYDVR0fBCwwKjAooCagJIYiaHR0cDovL2NybC5nbG9iYWxzaWdu
Lm5ldC9yb290LmNybDA9BggrBgEFBQcBAQQxMC8wLQYIKwYBBQUHMAGGIWh0dHA6
Ly9vY3NwLmdsb2JhbHNpZ24uY29tL3Jvb3RyMTAfBgNVHSMEGDAWgBRge2YaRQ2X
yolQL30EzTSo//z9SzANBgkqhkiG9w0BAQsFAAOCAQEAYEBoFkfnFo3bXKFWKsv0
XJuwHqJL9csCP/gLofKnQtS3TOvjZoDzJUN4LhsXVgdSGMvRqOzm+3M+pGKMgLTS
xRJzo9P6Aji+Yz2EuJnB8br3n8NA0VgYU8Fi3a8YQn80TsVD1XGwMADH45CuP1eG
l87qDBKOInDjZqdUfy4oy9RU0LMeYmcI+Sfhy+NmuCQbiWqJRGXy2UzSWByMTsCV
odTvZy84IOgu/5ZR8LrYPZJwR2UcnnNytGAMXOLRc3bgr07i5TelRS+KIz6HxzDm
MTh89N1SyvNTBCVXVmaU6Avu5gMUTu79bZRknl7OedSyps9AsUSoPocZXun4IRZZ
Uw==
-----END CERTIFICATE-----
EOF

cat >>/etc/shrpx/avpn.cc.key<<EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAyYm/2MLe2njleVr3f/LVeJpLAfIpQMqxuM0DHU77K4876bf4
4aX/PoaMBkrqrezEjZhSOUoNSC6GEFH+FAu6ZT7Mxv8KcE1POW9sAnqAAKHjL/Pn
sOjrXMpVkB4emgXEkSe+Fn2irA1fdRs6syIeo9yGjT7qnx2NgpwELk1Q2ENg2dcv
0rzD0e5G+iyW3FKAlN0UO3cszJzDBSJ0gKQqeCt+qfoLqKR8PH00zzpxWiccwFe7
CWb+wPQzRHsmt73V/pzFLbjCWtk8pLpS3sD2oshN6b8QlxYnKehWm4ToVwJTS4RY
+0U1JYkvL7pCW19jaQ9eE/W90cGgjeFY2Jbz+QIDAQABAoIBABSYL/ONjkpS+lgZ
VJtNjETjt3B+d3q4e8q/oGbZUE9WNrAebZ9ZYCjahOqLs0mMnVU+0IAsMglDP83h
Iw6XWDfKYBChtUZekA71dNsX+4aVBGs9CFsKoip8PpwYh9YDat/OaN1Rf1MHls6X
trrhbLIf8dvzJvSVh4VmPgMhQXan1Ysy7qr7Nqx+KonM9LmPFmP3ubDqM8WWjT+U
8FYA7H4SGmcoZaa+/Ad+dJtVupaRRs8FE1w03pGq+TSmkybrILNH3/Uthum0He5H
iVwHhzp97gJBQnyzbBgYQi3qgiarMv4CQjZChuU0X6kZTx2dFgc42sY1vqZ3JDYI
68/TtoECgYEA5rJCMvZTeNB11Ot/9QaU3wmRy0F0rfWroouTn19sz52xyEe8C3wA
hai2VVVbtOkutHI6FDCtgfLEI0vaJVA2N2qJHulB0crf0a+RyRSJcqhpnOJwRax5
CL9mO5Tjo0KKuayhl/G2MsOAGjDFY//QZYBICqmkx70esZQ9yA0/3pECgYEA36TB
EUbp5g/ZgBZqU/ypfOIZ3y47Cza5XHwS3lgs5nSKvj+UK2cQV7rJgbcr/nJGc2Ee
XQ855cDw119tXp5zLt3BL82GV2G4N9WQ1TA1U6jT3557TDLThbiqxIN8/aDvQrmO
1uIBL0VHeNzSYWZK2TNS7XbCE9nGubgw2uLUQukCgYBrIIIPKkXOx3bAPe+4d6rv
+4ChUy78jSV7oLcXffeIXaEt8OnIp3eSmaq5655fXx0aHCUONSCNRI+CGHofc6UJ
jMZJ/WVcJ4pR0+at6oR9IumQObKLGDFIN6Egr94ZdQ/4csrDRTInVpOJFfbDngpG
6BAMK4TiX9b9/WnHGSf8kQKBgQDcu5QDJWa+N26IyZbwhjQSmmbGrK6CBuU0rxFA
eu72FpjJ5Z6sp/CtZiJ08QFvBgMa5gQ9/UU7yw7qw7kC5ojw/NYsBEJQBJb6JMPq
ZsZ7Z+qWj6lKL/Atz3Jcuxqmii0cQmEFHdPlgA9m7yyGDZxafBmhXtF3Hj7SF0XB
BJhT4QKBgH9FVt1IYN9d1aVirGrrl7sYyaFvc8lU2L+jcc1RkndTwH0r+1lsAjWt
YSrpVqyux5a/e3FbQihxwl+Z3kn4tfHYvu29pB5LwVtmyq8VMdC0lDzIksvA3QZv
Ogwcp7ODdgm4xqO00iZ3c8qsgYc7WlM8e4y9rzfqKJ2OscQcIxj5
-----END RSA PRIVATE KEY-----
EOF



echo "Spdy install finished."
echo "Begin Squid3.."
cd /etc/squid3
mv squid.conf squid.conf.bak
cat >>/etc/squid3/squid.conf<<EOF
#  TAG: auth_param
#Authentication Radius:
#auth_param basic program /usr/lib/squid3/squid_radius_auth -f /etc/squid3/squid_rad_auth.conf
auth_param basic program /usr/lib/squid3/basic_radius_auth -f /etc/squid3/squid_rad_auth.conf

auth_param basic children 5
auth_param basic realm Welcome to VPNTECH
auth_param basic credentialsttl 2 hours
auth_param basic casesensitive off
acl radius-auth proxy_auth REQUIRED
dns_nameservers 8.8.8.8 8.8.4.4
#cache_dir /var/spool/squid 100 16 256
#  TAG: http_access
# Allow authorized users:
http_access allow radius-auth
visible_hostname vpntech.org
http_port 8000 transparent
via off
forwarded_for off
request_header_access Cache-Control deny all
request_header_access From deny all
request_header_access Server deny all
request_header_access Link deny all
request_header_access Via deny all
request_header_access X-Forwarded-For deny all

#cache_mem 256 MB
#maximum_object_size_in_memory 2048 KB
#cache_dir ufs /tmp 512 16 256
#minimum_object_size 0 KB
#maximum_object_size 32768 KB
#acl all src 0.0.0.0/0.0.0.0
acl all src all
#http_access allow all
EOF
cat >>/etc/squid3/squid_rad_auth.conf<<EOF
server v3.70707.cc
secret avpn
EOF
echo "Squid3 Finished."

systemctl enable squid

echo 'check process Shrpx with pidfile /var/run/shrpx.pid
	group system
	start program = "/etc/shrpx/shrpx --no-via -D --conf=/etc/shrpx/shrpx.conf --pid-file=/var/run/shrpx.pid"
#	stop  program = "/usr/bin/killall shrpx"
	stop  program = "/usr/bin/killall lt-shrpx"
	if failed host 50.116.9.132 port 44300 type tcp then restart
	if 5 restarts with 5 cycles then timeout
'>>/etc/monit/conf.d/shrpx

sed -i 's/50.116.9.132/'$vpsip'/g' /etc/monit/conf.d/shrpx

echo 'check process Squid3 with pidfile /var/run/squid3.pid
	group system
	start program = "/etc/init.d/squid3 start"
	stop  program = "/etc/init.d/squid3 stop"
	if failed port 8000 type tcp then restart
	if 5 restarts with 5 cycles then timeout
'>>/etc/monit/conf.d/squid


cat >>/etc/rc.local<<EOF
ulimit -f unlimited
ulimit -t unlimited
ulimit -v unlimited
ulimit -n 640000
ulimit -m unlimited
#ulimit -u 320000

/etc/shrpx/shrpx --no-via -D --conf=/etc/shrpx/shrpx.conf --pid-file=/var/run/shrpx.pid
EOF


echo '
 set mailserver localhost
 set alert catding@gmail.com
 set httpd port 2812 and
     allow andy:dydecat123
'>>/etc/monit/conf.d/monitrc

apt-get install lightsquid apache2 -y

sed -i 's/#AddHandler cgi-script .cgi/AddHandler cgi-script .cgi/g' /etc/apache2/mods-available/mime.conf 
sed -i 's/Listen 80/Listen 88/g' /etc/apache2/ports.conf
sed -i 's/Deny from all/Allow from all/g' /etc/apache2/conf.d/lightsquid
sed -i 's/NameVirtualHost *:80/NameVirtualHost *:88/g' /etc/apache2/ports.conf
a2enmod cgi
a2enconf lightsquid
service apache2 restart
[ -x /usr/share/lightsquid/lightparser.pl ] && /usr/share/lightsquid/lightparser.pl


lightsquid
	Order deny,allow
        Allow from 69.46.86.0/255.255.255.0
        Deny from all