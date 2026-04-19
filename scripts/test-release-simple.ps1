# Script de Test Release v1.1.0 - Version Simplifiée
# Date: 19 octobre 2025

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "  TEST RELEASE v1.1.0 - TALENTYS PLATFORM" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

$passed = 0
$failed = 0

function Test-File {
    param([string]$Path, [string]$Name)
    
    Write-Host "[TEST] $Name..." -NoNewline
    if (Test-Path $Path) {
        Write-Host " PASS" -ForegroundColor Green
        $script:passed++
        return $true
    } else {
        Write-Host " FAIL" -ForegroundColor Red
        $script:failed++
        return $false
    }
}

Write-Host "`n1. FICHIERS ESSENTIELS" -ForegroundColor Yellow
Test-File "README.md" "README.md"
Test-File "CHANGELOG.md" "CHANGELOG.md"
Test-File "RELEASE_GUIDE_v1.1.md" "RELEASE_GUIDE_v1.1.md"
Test-File "docker-compose.yml" "docker-compose.yml"
Test-File "docker-compose-ai.yml" "docker-compose-ai.yml"

Write-Host "`n2. AI SERVICES" -ForegroundColor Yellow
Test-File "ai-services/chat-ui/app.py" "Chat UI"
Test-File "ai-services/rag-api/app.py" "RAG API"
Test-File "ai-services/embedding/app.py" "Embedding Service"
Test-File "ai-services/ollama/models" "Ollama Models Folder"
Test-File "ai-services/ollama/models/.gitignore" "Ollama .gitignore"

Write-Host "`n3. INTERNATIONALISATION" -ForegroundColor Yellow
$langCount = 0
$languages = @("en", "fr", "es", "pt", "cn", "jp", "ru", "ar", "de", "ko", "hi", "id", "tr", "vi", "it", "nl", "pl", "se")
foreach ($lang in $languages) {
    if (Test-Path "docs/i18n/$lang/ROADMAP.md") {
        $langCount++
    }
}
Write-Host "[TEST] $langCount/18 langues i18n..." -NoNewline
if ($langCount -eq 18) {
    Write-Host " PASS" -ForegroundColor Green
    $passed++
} else {
    Write-Host " FAIL" -ForegroundColor Red
    $failed++
}

Write-Host "`n4. ASSETS & BRANDING" -ForegroundColor Yellow
$logoCount = (Get-ChildItem "assets/images/talentys" -Filter "*.png" -ErrorAction SilentlyContinue).Count
Write-Host "[TEST] $logoCount logos Talentys..." -NoNewline
if ($logoCount -ge 20) {
    Write-Host " PASS" -ForegroundColor Green
    $passed++
} else {
    Write-Host " FAIL" -ForegroundColor Red
    $failed++
}
Test-File "assets/screenshots/PLATFORM_SCREENSHOTS_GUIDE.md" "Screenshots Guide"

Write-Host "`n5. SCRIPTS" -ForegroundColor Yellow
$scriptCount = (Get-ChildItem "scripts" -Filter "*.ps1").Count + 
               (Get-ChildItem "scripts" -Filter "*.py").Count
Write-Host "[TEST] $scriptCount scripts automatisation..." -NoNewline
if ($scriptCount -ge 25) {
    Write-Host " PASS" -ForegroundColor Green
    $passed++
} else {
    Write-Host " FAIL" -ForegroundColor Red
    $failed++
}

Write-Host "`n6. SECURITE" -ForegroundColor Yellow
Test-File "ai-services/ollama/models/.gitignore" ".gitignore SSH keys"
Write-Host "[TEST] Cles SSH supprimees..." -NoNewline
if (-not (Test-Path "ai-services/ollama/models/id_ed25519")) {
    Write-Host " PASS" -ForegroundColor Green
    $passed++
} else {
    Write-Host " FAIL" -ForegroundColor Red
    $failed++
}
Test-File "SECURITY_SSH_KEY_CHECK.md" "Documentation securite"
Test-File "scripts/check-ssh-security.ps1" "Script verification securite"

Write-Host "`n7. GIT & VERSION CONTROL" -ForegroundColor Yellow
$currentBranch = git branch --show-current
Write-Host "[TEST] Branch main..." -NoNewline
if ($currentBranch -eq "main") {
    Write-Host " PASS" -ForegroundColor Green
    $passed++
} else {
    Write-Host " FAIL" -ForegroundColor Red
    $failed++
}

$tagExists = git tag -l "v1.1.0"
Write-Host "[TEST] Tag v1.1.0..." -NoNewline
if ($tagExists) {
    Write-Host " PASS" -ForegroundColor Green
    $passed++
} else {
    Write-Host " FAIL" -ForegroundColor Red
    $failed++
}

$remoteUrl = git remote get-url origin
Write-Host "[TEST] Remote ArcaP..." -NoNewline
if ($remoteUrl -match "ArcaP") {
    Write-Host " PASS" -ForegroundColor Green
    $passed++
} else {
    Write-Host " FAIL" -ForegroundColor Red
    $failed++
}

Write-Host "`n8. DOCUMENTATION" -ForegroundColor Yellow
Test-File "QUICK_START.md" "Quick Start"
Test-File "docs/api/README.md" "Documentation API"
Test-File "docs/architecture/README.md" "Documentation Architecture"

Write-Host "`n9. OPENMETADATA" -ForegroundColor Yellow
Test-File "openmetadata/QUICKSTART.md" "OpenMetadata Quickstart"
Test-File "docker-compose-openmetadata-official.yml" "docker-compose OpenMetadata"

# Résumé
$total = $passed + $failed
$rate = [math]::Round(($passed / $total) * 100, 1)

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "  RESULTAT DES TESTS" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

Write-Host "Tests reussis:  $passed" -ForegroundColor Green
Write-Host "Tests echoues:  $failed" -ForegroundColor $(if ($failed -eq 0) { "Green" } else { "Red" })
Write-Host "Taux reussite:  $rate%" -ForegroundColor $(if ($rate -ge 95) { "Green" } elseif ($rate -ge 80) { "Yellow" } else { "Red" })

if ($failed -eq 0) {
    Write-Host "`n RELEASE v1.1.0 PRETE POUR DEPLOIEMENT !`n" -ForegroundColor Green
    
    Write-Host "Prochaines etapes:" -ForegroundColor Cyan
    Write-Host "  1. Creer GitHub Release" -ForegroundColor White
    Write-Host "     https://github.com/Monsau/ArcaP/releases/new?tag=v1.1.0" -ForegroundColor Gray
    Write-Host "  2. Creer 9 screenshots" -ForegroundColor White
    Write-Host "     Voir: assets/screenshots/PLATFORM_SCREENSHOTS_GUIDE.md" -ForegroundColor Gray
    Write-Host "  3. Publier LinkedIn" -ForegroundColor White
    Write-Host "     Voir: LINKEDIN_POST_READY.md" -ForegroundColor Gray
    
    $openGitHub = Read-Host "`nOuvrir GitHub Releases? (o/n)"
    if ($openGitHub -eq "o") {
        Start-Process "https://github.com/Monsau/ArcaP/releases/new?tag=v1.1.0"
    }
} else {
    Write-Host "`n ATTENTION: Corriger les tests echoues avant release`n" -ForegroundColor Red
}
