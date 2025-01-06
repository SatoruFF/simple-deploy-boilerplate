# simple-deploy-boilerplate

This is a boilerplate for deploying applications using Nginx, Docker Compose, Portainer, Strapi, Vite + React, and GitHub Workflows.

## Features

- **Nginx**: Acts as the primary server and reverse proxies requests to backend and frontend services, consolidating them on a single port.
- **Docker Compose**: Orchestrates the deployment of the backend, frontend, and additional services like Portainer.
- **Portainer**: A web-based interface for managing Docker environments.
- **Strapi**: A powerful backend CMS for managing content.
- **Vite + React**: A modern frontend build system for fast and efficient development.
- **GitHub Workflows**: Automates the deployment process via CI/CD pipelines.

---

## How to Set Up and Deploy

### Step 1: Clone the Repository

Clone this repository to your remote server:

```bash
git clone https://github.com/your-repository-name.git
cd simple-deploy-boilerplate
```

### Step 2: Set Up Secrets in GitHub

Navigate to Settings > Secrets and Variables > Actions.
Add the following secrets:
SERVER_IP: The IP address of your server.
SERVER_PASSWORD: The password for your server's root user.
SERVER_USER: The username (e.g., root).
DOMAIN_NAME: The domain name (e.g., example.com).

### Step 3: Create and Configure the Database && install all requiered programs in remote server
Before deploying, create a PostgreSQL database on your Linux server

```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo -u postgres psql
CREATE DATABASE your_database_name;
CREATE USER your_user_name WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE your_database_name TO your_user_name;
```

install all requiered programs in remote server
```bash
./setup.sh
```

### Step 4: Obtain SSL Certificates with Certbot
Install Certbot and generate SSL certificates for your domain:

```bash
sudo apt update
sudo apt install certbot python3-certbot-nginx
```

Run Certbot to generate certificates:
```bash
sudo certbot --nginx -d your-domain.com -d www.your-domain.com
```

Verify certificate renewal: Certbot automatically sets up renewal, but you can test it:
```bash
sudo certbot renew --dry-run
```

### Step 5: Configure Environment Variables
On your server, create a .env file in the root of the project directory with the following variables:

```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=your_database_name
DB_USER=your_user_name
DB_PASSWORD=your_password

FRONTEND_URL=https://your-domain.com
BACKEND_URL=https://your-domain.com/core
```

### Step 6: Update Backend Configuration
Modify the backend/config/server.ts file in the backend directory. Add the following line to the configuration object:

```
url: 'https://your-domain.com/core',
```

### Step 7: Update Frontend API Endpoint
Ensure the frontend sends requests to the backend at:

```
const base_url = 'https://your-domain.com/core',
```

### Step 8: Deploy via GitHub Actions
After configuring the project, commit your changes and push with a tag to trigger deployment:

```
git add .
git commit -m "Initial deployment setup"
git tag -a v1.0.0 -m "Deployment v1.0.0"
git push origin main --tags
```

## Additional Notes
Nginx Reverse Proxy: Nginx routes requests to the backend, frontend, and Portainer, consolidating them through a single exposed port.
Portainer Access: You can access Portainer at https://your-domain.com/portainer.
