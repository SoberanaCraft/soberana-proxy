# Configuração inicial
FROM eclipse-temurin:17

LABEL org.opencontainers.image.source="https://github.com/roridev/soberana-proxy.git"
LABEL org.opencontainers.image.description="Imagem docker do proxy do servidor de minecraft da soberana"
LABEL org.opencontainers.image.licenses="CC0"

ENV MIN_RAM=512M
ENV MAX_RAM=512M

ARG VELOCITY_BASE_URL=https://api.papermc.io/v2/projects/velocity/versions
ARG VELOCITY_VERSION=3.1.2-SNAPSHOT
ARG VELOCITY_BUILD=184

ARG VELOCITY_URL=${VELOCITY_BASE_URL}/${VELOCITY_VERSION}/builds/${VELOCITY_BUILD}/downloads/velocity-${VELOCITY_VERSION}-${VELOCITY_BUILD}.jar

# Pasta do proxy
WORKDIR /opt/proxy

# Baixa o velocity
RUN curl -LJo velocity.jar ${VELOCITY_URL}

COPY config/ plugins/

WORKDIR /opt/proxy/plugins

# Baixa o geyser
RUN curl -LJo Geyser-Velocity.jar https://ci.opencollab.dev//job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/velocity/build/libs/Geyser-Velocity.jar

# Baixa o raknetify
RUN curl -LJo raknetify.jar https://cdn.modrinth.com/data/5IovSY3u/versions/ZNFdiiRd/raknetify-velocity-0.1.0%2Balpha.5.15-all.jar

WORKDIR /opt/proxy
# Permanencia de dados
VOLUME [ "/opt/proxy" ]

ARG CACHEBUST=1

COPY velocity.toml .
COPY start.sh .

CMD /opt/proxy/start.sh ${MIN_RAM} ${MAX_RAM}

# Expõe a porta padrão do java edition (25565)
EXPOSE 25565/tcp

# Expõe a porta do raknetify
EXPOSE 25565/udp


# Expõe a porta padrão do bedrock edition (19132)
EXPOSE 19132/udp

# Expõe a porta do Simple Voice Mod
EXPOSE 24454/udp
