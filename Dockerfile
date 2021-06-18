# Curl base image
FROM curlimages/curl AS curl_dependency

# Fetch static curl
RUN curl --silent "https://api.github.com/repos/moparisthebest/static-curl/releases" | grep browser_download | cut -d '"' -f 4 | grep amd64 | sort | tail -n 1 | xargs curl --location --output /tmp/curl --silent \
  && chmod +x /tmp/curl

# Base image
FROM gcr.io/kaniko-project/executor:debug

# Install certificates
COPY --from=curl_dependency /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Install curl
COPY --from=curl_dependency /tmp/curl /usr/local/bin/
