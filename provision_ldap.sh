export DEBIAN_FRONTEND='noninteractive'

apt-get install -y debconf-utils slapd ldap-utils phpldapadmin

debconf-set-selections <<< "slapd slapd/no_configuration boolean false"
debconf-set-selections <<< "slapd slapd/domain string rabbitmq.local"
debconf-set-selections <<< "slapd shared/organization string example"
debconf-set-selections <<< "slapd slapd/password1 password changeme"
debconf-set-selections <<< "slapd slapd/password2 password changeme"
debconf-set-selections <<< "slapd slapd/backend select MDB"
debconf-set-selections <<< "slapd slapd/purge_database boolean false"
debconf-set-selections <<< "slapd slapd/move_old_database boolean true"
debconf-set-selections <<< "slapd slapd/allow_ldap_v2 boolean false"

dpkg-reconfigure -u slapd

cp /vagrant/config.php /etc/phpldapadmin/config.php

LDIF=$(cat<<EOF
dn: ou=users,dc=rabbitmq,dc=local
changetype: add
objectClass: organizationalUnit
objectClass: top
ou: users

EOF
)
echo "$LDIF" | ldapmodify -x -D "cn=admin,dc=rabbitmq,dc=local" -w "changeme"

LDIF=$(cat<<EOF
dn: ou=groups,dc=rabbitmq,dc=local
changetype: add
objectClass: organizationalUnit
objectClass: top
ou: groups

EOF
)
echo "$LDIF" | ldapmodify -x -D "cn=admin,dc=rabbitmq,dc=local" -w "changeme"

LDIF=$(cat<<EOF
dn: cn=LDAP User 1,ou=users,dc=rabbitmq,dc=local
changetype: add
cn: LDAP User 1
givenName: LDAP
gidNumber: 500
homeDirectory: /home/users/ldapuser1
sn: User 1
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
uidNumber: 1000
uid: ldapuser1
userPassword: changeme

EOF
)
echo "$LDIF" | ldapmodify -x -D "cn=admin,dc=rabbitmq,dc=local" -w "changeme"

LDIF=$(cat<<EOF
dn: cn=LDAP User 2,ou=users,dc=rabbitmq,dc=local
changetype: add
cn: LDAP User 2
givenName: LDAP
gidNumber: 500
homeDirectory: /home/users/ldapuser2
sn: User 2
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
uidNumber: 1001
uid: ldapuser2
userPassword: changeme

EOF
)
echo "$LDIF" | ldapmodify -x -D "cn=admin,dc=rabbitmq,dc=local" -w "changeme"

ldapsearch -H ldap:// -x -b "dc=rabbitmq,dc=local"
