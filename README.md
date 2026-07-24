# Astro Template

A minimal Astro starter template, pre-configured with Tailwind CSS and fully containerized using Docker Compose. 

Everything runs inside Docker. **You do not need Node, NPM, or Yarn installed on your local machine.**

## 📋 Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## 🚀 Getting Started (Development)

1. **Start the development environment:**
   ```bash
   docker compose up -d
   ```
   *The first time you run this, it will take a moment to download the Node image and install dependencies.*

2. **Open the app:**
   Navigate to [http://localhost:4321](http://localhost:4321) in your browser. 
   
   The source code is mounted as a volume, so any changes you make in the `src/` directory will automatically trigger a hot module reload (HMR) in your browser.

3. **Stop the environment:**
   ```bash
   docker compose down
   ```

## 🛠️ Running Commands

Because the project is entirely containerized, **all Yarn or Astro commands must be executed inside the running container.**

You can do this using `docker compose exec app <command>`.

**Examples:**

- **Install a new dependency:**
  ```bash
  docker compose exec app yarn add <package-name>
  ```

- **Run the Astro CLI (e.g., adding an integration):**
  ```bash
  docker compose exec app yarn astro add react
  ```

- **View terminal logs:**
  ```bash
  docker compose logs -f app
  ```

## 🗄️ Database (Drizzle ORM)

The `docker-entrypoint.sh` is pre-configured to automatically run Drizzle migrations (`drizzle-kit migrate` or `push`) when the container starts, provided you have configured it.

To set up a database:

1. **Choose your database:** PostgreSQL is configured by default in `compose.yaml` and `.env.dist`. If you prefer MySQL or SQLite, update your `compose.yaml` and the `DATABASE_URL` in your `.env.dist` file accordingly (see the dashboard at `http://localhost:4321` for exact snippets).
2. **Install dependencies inside the container:**
   - *PostgreSQL:* `docker compose exec app yarn add pg && docker compose exec app yarn add -D @types/pg drizzle-kit drizzle-orm`
   - *MySQL:* `docker compose exec app yarn add mysql2 drizzle-orm && docker compose exec app yarn add -D drizzle-kit`
   - *SQLite:* `docker compose exec app yarn add @libsql/client drizzle-orm && docker compose exec app yarn add -D drizzle-kit`
3. **Configure Drizzle:** Create a `drizzle.config.ts` file in the project root. The entrypoint waits for this file (and `drizzle-kit` in your `package.json`) to exist before attempting to run database syncs automatically on startup.

## 📦 Production

The production environment is configured in `compose.prod.yaml` and uses a multi-stage `Dockerfile` to build a static site served via Nginx.

To build and test the production image locally:
```bash
docker compose -f compose.yaml -f compose.prod.yaml up --build -d
```