🚀 DevOps Lab 1 – Automated Web Application Deployment Pipeline

 📌 Overview

This project demonstrates an end-to-end **DevOps CI/CD pipeline** using modern tools and best practices. The pipeline automates application build, containerization, and deployment to an AWS EC2 instance using GitHub Actions.

The main goal of this lab is to showcase hands-on experience with **Docker**, **GitHub Actions**, and **AWS EC2**, suitable for a DevOps / Cloud Engineering portfolio.

---

🛠️ Tech Stack

* **Version Control**: Git & GitHub
* **CI/CD**: GitHub Actions
* **Containerization**: Docker
* **Cloud Provider**: AWS EC2
* **Infrastructure as Code**: Terraform
* **OS**: Linux (Ubuntu on EC2)

---

📂 Project Structure

```
.devops-lab1/
├── .github/            # GitHub Actions workflows
├── app/                # Application source code
├── scripts/            # Automation & helper scripts
├── terraform/          # Terraform IaC files
├── workflows/          # CI/CD workflow definitions
├── Dockerfile          # Docker image definition
├── README.md           # Project documentation

---

## 🔄 CI/CD Workflow

The CI/CD pipeline is triggered automatically on **push to the main branch**.

Pipeline Steps:

1. **Checkout source code** from GitHub
2. **Build Docker image**
3. **Run container** for validation
4. **Deploy container** to AWS EC2

GitHub Actions ensures consistent and repeatable deployments with minimal manual intervention.

---

🐳 Docker

Docker is used to containerize the application to ensure:

* Environment consistency
* Easy deployment
* Scalability

Build Image

```bash
docker build -t devops-lab1 .
```

Run Container

```bash
docker run -d -p 80:80 devops-lab1
```

---

☁️ AWS EC2 Deployment

* EC2 instance acts as the deployment target
* Docker is installed on EC2
* Application runs inside a Docker container

Screenshots of:

* EC2 instance
* Running container
* Website access
  are included in this repository.

---

🧱 Infrastructure as Code (Terraform)

Terraform is used to provision AWS resources such as:

* EC2 instance
* Security groups

This ensures infrastructure is:

* Reproducible
* Version-controlled
* Easy to manage

---

📸 Evidence & Screenshots

The following screenshots are included for verification:

* ✅ GitHub Actions successful run
* ✅ Docker container running
* ✅ AWS EC2 instance
* ✅ Website accessible via public IP

---

🎯 Learning Outcomes

Through this project, I gained hands-on experience with:

* Building CI/CD pipelines
* Containerizing applications
* Deploying to cloud infrastructure
* Using Terraform for IaC
* Automating DevOps workflows

---

📄 Full Documentation

📘 A detailed step-by-step guide is available here:
[README.pdf](README.pdf)

---

👤 Author
Muhammad Hazran Hafiz Ahmad
GitHub:
@kaelcloud
LinkedIn:
Muhammad Hazran Hafiz Ahmad
Project Repository:
devops-lab1