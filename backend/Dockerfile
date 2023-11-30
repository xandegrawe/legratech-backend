FROM ruby:3.2.2 

RUN apt-get update -qq && apt-get install -y build-essential nodejs npm libpq-dev postgresql-client

RUN npm install -g yarn

RUN mkdir /usr/src/backend

WORKDIR /usr/src/backend

COPY Gemfile Gemfile.lock ./

RUN bundle install

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]