# Name of the role should match the name of the file
name "development"

# Run list function we mentioned earlier
run_list(
	"recipe[php-xml]",
	"recipe[php]",
	"recipe[php-fpm]",
	"recipe[phpunit]",	
	"recipe[nginx]",
	"recipe[python]",
	"recipe[flask-omaze]",
	"recipe[thrift-omaze]",
	"recipe[mysql::server]",
	"recipe[mysql::client]",
	"recipe[nodejs]",
	"recipe[golang]",
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
			"password" => ''
		}
	},
	"php" => {
		"configure_options" => ["--with-openssl", "--with-zlib", "--with-curl", "--enable-exif", "--enable-mbstring", "--with-mcrypt", "--enable-ftp", "--with-mysqli", "--with-pdo-mysql", "--with-pear", "--with-config-file-path=/etc", "--enable-fpm", "--enable-opcache", "--with-xsl", "--with-dom"]
	},
	"php-fpm" => {
		"user" => "nginx",
		"group" => "nginx",
		"listen_owner" => "nginx",
		"listen_group" => "nginx",
		"pools" => [
			{ "name" => "wordpress" }
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
