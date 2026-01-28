# AniVerse - Anime Streaming Platform

A scalable, high-performance anime streaming platform with full DevOps monitoring stack.

## 🎯 Features

### User-Facing App
- **Authentication**: JWT-based Sign Up, Login, Logout
- **Homepage**: Featured, New Releases, and Popular sections
- **Catalog**: Infinite scroll with search and filtering by genre/name
- **Anime Details**: Synopsis, episodes, cover art, and related info
- **Video Streaming**: High-performance HLS streaming via AWS CloudFront
- **User Management**: Profile and Watchlist functionality
- **Continue Watching**: Advanced tracking system

### Admin Panel
- **Secure Admin Access**: Protected admin login
- **Dashboard**: Site statistics from Prometheus/CloudWatch
- **Content Management**: Upload anime series, episodes, manage genres/users
- **Media Processing**: Direct S3 upload with automated video transcoding

## 🚀 Technology Stack

- **Frontend**: Next.js (React) + TypeScript + Tailwind CSS
- **Video Player**: Video.js with HLS support
- **Backend**: Python FastAPI + Uvicorn
- **Database**: MySQL on AWS RDS
- **Infrastructure**: AWS EC2, S3, CloudFront, Lambda, MediaConvert
- **Monitoring**: CloudWatch + Prometheus + Grafana

## 📁 Project Structure

```
AniVerse/
├── backend/              # FastAPI backend
├── frontend/             # Next.js frontend
├── infrastructure/       # AWS CloudFormation/Terraform
├── monitoring/          # Prometheus/Grafana configs
├── docker-compose.yml   # Local development
└── README.md
```

## 🛠️ Quick Start

1. **Clone and setup**:
   ```bash
   git clone <repo>
   cd AniVerse
   ```

2. **Backend setup**:
   ```bash
   cd backend
   pip install -r requirements.txt
   uvicorn main:app --reload
   ```

3. **Frontend setup**:
   ```bash
   cd frontend
   npm install
   npm run dev
   ```

4. **Database setup**:
   ```bash
   # Run MySQL migrations
   # Configure environment variables
   ```

## 🏗️ Architecture

The system follows a microservices architecture with clear separation of concerns:

- **CDN Layer**: CloudFront for global content delivery
- **Frontend**: Next.js SSR for optimal performance and SEO
- **API Layer**: FastAPI for high-throughput API endpoints
- **Database**: MySQL RDS for reliable data persistence
- **Media Processing**: Automated video transcoding pipeline
- **Monitoring**: Full observability stack

## 📊 Monitoring

- **Application Metrics**: Prometheus scraping from `/metrics` endpoint
- **Infrastructure Metrics**: CloudWatch for AWS resources
- **Visualization**: Grafana dashboards combining both data sources

## 🔧 Development

- **Local Development**: Docker Compose for full stack
- **Testing**: Pytest for backend, Jest for frontend
- **Code Quality**: ESLint, Black, pre-commit hooks

## 🚢 Deployment

- **Staging**: Automated deployment to staging environment
- **Production**: Blue-green deployment with rollback capabilities
- **Infrastructure**: Infrastructure as Code with CloudFormation/Terraform

---

Built with ❤️ for anime enthusiasts worldwide
