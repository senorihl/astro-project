# OpenCode Agent Instructions

## Docker Compose Requirement (Crucial)
- **ALL commands MUST be run through Docker Compose.** Do not use local node, yarn, or astro CLIs directly.
- Run commands inside the dev container using: `docker compose exec app <command>`
  - *Add dependencies:* `docker compose exec app yarn add <package>`
  - *Run Astro CLI:* `docker compose exec app yarn astro add <integration>`
- The dev environment is started via `docker compose up -d`. The Astro dev server runs on port `4321`.
- The source code is mounted into the container at `/usr/src/app`, so host changes sync automatically.

## Database & Drizzle ORM
- Drizzle migrations run automatically on container startup if `drizzle-kit` is in `package.json` AND a `drizzle.config.*` file exists in the project root.
- **PostgreSQL is the default** via `.env.dist` and `compose.yaml`.
- When switching databases (e.g., to MySQL or SQLite), update `compose.yaml` to include the new service (or a named volume for SQLite) and update the `DATABASE_URL` in `.env.dist`.
  - For example, Postgres uses: `postgresql://${POSTGRES_USER:-app}:${POSTGRES_PASSWORD:-!ChangeMe!}@db:5432/${POSTGRES_DB:-app}?serverVersion=${POSTGRES_VERSION:-15}&charset=${POSTGRES_CHARSET:-utf8}`
- Always install database drivers and Drizzle via Docker Compose, e.g.: `docker compose exec app yarn add drizzle-orm pg` and `docker compose exec app yarn add -D drizzle-kit @types/pg`.

## Project Constraints
- The production environment is already fully configured via `compose.prod.yaml` and `Dockerfile` multi-stage builds. Do not modify production infrastructure, deployment configs, or reverse proxies.
- Tailwind CSS is preconfigured via a Vite plugin in `astro.config.mjs`.

## Documentation
Consult these Astro guides before working on related tasks:

- [Adding pages, dynamic routes, or middleware](https://docs.astro.build/en/guides/routing/)
- [Working with Astro components](https://docs.astro.build/en/basics/astro-components/)
- [Using React, Vue, Svelte, or other framework components](https://docs.astro.build/en/guides/framework-components/)
- [Adding or managing content](https://docs.astro.build/en/guides/content-collections/)
- [Adding styles or using Tailwind](https://docs.astro.build/en/guides/styling/)
- [Supporting multiple languages](https://docs.astro.build/en/guides/internationalization/)
