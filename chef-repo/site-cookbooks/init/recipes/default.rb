#
# Cookbook Name:: init
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
service "firewalld" do
    supports [ :restart, :reload ]
    action [ :enable, :start ]
end

execute "allow port 8000" do
    command "firewall-cmd --add-port=8000/tcp --zone=public --permanent"
    notifies :restart, "service[firewalld]"
end
execute "allow port 389" do
    command "firewall-cmd --add-port=389/tcp --zone=public --permanent"
    notifies :restart, "service[firewalld]"
end

execute "set-locale" do
  command "localectl set-locale LANG=ja_JP.utf8"
end
