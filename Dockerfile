FROM debian:trixie-slim

ARG bw_version=2024.2.1

RUN apt-get update \
    && apt-get install --no-install-recommends -y unzip curl ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && curl -Lv https://github.com/bitwarden/clients/releases/download/cli-v${bw_version}/bw-linux-${bw_version}.zip \
        > bw.zip \
    && ls -lah \
    && unzip bw.zip \
    && mv bw /usr/local/bin/bw \
    && rm bw.zip

COPY entrypoint /usr/local/bin/entrypoint
COPY sbw /usr/local/bin/sbw

RUN chmod +x /usr/local/bin/bw \
    && chmod +x /usr/local/bin/sbw \
    && chmod +x /usr/local/bin/entrypoint \
    && groupadd -g 1000 bitwarden \
    && useradd -m -u 1000 -g bitwarden -s /bin/sh bitwarden

USER bitwarden
ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD ["/usr/local/bin/bw", "--help"]
