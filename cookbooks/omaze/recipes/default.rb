require 'yaml/store'

include_recipe 'omaze::nginx'
include_recipe "database::mysql"

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


#directory "/var/www/#{application_name}" do
#  action :create
#  owner user_name
#  group user_name
#  mode '755'
#end

#set all file in directory owned by 
directory "/var/www" do
  owner user_name
  group user_name
  mode '755'
  recursive true
end

#cookbook_file "/var/www/#{application_name}/index.html" do
#  action :create
#  owner user_name
#  group user_name
#  mode '755'
#end



# Nginx -- split this out into it's own recipe

template "#{nginx_dir}/sites-available/#{application_name}" do
  source "application.nginx.erb"
  mode '644'
  notifies :reload, 'service[nginx]'
end

begin
  nginx_site application_name
rescue
  puts "nginx_site method doesn't exist... aborting"
end

link "/var/www/#{application_name}" do
  to "/shared/#{application_name}"
  link_type :symbolic
end


## MYSQL --- split this out into it's own recipe

database_name = node['omaze']['database']['name']
mysql_root_pass = node['mysql']['server_root_password']
seed_file = "/shared/#{node['omaze']['database']['seed_file']}"

# create a mysql database
mysql_database 'omaze_local' do
  connection ({:host => "localhost", :username => 'root', :password => mysql_root_pass})
  action :create
end

mysql_database 'omaze_local' do
  connection ({:host => "localhost", :username => 'root', :password => mysql_root_pass})
  action :create
end

bash 'import omaze database' do
  code <<-EOH
    mysql -u root --password=\"#{mysql_root_pass}\" #{database_name} < #{seed_file}
  EOH
  only_if do
    File.exists?(seed_file)
  end
  not_if "mysql -uroot --password=\"#{mysql_root_pass}\" #{database_name} -e \"SHOW TABLES LIKE 'wp_options'\" | grep wp_options";
end

### PHP -- separate out into it's own recipe

directory "/var/lib/php/session" do
  action :create
  owner "nobody"
  group "nogroup"
  mode '755'
end

bash 'install pecl extention' do
  code <<-EOH
    printf "\n" | pecl install apc
    echo "extension=apc.so" > /etc/php.d/apc.ini
  EOH
  notifies :reload, 'service[nginx]'
end






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