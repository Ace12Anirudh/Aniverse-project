# 🎌 AniVerse Quick Start Guide

Get your anime streaming platform up and running in minutes!

## 🚀 Option 1: Automatic Setup (Recommended)

**For Windows users, use the automated setup script:**

1. **Open PowerShell as Administrator** in the project directory
2. **Run the setup script:**
   ```powershell
   .\setup-dev.ps1
   ```
3. **Wait for completion** (~5-10 minutes)
4. **Visit your app:** http://localhost:3000

**That's it!** Your development environment is ready. ✨

---

## 🛠️ Option 2: Manual Setup

### Prerequisites
- Docker Desktop
- Node.js (v18+)
- Python (v3.11+)
- Git

### Step 1: Environment Configuration

**Backend:**
```powershell
cd backend
cp .env.example .env
# Edit .env with your configurations
```

**Frontend:**
```powershell
cd frontend
# Create .env.local
echo "NEXT_PUBLIC_API_URL=http://localhost:8000" > .env.local
```

### Step 2: Start Services

```powershell
# Start all services with Docker
docker-compose up -d

# View logs
docker-compose logs -f
```

### Step 3: Access Your App

- **Frontend:** http://localhost:3000
- **Backend API:** http://localhost:8000/docs
- **Monitoring:** http://localhost:3001 (Grafana)

---

## ☁️ AWS Infrastructure Setup

### Quick AWS Deployment

1. **Configure AWS CLI:**
   ```powershell
   aws configure
   ```

2. **Deploy infrastructure:**
   ```powershell
   cd infrastructure
   .\deploy.ps1 -Environment dev
   ```

3. **Wait for completion** (~15 minutes)

4. **Update environment variables** with the output values

---

## 🎯 Default Credentials

### Application Login
- **Admin:** `admin` / `admin123`
- **Demo User:** `demo_user` / `admin123`

### Monitoring
- **Grafana:** `admin` / `admin`

---

## 🌐 Available Services

| Service | URL | Purpose |
|---------|-----|---------|
| Frontend | http://localhost:3000 | Main application |
| Backend API | http://localhost:8000 | REST API |
| API Docs | http://localhost:8000/docs | Swagger documentation |
| Health Check | http://localhost:8000/health | Service status |
| Prometheus | http://localhost:9090 | Metrics collection |
| Grafana | http://localhost:3001 | Monitoring dashboards |
| Database | localhost:3306 | MySQL database |

---

## 🔧 Common Commands

### Development
```powershell
# Start development environment
docker-compose up -d

# View all logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f backend
docker-compose logs -f frontend

# Restart services
docker-compose restart

# Stop services
docker-compose down

# Reset all data
docker-compose down -v
docker-compose up -d
```

### AWS Management
```powershell
# Deploy AWS infrastructure
cd infrastructure
.\deploy.ps1 -Environment dev

# Update existing infrastructure
.\deploy.ps1 -Environment dev -Update

# Delete AWS infrastructure
.\deploy.ps1 -Environment dev -Delete
```

---

## 🚨 Troubleshooting

### Port Already in Use
```powershell
# Find process using port 3000
netstat -ano | findstr :3000

# Kill the process
taskkill /PID <PID> /F
```

### Docker Issues
```powershell
# Restart Docker Desktop
# Then reset Docker
docker system prune -a
```

### Database Issues
```powershell
# Reset database
docker-compose down -v
docker-compose up -d mysql
# Wait for MySQL to be ready, then start other services
docker-compose up -d
```

### AWS Issues
```powershell
# Check AWS credentials
aws sts get-caller-identity

# Check CloudFormation stack status
aws cloudformation describe-stacks --stack-name aniverse-dev
```

---

## 📊 Project Structure

```
AniVerse/
├── backend/              # FastAPI backend
├── frontend/             # Next.js frontend  
├── infrastructure/       # AWS CloudFormation
├── monitoring/          # Prometheus/Grafana
├── docker-compose.yml   # Development environment
├── setup-dev.ps1       # Automated setup script
└── QUICK-START.md      # This file
```

---

## 🎯 Development Workflow

### 1. Local Development
```powershell
# Start development environment
.\setup-dev.ps1

# Make your changes
# Services auto-reload on code changes

# Test your changes
# Visit http://localhost:3000
```

### 2. AWS Testing
```powershell
# Deploy to AWS
cd infrastructure
.\deploy.ps1 -Environment dev

# Test video upload and processing
# Monitor in AWS Console
```

### 3. Production Deployment
```powershell
# Deploy production stack
.\deploy.ps1 -Environment prod -DomainName "your-domain.com"
```

---

## 🎉 What's Included

### ✅ Complete Features Ready
- **🏗️ Full Project Structure** with professional organization
- **🐳 Docker Development Environment** with all services
- **🔒 JWT Authentication System** with secure token management
- **📊 Database Schema** with sample data (anime, users, episodes)
- **🎨 Modern UI** with Next.js, TypeScript, and Tailwind CSS
- **📈 Monitoring Stack** with Prometheus and Grafana
- **☁️ AWS Infrastructure** with automated deployment
- **🎬 Video Processing Pipeline** with MediaConvert and HLS streaming
- **📡 CDN Delivery** with CloudFront global distribution

### 🚧 Ready for Development
- **Login/Signup Pages** (templates ready)
- **Admin Panel** (architecture in place) 
- **Video Player Integration** (Video.js configured)
- **Infinite Scroll Catalog** (components structured)
- **Search and Filtering** (API endpoints defined)

---

## 🔗 Important Links

### Documentation
- [Complete Setup Guide](SETUP.md) - Detailed instructions
- [Development Guide](DEVELOPMENT.md) - Development workflow
- [API Documentation](http://localhost:8000/docs) - Interactive API docs

### Monitoring & Management
- [Grafana Dashboards](http://localhost:3001)
- [Prometheus Metrics](http://localhost:9090)
- [AWS Console](https://console.aws.amazon.com/)
- [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/)

### Development Resources
- [FastAPI Docs](https://fastapi.tiangolo.com/)
- [Next.js Docs](https://nextjs.org/docs)
- [AWS MediaConvert](https://docs.aws.amazon.com/mediaconvert/)
- [Video.js Docs](https://docs.videojs.com/)

---

## 🎌 You're All Set!

Your AniVerse anime streaming platform is now ready for development! 

**Next Steps:**
1. 🎨 Customize the UI to match your vision
2. 🔐 Implement authentication pages  
3. 📺 Add video player functionality
4. 🎬 Set up video upload and processing
5. 🚀 Deploy to production

**Need Help?**
- Check the troubleshooting section above
- Review the detailed documentation
- Look at the code examples and comments

**Happy streaming! 🎬✨**
