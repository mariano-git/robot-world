#!/bin/bash
set -e
sleep 5
rm -f /robo-brain/tmp/pids/server.pid
rails db:create
rails db:migrate
#nohup rails server -b 0.0.0.0
#rails server -b 0.0.0.0

exec "$@"