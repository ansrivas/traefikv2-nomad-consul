job "demo-webapp-without-prefix" {
  datacenters = ["dc1"]

  group "demo" {
    count = 3

    task "server" {
      driver = "docker"

      config {
        image = "ansrivas/url-echo-service:1.0.0"

        port_map {
          http = 8888
        }
      }

      resources {
        network {
          mbits = 10
          port  "http"{}
        }
      }

      service {
        name = "demo-webapp-without-prefix"
        port = "http"

        tags = [
          "demo-webapp-without-prefix",
          "traefik.http.routers.demo-webapp-without-prefix.rule=PathPrefix(`/demo-web-app/no/prefix/strip`)",
        ]

        check {
          type     = "http"
          path     = "/"
          interval = "2s"
          timeout  = "2s"
        }
      }
    }
  }
}
