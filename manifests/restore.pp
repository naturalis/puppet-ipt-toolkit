#
# class ipt-toolkit::restore
#
class ipt-toolkit::restore (
  $version           = undef,
  $bucket            = undef,
  $folder            = undef,
  $dest_id           = undef,
  $dest_key          = undef,
  $cloud             = undef,
  $pubkey_id         = undef,
  $filetorestore     = undef,
  $datadir           = undef,
  $restore_directory = undef,
)
{
  notify {'Restore enabled':}

  package { 'unzip':
    ensure => present,
  }

  duplicity::restore { 'data':
    directory      => $datadir,
    filetorestore  => $filetorestore,
    bucket         => $bucket,
    folder         => $folder,
    dest_id        => $dest_id,
    dest_key       => $dest_key,
    cloud          => $cloud,
    pubkey_id      => $pubkey_id,
  }

  exec { 'duplicityrestore.sh':
    command => '/bin/bash /usr/local/sbin/duplicityrestore.sh',
    path => '/usr/local/sbin:/usr/bin:/usr/sbin:/bin',
    require => [Package['duplicity'],File['/usr/local/sbin/duplicityrestore.sh']],
  }

}

