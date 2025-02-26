FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV HOME=/root

RUN apt-get update && apt-get install -y \
    curl \
    vim \
    unzip \
    bash \
    rsyslog \
    telnet \
    pv \
    ncdu \
    jq \
    iptables \
    openssh-server \
    openssh-client \
    ca-certificates \
    && apt-get clean

RUN rm -rf /var/lib/apt/lists/*

# Install Consul
ENV CONSUL_VERSION=1.18.0
RUN curl -fsSL https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip -o consul.zip \
    && unzip consul.zip -d /usr/local/bin \
    && rm consul.zip

# Set the Consul data directory
RUN mkdir -p /consul/data /consul/config

# Expose ports for Consul server
EXPOSE 8500 8600/udp

# Copy entrypoint script (will need to create this script)
COPY entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Set the entrypoint and default command
ENTRYPOINT ["/entrypoint.sh"]
CMD ["consul", "agent", "-server", "-ui", "-data-dir=/consul/data", "-config-dir=/consul/config"]

# Set default Consul environment variables
ENV CONSUL_BIND_INTERFACE=eth0
ENV CONSUL_BOOTSTRAP_EXPECT=3
