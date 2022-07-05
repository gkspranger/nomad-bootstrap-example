name      = "server"
log_level = "DEBUG"
log_file  = "/var/log/nomad.log"
data_dir  = "/opt/nomad"
bind_addr = "0.0.0.0"

server {
  enabled             = true
  bootstrap_expect    = 1

  job_gc_interval = "1m"
  job_gc_threshold = "1m"
}
