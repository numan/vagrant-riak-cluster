class riak {
  file {"/etc/riak/vm.args":
    content => template("riak/etc/riak/vm.args.erb"),
    require => Package["riak"]
  }

  file {"/etc/riak/app.config":
    content => template("riak/etc/riak/app.config.erb"),
    require => Package["riak"]
  }

  file {"/etc/riak/cert.pem":
    source => "puppet:///modules/riak/etc/riak/cert.pem",
    require => Package["riak"]
  }

  file {"/etc/riak/key.pem":
    source => "puppet:///modules/riak/etc/riak/key.pem",
    require => Package["riak"]
  }

  service {"riak":
    enable => true,
    ensure => "running",
    subscribe => [File["/etc/riak/vm.args"], File["/etc/riak/app.config"], File["/etc/riak/cert.pem"], File["/etc/riak/key.pem"]],
  }

  package {"libssl0.9.8":
    ensure => present
  }

  package { "riak":
    provider => dpkg,
    ensure => latest,
    source => "/vagrant/riak/riak_1.2.1-1_amd64.deb"
  }

  Package["libssl0.9.8"] -> Package["riak"] -> Service["riak"]
}
