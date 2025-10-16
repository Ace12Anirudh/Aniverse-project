# AniVerse Complete Setup Guide

## 🛠️ Local Development Setup

### Step 1: Environment Preparation

1. **Install Required Software**:
   ```powershell
   # Install Docker Desktop for Windows
   # Download from: https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe
   
   # Install Node.js (v18+)
   # Download from: https://nodejs.org/
   
   # Install Python (v3.11+)
   # Download from: https://www.python.org/downloads/
   
   # Verify installations
   docker --version
   node --version
   python --version
   ```

2. **Clone and Navigate to Project**:
   ```powershell
   git clone <your-repo-url>
   cd AniVerse
   ```

### Step 2: Backend Configuration

1. **Create Backend Environment File**:
   ```powershell
   cd backend
   cp .env.example .env
   ```

2. **Edit `backend/.env`** with your configurations:
   ```env
   # Database Configuration
   DATABASE_URL=mysql+pymysql://aniverse_user:aniverse_password@localhost:3306/aniverse
   DB_HOST=localhost
   DB_PORT=3306
   DB_USER=aniverse_user
   DB_PASSWORD=aniverse_password
   DB_NAME=aniverse

   # JWT Configuration
   SECRET_KEY=your-super-secret-jwt-key-change-this-in-production
   ALGORITHM=HS256
   ACCESS_TOKEN_EXPIRE_MINUTES=30

   # AWS Configuration (will configure later)
   AWS_ACCESS_KEY_ID=your-aws-access-key
   AWS_SECRET_ACCESS_KEY=your-aws-secret-key
   AWS_REGION=us-east-1
   AWS_S3_BUCKET_RAW=aniverse-raw-uploads
   AWS_S3_BUCKET_PROCESSED=aniverse-processed-media
   AWS_CLOUDFRONT_DOMAIN=your-cloudfront-domain.net

   # Application Configuration
   APP_NAME=AniVerse API
   APP_VERSION=1.0.0
   DEBUG=True
   API_V1_PREFIX=/api/v1

   # CORS Configuration
   CORS_ORIGINS=http://localhost:3000

   # Monitoring Configuration
   PROMETHEUS_PORT=8001

   # Media Processing
   MEDIA_CONVERT_ROLE_ARN=arn:aws:iam::your-account:role/MediaConvertRole
   MEDIA_CONVERT_ENDPOINT=https://mediaconvert.us-east-1.amazonaws.com
   ```

### Step 3: Frontend Configuration

1. **Create Frontend Environment File**:
   ```powershell
   cd ../frontend
   New-Item -Path ".env.local" -ItemType File
   ```

2. **Edit `frontend/.env.local`**:
   ```env
   NEXT_PUBLIC_API_URL=http://localhost:8000
   NEXT_PUBLIC_APP_NAME=AniVerse
   NEXT_PUBLIC_AWS_CLOUDFRONT_DOMAIN=your-cloudfront-domain.net
   ```

### Step 4: Database Initialization

1. **Create Database Init Script**:
   ```powershell
   cd ../backend
   New-Item -Path "init.sql" -ItemType File
   ```

2. **Add to `backend/init.sql`**:
   ```sql
   -- Create database if not exists
   CREATE DATABASE IF NOT EXISTS aniverse CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   USE aniverse;

   -- Create admin user
   INSERT INTO users (id, username, email, hashed_password, is_admin) VALUES 
   (UUID(), 'admin', 'admin@aniverse.com', '$2b$12$LQv3c1yqBw.TaJLmG.aB7uBh8P5bG1JzI6vG7Fg9WlKW2X3HzV.Yi', true)
   ON DUPLICATE KEY UPDATE username=username;

   -- Insert sample genres
   INSERT INTO genres (name) VALUES 
   ('Action'), ('Adventure'), ('Comedy'), ('Drama'), ('Fantasy'), 
   ('Horror'), ('Mystery'), ('Romance'), ('Sci-Fi'), ('Slice of Life'),
   ('Sports'), ('Supernatural'), ('Thriller'), ('Historical'), ('Mecha')
   ON DUPLICATE KEY UPDATE name=name;
   ```

### Step 5: Start Development Environment

1. **Using Docker (Recommended)**:
   ```powershell
   cd ..
   docker-compose up -d
   
   # View logs
   docker-compose logs -f
   ```

2. **Manual Setup (Alternative)**:
   
   **Terminal 1 - Database:**
   ```powershell
   # Start MySQL manually or use Docker
   docker run --name aniverse-mysql -e MYSQL_ROOT_PASSWORD=rootpassword -e MYSQL_DATABASE=aniverse -e MYSQL_USER=aniverse_user -e MYSQL_PASSWORD=aniverse_password -p 3306:3306 -d mysql:8.0
   ```

   **Terminal 2 - Backend:**
   ```powershell
   cd backend
   python -m venv venv
   venv\Scripts\activate
   pip install -r requirements.txt
   uvicorn main:app --reload --host 0.0.0.0 --port 8000
   ```

   **Terminal 3 - Frontend:**
   ```powershell
   cd frontend
   npm install
   npm run dev
   ```

### Step 6: Verify Setup

Visit these URLs to verify everything is working:
- **Frontend**: http://localhost:3000
- **Backend API Docs**: http://localhost:8000/docs
- **Backend Health**: http://localhost:8000/health
- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3001 (admin/admin)

---

## ☁️ AWS Infrastructure Setup

### Step 1: AWS Account Preparation

1. **Create AWS Account** and set up billing alerts
2. **Create IAM User** with programmatic access:
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Action": [
           "s3:*",
           "cloudfront:*",
           "mediaconvert:*",
           "lambda:*",
           "iam:PassRole",
           "logs:*",
           "cloudwatch:*"
         ],
         "Resource": "*"
       }
     ]
   }
   ```

3. **Install AWS CLI**:
   ```powershell
   # Download AWS CLI v2 for Windows
   # https://awscli.amazonaws.com/AWSCLIV2.msi
   
   # Configure AWS credentials
   aws configure
   # Enter your Access Key ID, Secret Access Key, Region (us-east-1), Output format (json)
   ```

### Step 2: Create AWS Infrastructure

### Step 3: Deploy AWS Infrastructure

1. **Deploy CloudFormation Stack**:
   ```powershell
   cd infrastructure
   
   # Deploy development environment
   aws cloudformation create-stack `
     --stack-name aniverse-dev `
     --template-body file://aniverse-infrastructure.yaml `
     --parameters ParameterKey=EnvironmentName,ParameterValue=dev `
     --capabilities CAPABILITY_NAMED_IAM
   
   # Monitor deployment progress
   aws cloudformation describe-stacks --stack-name aniverse-dev --query 'Stacks[0].StackStatus'
   
   # Wait for completion (takes 10-15 minutes)
   aws cloudformation wait stack-create-complete --stack-name aniverse-dev
   ```

2. **Get Stack Outputs**:
   ```powershell
   # Get all outputs
   aws cloudformation describe-stacks --stack-name aniverse-dev --query 'Stacks[0].Outputs'
   
   # Get specific values
   $CloudFrontDomain = aws cloudformation describe-stacks --stack-name aniverse-dev --query 'Stacks[0].Outputs[?OutputKey==`CloudFrontDomainName`].OutputValue' --output text
   $RawBucket = aws cloudformation describe-stacks --stack-name aniverse-dev --query 'Stacks[0].Outputs[?OutputKey==`RawUploadsBucket`].OutputValue' --output text
   $ProcessedBucket = aws cloudformation describe-stacks --stack-name aniverse-dev --query 'Stacks[0].Outputs[?OutputKey==`ProcessedMediaBucket`].OutputValue' --output text
   $MediaConvertRole = aws cloudformation describe-stacks --stack-name aniverse-dev --query 'Stacks[0].Outputs[?OutputKey==`MediaConvertRoleArn`].OutputValue' --output text
   
   Write-Host "CloudFront Domain: $CloudFrontDomain"
   Write-Host "Raw Uploads Bucket: $RawBucket"
   Write-Host "Processed Media Bucket: $ProcessedBucket"
   Write-Host "MediaConvert Role: $MediaConvertRole"
   ```

3. **Update Environment Variables**:
   
   Update `backend/.env` with AWS values:
   ```env
   # Replace with your actual values from CloudFormation outputs
   AWS_S3_BUCKET_RAW=aniverse-raw-uploads-dev
   AWS_S3_BUCKET_PROCESSED=aniverse-processed-media-dev
   AWS_CLOUDFRONT_DOMAIN=d1234567890123.cloudfront.net
   MEDIA_CONVERT_ROLE_ARN=arn:aws:iam::123456789012:role/AniVerse-MediaConvert-Role-dev
   MEDIA_CONVERT_ENDPOINT=https://mediaconvert.us-east-1.amazonaws.com
   ```
   
   Update `frontend/.env.local`:
   ```env
   NEXT_PUBLIC_AWS_CLOUDFRONT_DOMAIN=d1234567890123.cloudfront.net
   ```

### Step 4: Configure Database for AWS RDS (Optional)

For production, you may want to use AWS RDS instead of local MySQL:

1. **Create RDS Instance**:
   ```powershell
   # Create MySQL RDS instance
   aws rds create-db-instance `
     --db-instance-identifier aniverse-mysql-dev `
     --db-instance-class db.t3.micro `
     --engine mysql `
     --engine-version 8.0.35 `
     --master-username admin `
     --master-user-password YourSecurePassword123! `
     --allocated-storage 20 `
     --storage-type gp2 `
     --vpc-security-group-ids sg-your-security-group `
     --db-name aniverse `
     --backup-retention-period 7 `
     --storage-encrypted
   
   # Wait for RDS to be available
   aws rds wait db-instance-available --db-instance-identifier aniverse-mysql-dev
   
   # Get RDS endpoint
   $RDSEndpoint = aws rds describe-db-instances --db-instance-identifier aniverse-mysql-dev --query 'DBInstances[0].Endpoint.Address' --output text
   Write-Host "RDS Endpoint: $RDSEndpoint"
   ```

2. **Update Database Configuration**:
   ```env
   # Update backend/.env
   DATABASE_URL=mysql+pymysql://admin:YourSecurePassword123!@your-rds-endpoint.amazonaws.com:3306/aniverse
   DB_HOST=your-rds-endpoint.amazonaws.com
   DB_USER=admin
   DB_PASSWORD=YourSecurePassword123!
   ```

### Step 5: Test AWS Integration

1. **Test S3 Upload**:
   ```powershell
   # Create a test video file and upload
   aws s3 cp test-video.mp4 s3://aniverse-raw-uploads-dev/test/
   
   # Check if Lambda was triggered (check CloudWatch Logs)
   aws logs describe-log-groups --log-group-name-prefix /aws/lambda/aniverse-video-processing
   ```

2. **Verify CloudFront**:
   ```powershell
   # Test CloudFront distribution
   curl https://$CloudFrontDomain/test-file.txt
   ```

---

## 🔧 Production Deployment

### Step 1: Domain and SSL Setup

1. **Register Domain** (e.g., aniverse.com)
2. **Create SSL Certificate**:
   ```powershell
   # Request certificate in us-east-1 for CloudFront
   aws acm request-certificate `
     --domain-name aniverse.com `
     --subject-alternative-names "*.aniverse.com" `
     --validation-method DNS `
     --region us-east-1
   ```

3. **Update CloudFormation** with custom domain

### Step 2: Production Environment

```powershell
# Deploy production stack
aws cloudformation create-stack `
  --stack-name aniverse-prod `
  --template-body file://aniverse-infrastructure.yaml `
  --parameters ParameterKey=EnvironmentName,ParameterValue=prod ParameterKey=DomainName,ParameterValue=aniverse.com `
  --capabilities CAPABILITY_NAMED_IAM
```

### Step 3: CI/CD Pipeline (Optional)

1. **GitHub Actions Workflow**:
   ```yaml
   # .github/workflows/deploy.yml
   name: Deploy AniVerse
   on:
     push:
       branches: [main]
   
   jobs:
     deploy:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v3
         - name: Deploy to AWS
           run: |
             # Deploy backend to EC2/ECS
             # Deploy frontend to S3 + CloudFront
             # Update infrastructure
   ```

---

## 📊 Monitoring Setup

### Step 1: CloudWatch Dashboards

1. **Create Custom Dashboard**:
   ```powershell
   # Create dashboard for monitoring
   aws cloudwatch put-dashboard `
     --dashboard-name "AniVerse-Monitoring" `
     --dashboard-body file://dashboard-config.json
   ```

### Step 2: Set Up Alerts

```powershell
# Create CloudWatch alarms
aws cloudwatch put-metric-alarm `
  --alarm-name "AniVerse-High-Error-Rate" `
  --alarm-description "High error rate detected" `
  --metric-name ErrorCount `
  --namespace AWS/Lambda `
  --statistic Sum `
  --period 300 `
  --evaluation-periods 2 `
  --threshold 10 `
  --comparison-operator GreaterThanThreshold
```

---

## 🧪 Testing the Complete Setup

### End-to-End Test

1. **Start Local Development**:
   ```powershell
   cd C:\Users\Anirudh\AniVerse
   docker-compose up -d
   ```

2. **Test Video Upload Workflow**:
   - Upload video via admin panel
   - Verify S3 upload
   - Check MediaConvert job
   - Confirm HLS output
   - Test streaming via CloudFront

3. **Verify Monitoring**:
   - Check Prometheus metrics: http://localhost:9090
   - View Grafana dashboards: http://localhost:3001
   - Monitor CloudWatch logs in AWS Console

### Manual Testing Checklist

- [ ] Frontend loads at http://localhost:3000
- [ ] Backend API responds at http://localhost:8000
- [ ] User registration/login works
- [ ] Database connections successful
- [ ] AWS S3 upload functional
- [ ] Video transcoding pipeline working
- [ ] CloudFront serving HLS streams
- [ ] Monitoring metrics collecting
- [ ] All environment variables configured

---

## 🚨 Troubleshooting

### Common Issues

1. **AWS Credentials Not Working**:
   ```powershell
   # Verify AWS credentials
   aws sts get-caller-identity
   
   # Check AWS CLI configuration
   aws configure list
   ```

2. **CloudFormation Stack Fails**:
   ```powershell
   # Check stack events for errors
   aws cloudformation describe-stack-events --stack-name aniverse-dev
   
   # Delete failed stack and retry
   aws cloudformation delete-stack --stack-name aniverse-dev
   ```

3. **MediaConvert Jobs Failing**:
   ```powershell
   # Check MediaConvert job status
   aws mediaconvert describe-job --id your-job-id
   
   # Check Lambda function logs
   aws logs filter-log-events --log-group-name /aws/lambda/aniverse-video-processing-dev
   ```

4. **Docker Issues on Windows**:
   ```powershell
   # Restart Docker Desktop
   # Check Docker daemon is running
   docker version
   
   # Reset Docker if needed
   docker system prune -a
   ```

5. **Port Already in Use**:
   ```powershell
   # Find process using port
   netstat -ano | findstr :3000
   
   # Kill process
   taskkill /PID <PID> /F
   ```

### Get Help

- Check logs: `docker-compose logs -f`
- AWS CloudWatch Logs for Lambda functions
- GitHub Issues for project-specific problems
- AWS Support for infrastructure issues

---

## 💰 Cost Optimization

### AWS Cost Management

1. **Set up Billing Alerts**
2. **Use S3 Lifecycle Policies** for old videos
3. **Configure CloudFront Caching** properly
4. **Monitor MediaConvert Usage**
5. **Use Reserved Instances** for production

### Development Costs

- **Free Tier**: Most AWS services have free tier limits
- **Development Environment**: ~$20-50/month
- **Production Environment**: ~$100-500/month (depending on usage)

---

**🎉 Congratulations!** Your AniVerse platform is now fully configured and ready for development and production deployment.
