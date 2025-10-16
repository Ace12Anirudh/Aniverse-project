# AniVerse Quick Development Setup Script
# This script sets up the development environment quickly

Write-Host "🎌 AniVerse Development Setup" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

$currentDir = Get-Location

# Function to check if command exists
function Test-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# Check prerequisites
Write-Host "`n🔍 Checking prerequisites..." -ForegroundColor Blue

# Check Docker
if (Test-Command "docker") {
    $dockerVersion = docker --version
    Write-Host "✅ Docker: $dockerVersion" -ForegroundColor Green
} else {
    Write-Host "❌ Docker not found. Please install Docker Desktop from https://docker.com/products/docker-desktop" -ForegroundColor Red
    exit 1
}

# Check Node.js
if (Test-Command "node") {
    $nodeVersion = node --version
    Write-Host "✅ Node.js: $nodeVersion" -ForegroundColor Green
} else {
    Write-Host "❌ Node.js not found. Please install Node.js from https://nodejs.org/" -ForegroundColor Red
    exit 1
}

# Check Python
if (Test-Command "python") {
    $pythonVersion = python --version
    Write-Host "✅ Python: $pythonVersion" -ForegroundColor Green
} else {
    Write-Host "❌ Python not found. Please install Python from https://python.org/" -ForegroundColor Red
    exit 1
}

# Check Git
if (Test-Command "git") {
    $gitVersion = git --version
    Write-Host "✅ Git: $gitVersion" -ForegroundColor Green
} else {
    Write-Host "❌ Git not found. Please install Git from https://git-scm.com/" -ForegroundColor Red
    exit 1
}

# Setup backend environment
Write-Host "`n⚙️ Setting up backend environment..." -ForegroundColor Blue

if (!(Test-Path "backend\.env")) {
    Write-Host "📝 Creating backend environment file..." -ForegroundColor Yellow
    Copy-Item "backend\.env.example" "backend\.env"
    
    # Generate a random secret key
    $secretKey = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 32 | % {[char]$_})
    $content = Get-Content "backend\.env" -Raw
    $content = $content -replace "your-super-secret-jwt-key-change-this-in-production", $secretKey
    Set-Content "backend\.env" $content
    
    Write-Host "✅ Backend environment file created with random secret key" -ForegroundColor Green
} else {
    Write-Host "✅ Backend environment file already exists" -ForegroundColor Green
}

# Setup frontend environment
Write-Host "`n⚙️ Setting up frontend environment..." -ForegroundColor Blue

if (!(Test-Path "frontend\.env.local")) {
    Write-Host "📝 Creating frontend environment file..." -ForegroundColor Yellow
    @"
NEXT_PUBLIC_API_URL=http://localhost:8000
NEXT_PUBLIC_APP_NAME=AniVerse
"@ | Out-File -FilePath "frontend\.env.local" -Encoding UTF8
    Write-Host "✅ Frontend environment file created" -ForegroundColor Green
} else {
    Write-Host "✅ Frontend environment file already exists" -ForegroundColor Green
}

# Start development environment
Write-Host "`n🚀 Starting development environment..." -ForegroundColor Blue

try {
    # Pull latest images
    Write-Host "📦 Pulling Docker images..." -ForegroundColor Yellow
    docker-compose pull
    
    # Start services
    Write-Host "🔄 Starting services..." -ForegroundColor Yellow
    docker-compose up -d
    
    Write-Host "✅ Services started successfully!" -ForegroundColor Green
    
    # Wait for services to be ready
    Write-Host "⏳ Waiting for services to be ready..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10
    
    # Check service health
    Write-Host "`n🔍 Checking service health..." -ForegroundColor Blue
    
    # Check MySQL
    $mysqlReady = $false
    for ($i = 1; $i -le 30; $i++) {
        try {
            $result = docker-compose exec -T mysql mysqladmin ping -h localhost --silent
            if ($LASTEXITCODE -eq 0) {
                $mysqlReady = $true
                break
            }
        } catch {}
        
        Write-Host "  Waiting for MySQL... ($i/30)" -ForegroundColor Yellow
        Start-Sleep -Seconds 2
    }
    
    if ($mysqlReady) {
        Write-Host "✅ MySQL is ready" -ForegroundColor Green
    } else {
        Write-Host "⚠️ MySQL may not be ready yet" -ForegroundColor Yellow
    }
    
    # Check backend
    for ($i = 1; $i -le 15; $i++) {
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:8000/health" -TimeoutSec 5 -ErrorAction Stop
            if ($response.StatusCode -eq 200) {
                Write-Host "✅ Backend API is ready" -ForegroundColor Green
                break
            }
        } catch {
            Write-Host "  Waiting for Backend API... ($i/15)" -ForegroundColor Yellow
            Start-Sleep -Seconds 2
        }
    }
    
    # Check frontend
    for ($i = 1; $i -le 15; $i++) {
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:3000" -TimeoutSec 5 -ErrorAction Stop
            if ($response.StatusCode -eq 200) {
                Write-Host "✅ Frontend is ready" -ForegroundColor Green
                break
            }
        } catch {
            Write-Host "  Waiting for Frontend... ($i/15)" -ForegroundColor Yellow
            Start-Sleep -Seconds 2
        }
    }
    
} catch {
    Write-Host "❌ Failed to start services: $_" -ForegroundColor Red
    Write-Host "`n📋 Checking logs..." -ForegroundColor Yellow
    docker-compose logs --tail=20
    exit 1
}

# Display information
Write-Host "`n🎉 Development environment is ready!" -ForegroundColor Green
Write-Host "`n🌐 Available Services:" -ForegroundColor Blue
Write-Host "  Frontend:        http://localhost:3000" -ForegroundColor Cyan
Write-Host "  Backend API:     http://localhost:8000" -ForegroundColor Cyan
Write-Host "  API Docs:        http://localhost:8000/docs" -ForegroundColor Cyan
Write-Host "  Health Check:    http://localhost:8000/health" -ForegroundColor Cyan
Write-Host "  Prometheus:      http://localhost:9090" -ForegroundColor Cyan
Write-Host "  Grafana:         http://localhost:3001 (admin/admin)" -ForegroundColor Cyan

Write-Host "`n📋 Default Login Credentials:" -ForegroundColor Blue
Write-Host "  Admin:           admin / admin123" -ForegroundColor Cyan
Write-Host "  Demo User:       demo_user / admin123" -ForegroundColor Cyan

Write-Host "`n🔧 Useful Commands:" -ForegroundColor Blue
Write-Host "  View logs:       docker-compose logs -f" -ForegroundColor White
Write-Host "  Stop services:   docker-compose down" -ForegroundColor White
Write-Host "  Restart:         docker-compose restart" -ForegroundColor White
Write-Host "  Reset data:      docker-compose down -v && docker-compose up -d" -ForegroundColor White

Write-Host "`n📚 Next Steps:" -ForegroundColor Blue
Write-Host "1. Visit http://localhost:3000 to see the frontend" -ForegroundColor White
Write-Host "2. Visit http://localhost:8000/docs for API documentation" -ForegroundColor White
Write-Host "3. Check out the README.md and DEVELOPMENT.md for more information" -ForegroundColor White
Write-Host "4. Start developing your anime streaming platform!" -ForegroundColor White

# Optional: Open browser
$openBrowser = Read-Host "`n🌐 Would you like to open the application in your browser? (y/n)"
if ($openBrowser -eq 'y' -or $openBrowser -eq 'Y') {
    Start-Process "http://localhost:3000"
    Start-Process "http://localhost:8000/docs"
}

Write-Host "`n🎌 Happy coding! Your AniVerse development environment is ready! 🎌" -ForegroundColor Magenta
