FROM fedora:26

# Install docker
RUN dnf -y update && \
    curl -fsSL https://test.docker.com | /bin/sh && \
    dnf clean all

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

COPY ./make-images.sh /make-images.sh

# Define additional metadata for our image.
VOLUME /var/lib/docker
CMD ["wrapdocker"]
