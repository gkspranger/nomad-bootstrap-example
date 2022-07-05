job "sleep" {
  datacenters = ["dc1"]

  constraint {
    attribute = "${meta.state}"
    value     = "ready"
  }

  group "sleep" {
    task "sleep" {
      driver = "exec"

      config {
        command = "sleep"
        args    = ["1000"]
      }
    }
  }
}