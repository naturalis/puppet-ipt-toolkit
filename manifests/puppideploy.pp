#
# == Class: ipt-toolkit::proxy
#
#
class ipt-toolkit::puppideploy (
  $source            = undef,
  $deploy_root       = undef,
)
{
  puppi::project::war { "ipt-toolkit":
    source           => $source,
    deploy_root      => $deploy_root,
  } 
}
