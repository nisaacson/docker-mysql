#!/usr/bin/env bash

docker kill mysql-container || true
docker rm mysql-container || true
