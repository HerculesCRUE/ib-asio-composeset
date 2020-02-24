#!/bin/bash
docker container prune --filter "until=1h" -f
docker run simulator-importer-researcher-init:1.0