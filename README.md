# vagrant-centos7-ldap
vagrant files for ldap server and php7 on centos7, 

## 手順

* chef-repo に移動して berks vendor cookbooks を実行
* chef-repo/site-cookbooks/ldap のattributes, templates を環境に合わせて修正。(baseDN,rootDN,passwordなど  )
* vagrant up を実行
* ldap-work/data にあるuser.ldif, group.ldif,acl.ldif を順に ldapadd する

## acl 設定
基本的には以下のように設定している。

* userPassword は本人とrootDNのみ変更可能
* ou=users 以下のエントリーは本人とrootDN, cn=managers,ou=groupsに所属するユーザー(管理グループユーザー)が変更できる
* 管理者、rootDN  以外は ou=groups を参照できない(これは今後変更するかも)
