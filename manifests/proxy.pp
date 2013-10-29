#
# == Class: ipt-toolkit::proxy
#
#
class ipt-toolkit::proxy (
  $priority		= undef,
  $proxy_pass 		= undef,
  $port 		= undef,  
  $name			= undef,
)
{

include concat::setup

class { 'apache': 
    default_vhost => false,
}
include apache::mod::proxy_http
include apache::mod::proxy


apache::vhost { $name:
   port		    => $port,
   proxy_pass       => $proxy_pass,
   priority	    => $priority,
   docroot          => '/var/www',
}

}
