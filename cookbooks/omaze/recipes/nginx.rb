# Default nginx recipes leave the conf.d/default.conf around which
# would override anything you might put in sites-enabled.

file "#{node['nginx']['dir']}/conf.d/default.conf" do
  action :delete
  not_if { node['nginx']['default_site_enabled'] }
  notifies :reload, 'service[nginx]'
end
