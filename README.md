1. Launch `nomad agent -dev`
2. Launch `consul agent -dev`
3. Launch `traefik --config=./traefik.toml`
4. Run `nomad job plan go-deploy.nomad`
5. This should register the application in consul and hence traefik will create a route for this
6. Run `curl -i http://localhost:9091/production/rec/go-deploy/blah
