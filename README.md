# Nomad Bootstrap Example

## Summary
I know that there are many ways to skin this cat, especially when adopting Consul/consul-template and robust `user-data` startup scripts .. That said, I am trying to introduce Nomad into an ecosystem where Ansible is the primary mechansim that configs a node into a "ready" state .. This includes deploying secrets into config files that we don't want baked into AMIs .. Yes, I know about Vault as well, but again -- I am trying to limit the spread of tooling so current team members feel very comfortable adopting Nomad as a job orchestrator .. Knowing all of that, here we go ..

## What is Known
- Nomad cluster running "normally"
    - In this example, we have 1 server and 1 client
- New Nomad client nodes join cluster on a regular basis in a state of "bootstrapping"
    - ```
      meta {
        state = "bootstrapping"
      }
      ```

## Goal
- New Nomad client nodes are "bootstrapped" with a specific Nomad job
    - Simple Ansible playbook running against localhost
    - This job will put new Nomad clients into a state of "ready"
        - ```
          meta {
            state = "ready"
          }
          ```
- "Normal" Nomad jobs are only allocated against "ready" Nomad clients

## Steps
- Spin up Nomad server
    - `vagrant up server`
- Deploy `bootstrap.hcl` job
    - `nomad job run /vagrant/bootstrap.hcl`
    - Job is using the `sysbatch` scheduler
    - Job runs periodically
        - Example is once every minute
- Deploy "normal" `sleep.hcl` job
    - `nomad job run /vagrant/sleep.hcl`
    - Will only deploy to "ready" Nomad clients using contraint
        - ```
          constraint {
            attribute = "${meta.state}"
            value     = "ready"
          }
          ```
- Observe both jobs
    - `bootstrap` is fine, just waiting to run on client node in "bootstrapping" state
        - http://localhost:4646/ui/jobs/nomad-bootstrap
    - `sleep` is "pending" because there are no "ready" nodes to allocate to
        - http://localhost:4646/ui/jobs/sleep
- Spin up Nomad client
    - `vagrant up client`
- Observe the `bootstrap` job run on the new client
    - Again, starts out in a "bootstrapping" state
    - Ansible updates Nomad config and restarts Nomad service
        - A `reload` will not work here
- Observe the `sleep` get allocated to "ready" Nomad client
- !! PROFIT !!
