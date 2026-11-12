# Docker

Copilot CLI, the Book App, its tests and the book-catalog MCP server all run from one image
(`docker/Dockerfile`). The MCP server is started by Copilot CLI over stdio inside the same container.

Run these from the repository root:

```bash
docker compose -f docker/docker-compose.yml run --rm copilot        # Copilot CLI (runs start-copilot.ps1)
docker compose -f docker/docker-compose.yml run --rm app            # Book App (list)
docker compose -f docker/docker-compose.yml run --rm mcp            # MCP server self-test
docker compose -f docker/docker-compose.yml run --rm tests          # pytest
```

Other Book App commands: `... run --rm app book_app.py add`. Add `-GitHubActions` after `copilot`
to enable the GitHub Actions MCP tools for a session.

The repository is mounted at `/workspace`, so changes stay on the host. Named volumes keep Copilot CLI
and GitHub CLI sign-in data between containers; complete sign-in with `/login` when prompted, or set
`GH_TOKEN` in your environment.

Plain `docker` without Compose (from the repository root):

```bash
docker build -f docker/Dockerfile -t copilot-cli-workshop .
docker run --rm -it -v "$PWD:/workspace" \
  -v copilot-cli-state:/home/node/.copilot -v copilot-gh-state:/home/node/.config/gh \
  copilot-cli-workshop
```
