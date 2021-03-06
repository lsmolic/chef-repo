name             "thrift-omaze"
maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs thrift from source"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.2.0"

recipe "thrift-omaze", "Installs thrift from source"

supports "ubuntu"
supports "centos"

%w{ build-essential boost python }.each do |cb|
  depends cb
end
