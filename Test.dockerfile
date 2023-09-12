FROM ruby:3.2-slim

RUN apt update -y && \
  apt install -y \
    build-essential \
    git

COPY . /app
WORKDIR /app

RUN rm -f Gemfile.lock && bundle install

CMD ["rake", "spec"]
