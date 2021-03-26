FROM ruby:2.5.1
RUN apt-get update -qq && apt-get install -y postgresql-client rsyslog

COPY robo-brain/. /robo-brain

WORKDIR /robo-brain

# Update bundler
RUN rm -f Gemfile.lock

RUN bundle install

RUN chmod 0744 /robo-brain

EXPOSE 3000

ENTRYPOINT ["/robo-brain/startup.sh"]
#CMD ["/robo-brain/startup.sh"]

CMD ["rails", "server", "-b", "0.0.0.0"]
#CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
