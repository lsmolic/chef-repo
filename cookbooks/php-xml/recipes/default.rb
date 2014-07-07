require 'yaml/store'

# Install Python packages 
bash "install php-xml" do
  code <<-EOH
    yum -y install php-xml
    
  EOH
  #not_if ""
end
