#
# Cookbook Name:: ldap
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w[
  openldap
  openldap-clients
  openldap-servers
].each do |pkg|
    package "#{pkg}" do
        action [ :install ]
    end
end

service "slapd" do
    supports [ :restart, :reload ]
    action [ :enable, :start ]
end
execute "setup" do
  command "cp -p /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG"
  notifies :restart, "service[slapd]"
end

template "/tmp/add_rootPw.ldif" do
  source 'add_rootPw.ldif.erb'
  mode '0644'
end
template "/tmp/change-domain.ldif" do
  source 'change-domain.ldif.erb'
  mode '0644'
end
template "/tmp/base.ldif" do
  source 'base.ldif.erb'
  mode '0644'
end
template "/tmp/memberof-overlay.ldif" do
  source 'memberof-overlay.ldif.erb'
  mode '0644'
end
template "/tmp/refint-overlay.ldif" do
  source 'refint-overlay.ldif.erb'
  mode '0644'
end

rootDN  ="#{node['ldap']['rootDN']}"
rootPw  ="#{node['ldap']['rootPw']}"

execute "setup" do
  command <<-EOH
    cp -p /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
    ldapadd -Y EXTERNAL -H ldapi:// -f /tmp/add_rootPw.ldif
    ldapmodify -x -D cn=config -w xxxxxxxx -f /tmp/change-domain.ldif
    ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
    ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
    ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif
    ldapadd -Y EXTERNAL -H ldapi:/// -f /tmp/memberof-overlay.ldif
    ldapadd -Y EXTERNAL -H ldapi:/// -f /tmp/refint-overlay.ldif
    ldapadd -x -D "#{rootDN}" -w #{rootPw} -f /tmp/base.ldif
  EOH
end
