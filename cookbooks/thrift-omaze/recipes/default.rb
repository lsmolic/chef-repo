#
# Cookbook Name:: thrift-omaze
# Recipe:: default


#puts node['omaze'].inspect
#puts node['thrift-omaze'].inspect
#puts node['php'].inspect
#puts node['nginx'].inspect

version = node['thrift-omaze']['version']

include_recipe "build-essential"
include_recipe "boost"
include_recipe "python"

case node.platform_family
when "rhel", "fedora"
  %w{ flex bison libtool autoconf pkgconfig }.each do |pkg|
    package pkg
  end
else
  %w{ flex bison libtool autoconf pkg-config }.each do |pkg|
    package pkg
  end
end

# install autoconf
  cookbook_file "#{Chef::Config[:file_cache_path]}/autoconf-2.69-12.2.noarch.rpm" do
    action :create
    mode '755'
  end

  package "autoconf" do
    action :install
    source "#{Chef::Config[:file_cache_path]}/autoconf-2.69-12.2.noarch.rpm"
  end
  
# install thrift from git revision
  git "#{Chef::Config[:file_cache_path]}/thrift" do
    repository node['thrift-omaze']['git_repository']
    revision node['thrift-omaze']['git_revision']
    action :sync
  end

  bash "install_ruby_build" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      (cd thrift && ./bootstrap.sh)
      (cd thrift && ./configure #{node['thrift-omaze']['configure_options'].join(' ')})
      (cd thrift && make)
      (cd thrift && make install)
    EOH
    not_if { FileTest.exists?("/usr/local/bin/thrift") }
  end

#remote_file "#{Chef::Config[:file_cache_path]}/thrift-#{version}.tar.gz" do
#  source node['thrift-omaze']['source']
#  #source "#{node['thrift-omaze']['mirror']}/thrift/#{version}/thrift-#{version}.tar.gz"
#  #checksum node['thrift-omaze']['checksum']
#end
#
#bash "install_thrift" do
#  cwd Chef::Config[:file_cache_path]
#  code <<-EOH
#    (tar -zxvf thrift-#{version}.tar.gz)
#    (cd thrift-#{version} && ./configure #{node['thrift-omaze']['configure_options'].join(' ')})
#    (cd thrift-#{version} && make install)
#  EOH
#  not_if { FileTest.exists?("/usr/local/bin/thrift") }
#end
