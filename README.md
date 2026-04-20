# tir-x-infra-dev

Infra repo for local development of Tir-X (frontend + backend + postgres) using git submodules and Docker Compose.

## Submodules

This repository includes:

- `tir-x-backend` -> https://github.com/SGGW-computer-science/tir-x-backend.git
- `tir-x-frontend` -> https://github.com/SGGW-computer-science/tir-x-frontend.git

If you clone this repo fresh, initialize submodules with:

```bash
git submodule update --init --recursive
```

Submodules are configured to track `main`, but they are still pinned to exact commits in this repo (Git submodule behavior).
To move both to the newest remote commits:

```bash
make update-submodules
```

## Development stack (Docker)

The development stack is defined in `docker-compose.yml` and uses:

- Backend: .NET 10, `dotnet watch`
- Frontend: Vite React, `npm run dev`
- Database: PostgreSQL 16
- Mail: MailHog (for OTP emails)

Code is mounted into containers so local edits are reflected immediately.

### Run

```bash
docker compose up --build
```

### Stop

```bash
docker compose down
```

## Seed test data

Skrypt seedujący jest dopasowany do aktualnego schematu bazy i znajduje się w `scripts/seed_test_data.sql`.

1. Uruchom stack:

```bash
docker compose up -d
```

2. Zaseeduj bazę:

```bash
./scripts/seed-db.sh
```

alternatywnie:

```bash
make seed-db
```

Uwaga: seed resetuje dane w tabelach domenowych (`TRUNCATE ... RESTART IDENTITY CASCADE`) i wstawia zestaw testowy od zera.

### Services

- Frontend: http://localhost:5173
- Backend: http://localhost:5000
- Postgres: localhost:5432
- MailHog UI: http://localhost:8025
- MailHog SMTP: localhost:1025
