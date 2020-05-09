FROM sorah/ruby:2.7-dev as builder

RUN apt-get update \
    && apt-get install -y libffi-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY Gemfile /app/
COPY Gemfile.lock /app/

RUN bundle install --path /gems --jobs 100 --deployment --without development

FROM sorah/ruby:2.7

RUN apt-get update \
    && apt-get install -y libffi7 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /gems /gems
COPY --from=builder /app/.bundle /app/.bundle
COPY . /app/

CMD ["bundle", "exec", "fluentd", "-c", "/etc/fluent/fluent.conf"]
