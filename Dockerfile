FROM ubuntu:14.04
MAINTAINER Matthew Tardiff <mattrix@gmail.com>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y gawk
COPY src /app
RUN chmod u+x /app/2048.sh
CMD []
ENTRYPOINT ["/app/2048.sh"]
