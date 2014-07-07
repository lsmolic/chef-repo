# Name of the role should match the name of the file
name "development"

# Run list function we mentioned earlier
run_list(
#	"recipe[php]",
#	"recipe[nginx]",
	"recipe[python]",
	"recipe[thrift]",
#	"recipe[omaze]"
)

override_attributes("node" => { 
	"omaze" => {
		"web_application" => {
			"name" => 'omaze_local',
			"username" => 'vg',
			"domain_name" => 'localhost',
			"port" => '8080'
		},
		"database" => {
			"name" => 'omaze_local',
			"username" => 'root',
			"password" => ''
		}
	},
	"php" => {
		"configure_options" => ["--with-openssl", "--with-zlib", "--with-curl", "--enable-exif", "--enable-mbstring", "--with-mcrypt", "--enable-ftp", "--with-mysqli", "--with-pdo-mysql", "--with-pear", "--with-config-file-path=/etc", "--enable-fpm", "--enable-opcache", "--with-xsl", "--with-dom"]
	},
	"nginx" => {
		"dir" => '/etc/nginx',
		"log_dir" => '/var/log/nginx',
		"init_style" => 'runit',
		"default_site_enabled" => true
	},
	"thrift" => {
		"source" => "http://www.eng.lsu.edu/mirrors/apache/thrift/0.9.1/thrift-0.9.1.tar.gz",
		"configure_options" => []
	}
})