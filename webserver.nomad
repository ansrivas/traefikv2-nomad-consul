job "demo-webapp" {
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
        name = "demo-webapp"
        port = "http"

        tags = [
          "demo-webapp",
          "traefik.http.routers.demo-webapp.rule=PathPrefix(`/demo-web-app/this/will/be/stripped`)",
          "traefik.http.routers.demo-webapp.middlewares=demo-webapp@consulcatalog",
          "traefik.http.middlewares.demo-webapp.stripprefix.prefixes=/demo-web-app/this/will/be/stripped",
          "traefik.http.middlewares.demo-webapp.stripprefix.forceslash=false",
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
