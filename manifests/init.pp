# Class: nginx
#
#   class description goes here.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage: include nginx
#
class nginx {

  include nginx::params

  if ! $nginx::params::package {
    fail( "No nginx possible on ${::hostname}" )
  }

  # We should monitor the state of nginx, though I am not sure this should be
  # here
  if defined(Class['munin'])  { include metrics::munin::nginx }

}
