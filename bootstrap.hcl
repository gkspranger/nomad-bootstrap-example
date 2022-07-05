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

      artifact {
        source      = "git::https://github.com/gkspranger/nomad-bootstrap-example"
        destination = "${NOMAD_TASK_DIR}/repo"

        options {
          ref = "main"
          depth = 1
        }
      }

      config {
        command = "bash"
        args    = [
          "-c",
          <<-EOF
          /usr/local/bin/ansible-playbook \
          -i 127.0.0.1, \
          ${NOMAD_TASK_DIR}/repo/ansible/bootstrap.yml
          EOF
        ]
      }
    }
  }
}