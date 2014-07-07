require 'yaml/store'

# Install Python packages 
bash "install flask" do
  code <<-EOH
    pip install Flask
    
  EOH
  not_if "pip freeze | grep Flask"
end

bash "install virtualenv" do
  code <<-EOH
    pip install virtualenv
  EOH
  not_if "pip freeze | grep virtualenv"
end

