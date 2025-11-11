# Build script for Flutter Web with auto-versioning
# This script automatically increments the version and builds the web app

Write-Host "================================" -ForegroundColor Cyan
Write-Host "  Klaussified Web Build" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Increment version
Write-Host "Step 1: Incrementing version..." -ForegroundColor Yellow
& .\increment_version.ps1
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Version increment failed!" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Step 2: Build web app
Write-Host "Step 2: Building Flutter web app..." -ForegroundColor Yellow
flutter build web
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Build failed!" -ForegroundColor Red
    exit 1
}
Write-Host ""

Write-Host "================================" -ForegroundColor Green
Write-Host "✓ Build completed successfully!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Test the build locally: flutter run -d chrome --release" -ForegroundColor Gray
Write-Host "  2. Deploy to production: firebase deploy --only hosting" -ForegroundColor Gray
