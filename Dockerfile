FROM fedora:22

# Install docker
RUN dnf -y update && dnf -y install dnf-plugins-core && \
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo && \
    dnf -y install docker-ce && \
    dnf clean all

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

COPY ./make-images.sh /make-images.sh

# Define additional metadata for our image.
VOLUME /var/lib/docker
CMD ["wrapdocker"]
