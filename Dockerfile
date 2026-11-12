FROM node:22-bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV WORKSHOP_VENV=/opt/workshop-venv
ENV PATH="/opt/workshop-venv/bin:${PATH}"

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl git python3 python3-venv \
    && curl -fsSL https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb \
        -o /tmp/packages-microsoft-prod.deb \
    && dpkg -i /tmp/packages-microsoft-prod.deb \
    && rm /tmp/packages-microsoft-prod.deb \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends gh powershell \
    && npm install --global @github/copilot \
    && python3 -m venv "$WORKSHOP_VENV" \
    && "$WORKSHOP_VENV/bin/python" -m pip install --no-cache-dir "pytest>=8.0" "mcp>=1.2,<2" \
    && mkdir -p /workspace /home/node/.copilot /home/node/.config/gh \
    && chown -R node:node /workspace /home/node \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
COPY --chown=node:node . /workspace

USER node
ENTRYPOINT ["pwsh", "-NoLogo", "-File", "/workspace/scripts/start-copilot.ps1"]
