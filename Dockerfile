FROM alpine:latest

LABEL "repository"="https://github.com/ttionya/Repository-Sync-Hub" \
  "homepage"="https://github.com/ttionya/Repository-Sync-Hub" \
  "maintainer"="ttionya <git@ttionya.com>"

COPY *.sh /app/

RUN chmod +x /app/*.sh \
  && apk add --no-cache bash git openssh-client

ENTRYPOINT ["/app/entrypoint.sh"]
