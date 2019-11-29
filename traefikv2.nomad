job "traefik" {
  region      = "global"
  datacenters = ["dc1"]

  #type        = "service"
  type = "system"

  group "traefik" {
    count = 1

    task "traefik" {
      driver = "docker"

      config {
        image        = "traefik:v2.1.0-rc2"
        dns_servers  = ["${attr.unique.network.ip-address}"]
        network_mode = "host"

        volumes = [
          "local/traefik.toml:/etc/traefik/traefik.toml",
        ]
      }

      template {
        data = <<EOF
[global]
  checkNewVersion = false
  sendAnonymousUsage = false

[entryPoints]
  [entryPoints.web]
    address = ":9091"

  [entryPoints.websecure]
    address = ":4443"

[log]
  level = "INFO"
[api]
  dashboard = true
  insecure = true
[providers.consulCatalog]
  refreshInterval = "15s"
  [providers.consulCatalog.endpoint]
    address = "http://127.0.0.1:8500"  # This can become http://consul.service.consul
EOF

        destination = "local/traefik.toml"
      }

      resources {
        cpu    = 100
        memory = 128

        network {
          mbits = 10

          port "webui" {
            static = 8080
          }

          port "apigateway" {
            static = 9091
          }

          port "secureapigateway" {
            static = 4443
          }
        }
      }

      service {
        name = "traefik"

        check {
          name     = "alive"
          type     = "tcp"
          port     = "webui"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
