# AniVerse Development Guide

## 🚀 Quick Start

### Prerequisites

- **Node.js** (v18 or higher)
- **Python** (v3.11 or higher)
- **Docker** and **Docker Compose**
- **Git**

### Development Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd AniVerse
   ```

2. **Start with Docker (Recommended)**
   ```bash
   # Start all services (database, backend, frontend, monitoring)
   docker-compose up -d
   
   # View logs
   docker-compose logs -f
   
   # Stop services
   docker-compose down
   ```

3. **Manual Setup (Alternative)**

   **Backend Setup:**
   ```bash
   cd backend
   
   # Create virtual environment
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   
   # Install dependencies
   pip install -r requirements.txt
   
   # Copy environment file
   cp .env.example .env
   # Edit .env with your database configuration
   
   # Run database migrations (when ready)
   # alembic upgrade head
   
   # Start the API server
   uvicorn main:app --reload
   ```

   **Frontend Setup:**
   ```bash
   cd frontend
   
   # Install dependencies
   npm install
   
   # Start development server
   npm run dev
   ```

## 🔧 Development Workflow

### Project Structure
```
AniVerse/
├── backend/              # FastAPI backend
│   ├── app/
│   │   ├── api/         # API routes
│   │   ├── core/        # Core configurations
│   │   ├── models/      # Database models
│   │   ├── schemas/     # Pydantic schemas
│   │   ├── services/    # Business logic
│   │   └── db/          # Database utilities
│   ├── main.py          # FastAPI app entry point
│   └── requirements.txt
├── frontend/            # Next.js frontend
│   ├── src/
│   │   ├── app/         # App router pages
│   │   ├── components/  # React components
│   │   ├── lib/         # Utilities and API clients
│   │   ├── types/       # TypeScript type definitions
│   │   └── providers/   # React context providers
│   └── package.json
├── infrastructure/      # AWS CloudFormation/Terraform
├── monitoring/         # Prometheus/Grafana configs
└── docker-compose.yml  # Development environment
```

### Available Services

When running `docker-compose up`, the following services are available:

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
  - API Docs: http://localhost:8000/docs
  - Health Check: http://localhost:8000/health
  - Metrics: http://localhost:8000/metrics
- **MySQL**: localhost:3306
- **Redis**: localhost:6379
- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3001 (admin/admin)

## 🎯 Current Implementation Status

### ✅ Completed Features

1. **Project Structure**: Complete folder organization with Git setup
2. **Backend Foundation**:
   - FastAPI application with proper structure
   - SQLAlchemy models for all database entities
   - Pydantic schemas for API validation
   - JWT authentication system
   - Prometheus metrics integration
   - CORS and security middleware

3. **Frontend Foundation**:
   - Next.js 15 with TypeScript and Tailwind CSS
   - React Query for API state management
   - Authentication context and providers
   - Responsive navigation and layout components
   - Homepage with hero section and content grid

4. **Development Infrastructure**:
   - Docker Compose setup for full development environment
   - Prometheus and Grafana monitoring stack
   - Health checks and service dependencies

### 🚧 In Progress

1. **Authentication System**: Backend complete, frontend components needed
2. **Anime Catalog**: API endpoints and infinite scroll components
3. **Admin Panel**: Dashboard and content management system
4. **AWS Infrastructure**: CloudFormation templates and Lambda functions

### 📋 Next Steps

1. **Complete Authentication Frontend**:
   - Login/signup pages
   - Protected route components
   - User profile management

2. **Build Anime Catalog**:
   - API endpoints for CRUD operations
   - Search and filtering functionality
   - Infinite scroll implementation
   - Video player integration with Video.js

3. **Admin Panel**:
   - Statistics dashboard
   - Content management interface
   - File upload with AWS S3 integration

4. **AWS Infrastructure**:
   - S3 buckets for media storage
   - CloudFront CDN configuration
   - Lambda functions for video processing
   - MediaConvert integration

## 🧪 Testing

### Backend Testing
```bash
cd backend
pytest tests/
```

### Frontend Testing
```bash
cd frontend
npm test
```

## 📦 Database Schema

The application uses the following main entities:

- **Users**: User accounts with authentication
- **Animes**: Anime series metadata
- **Episodes**: Individual episode information with HLS URLs
- **Genres**: Anime categorization
- **User Watchlist**: User's saved anime list
- **Watch Progress**: Viewing progress tracking

## 🔒 Environment Variables

### Backend (.env)
```
# Database
DATABASE_URL=mysql+pymysql://username:password@localhost:3306/aniverse

# JWT
SECRET_KEY=your-secret-key-here
ACCESS_TOKEN_EXPIRE_MINUTES=30

# AWS
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_REGION=us-east-1
AWS_S3_BUCKET_RAW=aniverse-raw-uploads
AWS_S3_BUCKET_PROCESSED=aniverse-processed-media
```

### Frontend (.env.local)
```
NEXT_PUBLIC_API_URL=http://localhost:8000
```

## 🐛 Troubleshooting

### Common Issues

1. **Database Connection Errors**:
   - Ensure MySQL is running
   - Check database credentials in `.env`
   - Verify database exists

2. **Port Conflicts**:
   - Stop other services using ports 3000, 8000, 3306
   - Or modify ports in `docker-compose.yml`

3. **CORS Issues**:
   - Verify CORS_ORIGINS in backend configuration
   - Check API URL in frontend environment variables

### Logs
```bash
# View all service logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f mysql
```

## 🚀 Deployment

### Production Considerations

1. **Security**:
   - Use strong secrets for JWT and database passwords
   - Enable HTTPS with proper SSL certificates
   - Configure proper CORS origins

2. **Performance**:
   - Use CDN for static assets
   - Implement proper caching strategies
   - Optimize database queries with indexing

3. **Monitoring**:
   - Set up alerting in Grafana
   - Configure log aggregation
   - Monitor resource usage and performance metrics

## 📖 API Documentation

Once the backend is running, visit http://localhost:8000/docs for interactive API documentation with Swagger UI.

## 🤝 Contributing

1. Create a feature branch from `main`
2. Make your changes
3. Test thoroughly
4. Submit a pull request

---

Happy coding! 🎌✨
