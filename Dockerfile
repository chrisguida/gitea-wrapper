FROM gitea/gitea:1.16.9

RUN apk update
RUN apk add --no-cache tini curl

RUN wget https://github.com/mikefarah/yq/releases/download/v4.27.2/yq_linux_arm.tar.gz -O - |\
    tar xz && mv yq_linux_arm /usr/bin/yq

ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh
ADD ./check-web.sh /usr/local/bin/check-web.sh
RUN chmod +x /usr/local/bin/check-web.sh
ADD ./check-user-signups-off.sh /usr/local/bin/check-user-signups-off.sh
RUN chmod +x /usr/local/bin/check-user-signups-off.sh
