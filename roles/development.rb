# Name of the role should match the name of the file
name "development"

# Run list function we mentioned earlier
run_list(
	"recipe[mysql::server]",
	"recipe[mysql::client]",
	"recipe[database]",
	"recipe[database::mysql]",
	"recipe[php-xml]",
	"recipe[php]",
	"recipe[php-fpm]",
	"recipe[phpunit]",	
	"recipe[nginx]",
#	"recipe[python]",
#	"recipe[flask-omaze]",
#	"recipe[thrift-omaze]",
#	"recipe[nodejs]",
#	"recipe[golang]",
	"recipe[omaze]"
)

override_attributes({
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
			"password" => '',
			"seed_file" => "db_minimal.sql"
		}
	},
	"mysql" => {
		"server_root_password" => ""
	},
	"php" => {
		"install_method" => "source",
		"url" => "http://museum.php.net/php5",
		"version" => "5.5.1",
		"source_packages" => 	["libvpx-devel", "bzip2-devel", "libc-client-devel", "curl-devel", 
                                "freetype-devel", "gmp-devel", "libjpeg-devel", "krb5-devel", "libmcrypt-devel",
                                "libpng-devel", "t1lib-devel", "mhash-devel", "php-xml", "php-mysql", "httpd-devel", "pcre-devel",
                                "net-snmp-devel", "readline-devel", "libXpm-devel", "enchant-devel", "libcurl-devel"],
		"configure_options" => ["--with-openssl", "--with-zlib", "--with-curl", "--enable-exif", 
								"--enable-mbstring", "--with-mcrypt", "--enable-ftp", "--with-mysqli", 
								"--with-pdo-mysql", "--with-pear", "--with-config-file-path=/etc", 
								"--enable-fpm", "--enable-opcache", "--with-xsl", "--with-vpx-dir=/usr",
								"--with-gd","--with-jpeg-dir=/usr","--with-png-dir=/usr","--with-xpm-dir=/usr","--with-freetype-dir=/usr",
								"--with-t1lib","--with-mhash","--with-mysql","--with-xmlrpc","--with-bz2",
								"--with-gettext","-enable-wddx","--enable-zip","--enable-bcmath","--enable-calendar",
								"--enable-soap","--enable-sockets","--enable-shmop","--enable-dba",
								"--enable-sysvmsg","--enable-sysvsem","--enable-sysvshm"]
	},
	"php-fpm" => {
		"user" => "nginx",
		"group" => "nginx",
		"listen_owner" => "nginx",
		"listen_group" => "nginx",
		"pools" => [
			{ 
				"name" => "omaze_local",
				"catch_workers_output" => "yes"
			}
		]
	},
	"phpunit" => {},
	"nginx" => {
		"dir" => '/etc/nginx',
		"log_dir" => '/var/log/nginx',
		"init_style" => 'runit',
		"default_site_enabled" => true
	},
	"python" => {},
	"thrift-omaze" => {
		"git_repository" => "https://github.com/apache/thrift",
		"git_revision" => "9c929c8979fab8d883b83df87034ed81373effb5",
		"configure_options" => ["--without-ruby"]
	}
})
