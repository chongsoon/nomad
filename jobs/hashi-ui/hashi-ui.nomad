#testing........
# This job will deploy https://github.com/jippi/hashi-ui using the
# docker driver.
job "hashi-ui" {
  datacenters = ["[[.datacenter]]"]
  region      = "[[.region]]"
  type        = "service"

  update {
    stagger      = "30s"
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "10m"	
	  auto_revert      = true
  }

  group "hashi-ui" {
    count = 1

    task "hashi-ui" {

      driver = "docker"

      config {
        #network_mode = "host"
        image = "jippi/hashi-ui:[[.version]]"
      }
      
      service {
        name = "hashi-ui"
        tags = ["http", "ui", "urlprefix-[[.urlprefix]]", "[[.version]]"]

        port = "http"
        address_mode = "host"

        check {
          type     = "http"
          address_mode = "host"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }

      env {
        NOMAD_ENABLE = 1
        NOMAD_ADDR   = "http://10.0.0.86:4646"
      }

      resources {
        cpu    = [[.cpu]]
        memory = [[.memory]]

        network {
          mbits = [[.mbits]]
          port  "http"{
          }
        }
      }
    }
  }
}
