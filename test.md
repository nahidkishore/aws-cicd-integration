# Python Flask App with CI on AWS (CodePipeline + CodeBuild)

This repository contains a simple Python Flask application that demonstrates how to implement **Continuous Integration (CI)** using **GitHub**, **AWS CodeBuild**, and **AWS CodePipeline**.

On each push to the repository, the AWS pipeline will:

✅ Install dependencies  
✅ Build a Docker image  
✅ Push the image to DockerHub  

---

## 📁 Files in This Repository

| File              | Purpose                                                   |
|-------------------|-----------------------------------------------------------|
| `app.py`          | A minimal Flask application                               |
| `requirements.txt`| Lists Python dependencies                                 |
| `Dockerfile`      | Defines how to containerize the app                       |
| `buildspec.yml`   | CodeBuild instructions for building, testing & pushing    |

---

## ⚙️ How It Works (CI Flow)

1. **Push to GitHub** → triggers AWS CodePipeline  
2. **CodePipeline** → starts a **CodeBuild** project  
3. **CodeBuild**:
   - Installs Python dependencies
   - Builds and tags the Docker image
   - Authenticates to DockerHub using SSM credentials
   - Pushes the image to DockerHub

---

## AWS Configuration Steps (Summary)

> Full guide: [Medium Tutorial Link]() 

1. **CodeBuild Project**  
   - Use `buildspec.yml`  
   - Environment image: `aws/codebuild/standard:5.0`  
   - Runtime: Python 3.11  
   - Enable Docker (privileged mode)  

2. **Secrets in AWS SSM Parameter Store**  
   - `/myapp/docker-credentials/username`  
   - `/myapp/docker-credentials/password`  

3. **IAM Role Permissions**  
   - Add `AmazonSSMFullAccess` to CodeBuild role  
   - Add `codestar-connections:UseConnection` permission for GitHub integration

4. **CodePipeline Setup**  
   - Source: GitHub  
   - Build: Link to the CodeBuild project  
   - (Skip deploy stage if you're only setting up CI)


 
