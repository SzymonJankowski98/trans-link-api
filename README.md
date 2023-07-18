# TransLinkApi

### How to set it up:

1. Put `master.key` in `/config`
2. Run containers
```shell
docker build
docker-compose up
```
3. Connect to app container
```shell
docker exec -it trans-link-api-web-1 /bin/sh
```
4. Setup database
```shell
rails db:setup
```

Api docs should be available under: http://localhost:3000/api_docs/

Requests examples: `doc\apipie_examples.json`