require 'yaml/store'

include_recipe 'omaze::nginx'

puts node['nginx'].inspect

application_name = node['omaze']['web_application']['name']
user_name = node['omaze']['web_application']['username']
nginx_dir = node['nginx']['dir']

#user "#{user_name}" do
#  action :create
#end

directory "/home/#{user_name}/.ssh" do
  action :create
  owner user_name
  group user_name
  mode '700'
end

cookbook_file "/home/#{user_name}/.ssh/authorized_keys" do
  action :create
  owner user_name
  group user_name
  mode '600'
end

cookbook_file "/home/#{user_name}/.ssh/id_rsa" do
  action :create
  owner user_name
  group user_name
  mode '600'
end

directory "/var/www" do
  action :create
  owner user_name
  group user_name
  mode '755'
end

directory "/var/www/#{application_name}" do
  action :create
  owner user_name
  group user_name
  mode '755'
end

#set all file in directory owned by 
directory "/var/www" do
  owner user_name
  group user_name
  mode '755'
  recursive true
end

cookbook_file "/var/www/#{application_name}/index.html" do
  action :create
  owner user_name
  group user_name
  mode '755'
end

#directory '/u' do
#  action :create
#  mode '755'
#end

#link '/u/apps' do
#  to '/var/www'
#end

# Nginx

template "#{nginx_dir}/sites-available/#{application_name}" do
  source "application.nginx.erb"
  mode '644'
  notifies :reload, 'service[nginx]'
end

nginx_site application_name

# Open up ports for NAT

## NECESSARY??/

#bash 'iptable changes' do
#  code <<-EOH
#    iptables -I INPUT -p tcp --dport 80 -j ACCEPT
#    iptables -I INPUT -p tcp --dport 443 -j ACCEPT
#  EOH
#  not_if { `iptables -L | grep http`.split("\n").count >= 2 }
#end
#