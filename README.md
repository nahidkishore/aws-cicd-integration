# AWS CI/CD Pipeline: Flask Application on EC2

This repository contains a production-ready CI/CD implementation for a Python Flask application using **AWS CodePipeline**, **CodeBuild**, and **CodeDeploy**.

The pipeline automates the entire lifecycle:

1.  **Continuous Integration (CI):** Triggered on GitHub push, builds a Docker image, and pushes to DockerHub.
2.  **Continuous Deployment (CD):** Automatically deploys the latest container to an AWS EC2 instance.

## 🏗 Architecture Overview

- **Source:** GitHub (v2 Connection)
- **Build/Test:** AWS CodeBuild (Managed Linux Environment)
- **Registry:** Docker Hub (Secured via AWS SSM Parameter Store)
- **Deployment:** AWS CodeDeploy (In-place deployment to EC2)
- **Compute:** Amazon EC2 (Ubuntu 22.04) running Docker

---

## 📁 Files in This Repository

| File               | Purpose                                                |
| ------------------ | ------------------------------------------------------ |
| `app.py`           | Flask application with health check endpoint.          |
| `requirements.txt` | Pinned dependencies for reproducible builds.           |
| `Dockerfile`       | Containerization logic.                                |
| `buildspec.yml`    | CodeBuild instructions for building, testing & pushing |
| `appspec.yml`      | CodeDeploy configuration for the EC2 deployment.       |
| `scripts/`         | Deployment automation (Agent setup, start/stop logic). |

---

## ⚙️ How It Works (CI Flow)

1. **Push to GitHub** → triggers AWS CodePipeline
2. **CodePipeline** → starts a **CodeBuild** project
3. **CodeBuild**:
   - Installs Python dependencies
   - Builds and tags the Docker image
   - Authenticates to DockerHub using SSM credentials
   - Pushes the image to DockerHub

## 🚀 How It Works (CD Flow)

1. **CodeDeploy Trigger** → Starts after a successful Build stage.
2. **ApplicationStop** → Runs `scripts/stop_container.sh` to clean up old containers.
3. **AfterInstall** → Runs `scripts/start_container.sh` to pull the latest image and run it.
4. **Verification** → The app is accessible on port 80 (mapped to container port 5000).

---

## 🛠 AWS Configuration Steps

### 1. Secrets Management (SSM)

Store Docker Hub credentials in **Systems Manager > Parameter Store** as `SecureString`:

- `/nahid-app/docker-credentials/username`
- `/nahid-app/docker-credentials/password`

### 2. EC2 Instance Setup

1.  Launch Ubuntu 22.04.
2.  Attach an **IAM Instance Profile** with:
    - `AmazonS3ReadOnlyAccess`
    - `CloudWatchAgentServerPolicy`
3.  Run the setup script:
    ```bash
    chmod +x scripts/install_agent.sh
    ./scripts/install_agent.sh
    ```
4.  Install Docker: `sudo apt install docker.io -y`.

### 3. CodeBuild & CodeDeploy

- **CodeBuild:** Enable **Privileged Mode** to build Docker images. Add `AmazonSSMReadOnlyAccess` to the service role.
- **CodeDeploy:** Create an Application and Deployment Group targeting your EC2 tags.

---

## 💡 Industry Best Practices Implemented

- **IMDSv2:** Secure metadata retrieval for agent installation.
- **Least Privilege:** Using SSM for secrets instead of environment variables.
- **Health Checks:** Added `/health` endpoint for future Load Balancer integration.
- **Docker Hygiene:** `.dockerignore` prevents bloating the image with `.git` and `__pycache__`.
- **Idempotent Scripts:** Deployment scripts handle "container not found" errors gracefully.
