job "nomad-bootstrap" {
  datacenters = ["dc1"]
  type = "sysbatch"

  periodic {
    cron             = "* * * * * *"
    prohibit_overlap = true
  }

  constraint {
    attribute = "${meta.state}"
    value     = "bootstrapping"
  }

  group "nomad-bootstrap" {
    task "ansible-bootstrap" {
      driver = "raw_exec"

      config {
        command = "bash"
        args    = [
          "-c",
          <<-EOF
          /usr/local/bin/ansible-playbook \
          -i 127.0.0.1, \
          /vagrant/ansible/bootstrap.yml
          EOF
        ]
      }
    }
  }
}