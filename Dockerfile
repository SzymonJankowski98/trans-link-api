FROM ruby:3.2.1

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY /config/master.key /app/config/master.key

RUN bundle install

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]