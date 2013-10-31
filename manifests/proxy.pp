#
# == Class: ipt-toolkit::proxy
#
#
class ipt-toolkit::proxy (
  $priority                       = undef,
  $proxy_pass                     = undef,
  $proxy_pass_preserve_host       = undef,
  $proxy_pass_reverse_cookie_path = undef,
  $port                           = undef,
  $name                           = undef,
)
{

include concat::setup

class { 'apache': 
    default_vhost => false,
}

include apache::mod::proxy_http
include apache::mod::proxy

apache::vhost { $name:
   port                           => $port,
   proxy_pass                     => $proxy_pass,
   proxy_pass_preserve_host       => $proxy_pass_preserve_host,
   proxy_pass_reverse_cookie_path => $proxy_pass_reverse_cookie_path,
   priority                       => $priority,
   docroot                        => '/var/www',
}

}
