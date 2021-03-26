FROM ruby:2.5.3-alpine3.8

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/main && \
    apk update && apk upgrade && \
    apk add build-base bash dcron libcap && \
    apk upgrade --available && \
    rm -rf /var/cache/apk/* && \
    mkdir /usr/app && \
    setcap cap_setgid=ep /bin/busybox && \
    setcap cap_setgid=ep /usr/sbin/crond


COPY robo-do/. /robo-do
WORKDIR /robo-do
RUN rm -f Gemfile.lock

RUN bundle install


RUN bundle exec whenever -c && bundle exec whenever --update-crontab
# && touch ./log/cron.log
ENTRYPOINT ["/robo-do/startup.sh"]
#CMD crond -f -d

CMD "sh"
#&& tail -f ./log/cron.log

