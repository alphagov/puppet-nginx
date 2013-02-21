# Define: nginx::vhost::redirect.
#
#   nginx vhost. redirects, For bouncing web traffic as you would with apache.
#
# Parameters:
#
# Requires:
#   include nginx::server
#
define nginx::vhost::redirect (
  $dest,
  $port           = '80',
  $priority       = '10',
  $template       = 'nginx/vhost-redirect.conf.erb',
  $servername     = '',
  $ssl            = false,
  $ssl_port       = '443',
  $ssl_cert       = $nginx::server::default_ssl_cert,
  $ssl_key        = $nginx::server::default_ssl_key,
  $status         = 'permanent',
  $magic          = '',
  $isdefaultvhost = false,
) {

  include nginx
  include nginx::params

  if $servername == '' {
    $srvname = $name
  } else {
    $srvname = $servername
  }

  # Need to make some variable names so the templates can use them!
  # Such as an app_server name that is unique, so when we have ssl and
  # non-ssl unicorn hosts they still work.
  if $ssl == true {
    $appname = regsubst( $srvname , '^(\w+?)\..*?$' , '\1_ssl' )
  } else {
    $appname = regsubst( $srvname , '^(\w+?)\..*?$' , '\1' )
  }

  file {
    "${nginx::params::vdir}/${priority}-${name}":
      content => template($template),
      owner   => 'root',
      group   => '0',
      mode    => '755',
      require => Package['nginx'],
      notify  => Service['nginx'],
  }

}
