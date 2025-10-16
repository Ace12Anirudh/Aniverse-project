# AniVerse AWS Infrastructure Deployment Script
# This script deploys the complete AWS infrastructure for AniVerse

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("dev", "staging", "prod")]
    [string]$Environment,
    
    [Parameter(Mandatory=$false)]
    [string]$DomainName = "",
    
    [Parameter(Mandatory=$false)]
    [switch]$Delete,
    
    [Parameter(Mandatory=$false)]
    [switch]$Update
)

$StackName = "aniverse-$Environment"
$TemplateFile = "aniverse-infrastructure.yaml"
$Region = "us-east-1"

Write-Host "🚀 AniVerse Infrastructure Deployment Script" -ForegroundColor Cyan
Write-Host "Environment: $Environment" -ForegroundColor Yellow
Write-Host "Stack Name: $StackName" -ForegroundColor Yellow
Write-Host "Region: $Region" -ForegroundColor Yellow

# Check if AWS CLI is configured
Write-Host "`n🔍 Checking AWS CLI configuration..." -ForegroundColor Blue
try {
    $identity = aws sts get-caller-identity --output json | ConvertFrom-Json
    Write-Host "✅ AWS CLI configured for account: $($identity.Account)" -ForegroundColor Green
} catch {
    Write-Host "❌ AWS CLI not configured. Please run 'aws configure'" -ForegroundColor Red
    exit 1
}

# Check if template file exists
if (!(Test-Path $TemplateFile)) {
    Write-Host "❌ CloudFormation template not found: $TemplateFile" -ForegroundColor Red
    exit 1
}

# Delete stack if requested
if ($Delete) {
    Write-Host "`n🗑️ Deleting stack: $StackName" -ForegroundColor Red
    
    try {
        aws cloudformation delete-stack --stack-name $StackName --region $Region
        Write-Host "⏳ Waiting for stack deletion to complete..." -ForegroundColor Yellow
        aws cloudformation wait stack-delete-complete --stack-name $StackName --region $Region
        Write-Host "✅ Stack deleted successfully!" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to delete stack: $_" -ForegroundColor Red
        exit 1
    }
    exit 0
}

# Prepare parameters
$Parameters = "ParameterKey=EnvironmentName,ParameterValue=$Environment"
if ($DomainName) {
    $Parameters += " ParameterKey=DomainName,ParameterValue=$DomainName"
}

# Check if stack exists
Write-Host "`n🔍 Checking if stack exists..." -ForegroundColor Blue
try {
    $stackStatus = aws cloudformation describe-stacks --stack-name $StackName --region $Region --query 'Stacks[0].StackStatus' --output text 2>$null
    $stackExists = $true
    Write-Host "📋 Stack exists with status: $stackStatus" -ForegroundColor Yellow
} catch {
    $stackExists = $false
    Write-Host "📋 Stack does not exist" -ForegroundColor Yellow
}

# Deploy or update stack
if ($Update -or $stackExists) {
    Write-Host "`n🔄 Updating stack: $StackName" -ForegroundColor Blue
    $operation = "update-stack"
    $waitCommand = "stack-update-complete"
} else {
    Write-Host "`n🚀 Creating stack: $StackName" -ForegroundColor Blue
    $operation = "create-stack"
    $waitCommand = "stack-create-complete"
}

try {
    # Execute CloudFormation command
    $command = "aws cloudformation $operation --stack-name $StackName --template-body file://$TemplateFile --parameters $Parameters --capabilities CAPABILITY_NAMED_IAM --region $Region"
    Write-Host "Executing: $command" -ForegroundColor Gray
    Invoke-Expression $command
    
    Write-Host "⏳ Waiting for stack operation to complete... (this may take 10-15 minutes)" -ForegroundColor Yellow
    aws cloudformation wait $waitCommand --stack-name $StackName --region $Region
    
    Write-Host "✅ Stack operation completed successfully!" -ForegroundColor Green
    
} catch {
    Write-Host "❌ Stack operation failed: $_" -ForegroundColor Red
    
    # Show recent stack events for debugging
    Write-Host "`n📋 Recent stack events:" -ForegroundColor Yellow
    aws cloudformation describe-stack-events --stack-name $StackName --region $Region --max-items 10 --query 'StackEvents[*].[Timestamp,ResourceStatus,ResourceType,LogicalResourceId,ResourceStatusReason]' --output table
    
    exit 1
}

# Get and display stack outputs
Write-Host "`n📋 Stack Outputs:" -ForegroundColor Blue
try {
    $outputs = aws cloudformation describe-stacks --stack-name $StackName --region $Region --query 'Stacks[0].Outputs' --output json | ConvertFrom-Json
    
    foreach ($output in $outputs) {
        Write-Host "  $($output.OutputKey): $($output.OutputValue)" -ForegroundColor Green
    }
    
    # Save outputs to environment file
    $envFile = "../backend/.env.aws"
    Write-Host "`n💾 Saving AWS configuration to: $envFile" -ForegroundColor Blue
    
    $envContent = "# AWS Configuration from CloudFormation Stack: $StackName`n"
    $envContent += "# Generated on: $(Get-Date)`n`n"
    
    foreach ($output in $outputs) {
        switch ($output.OutputKey) {
            "RawUploadsBucket" { $envContent += "AWS_S3_BUCKET_RAW=$($output.OutputValue)`n" }
            "ProcessedMediaBucket" { $envContent += "AWS_S3_BUCKET_PROCESSED=$($output.OutputValue)`n" }
            "CloudFrontDomainName" { 
                $envContent += "AWS_CLOUDFRONT_DOMAIN=$($output.OutputValue)`n"
                $envContent += "NEXT_PUBLIC_AWS_CLOUDFRONT_DOMAIN=$($output.OutputValue)`n"
            }
            "MediaConvertRoleArn" { $envContent += "MEDIA_CONVERT_ROLE_ARN=$($output.OutputValue)`n" }
            "SNSTopicArn" { $envContent += "SNS_TOPIC_ARN=$($output.OutputValue)`n" }
        }
    }
    
    $envContent += "MEDIA_CONVERT_ENDPOINT=https://mediaconvert.$Region.amazonaws.com`n"
    
    $envContent | Out-File -FilePath $envFile -Encoding UTF8
    Write-Host "✅ AWS configuration saved!" -ForegroundColor Green
    
} catch {
    Write-Host "⚠️ Could not retrieve stack outputs: $_" -ForegroundColor Yellow
}

# Display next steps
Write-Host "`n🎉 Deployment Complete!" -ForegroundColor Cyan
Write-Host "`n📋 Next Steps:" -ForegroundColor Blue
Write-Host "1. Update your backend/.env file with the AWS configuration values above" -ForegroundColor White
Write-Host "2. Update your frontend/.env.local with the CloudFront domain" -ForegroundColor White
Write-Host "3. Test the video upload and processing pipeline" -ForegroundColor White
Write-Host "4. Monitor the infrastructure in AWS Console" -ForegroundColor White

if ($Environment -eq "prod") {
    Write-Host "`n⚠️ Production Checklist:" -ForegroundColor Yellow
    Write-Host "- Configure custom domain with SSL certificate" -ForegroundColor White
    Write-Host "- Set up CloudWatch alarms and monitoring" -ForegroundColor White
    Write-Host "- Configure backup and disaster recovery" -ForegroundColor White
    Write-Host "- Review security groups and IAM policies" -ForegroundColor White
    Write-Host "- Set up CI/CD pipeline" -ForegroundColor White
}

Write-Host "`n🔗 Useful Links:" -ForegroundColor Blue
Write-Host "- AWS Console: https://console.aws.amazon.com/" -ForegroundColor Cyan
Write-Host "- CloudFormation: https://console.aws.amazon.com/cloudformation/" -ForegroundColor Cyan
Write-Host "- MediaConvert: https://console.aws.amazon.com/mediaconvert/" -ForegroundColor Cyan
Write-Host "- S3 Buckets: https://console.aws.amazon.com/s3/" -ForegroundColor Cyan

Write-Host "`n🎌 AniVerse infrastructure is ready for anime streaming! 🎌" -ForegroundColor Magenta
