# Script de Test Release v1.1.0
# Date: 19 octobre 2025

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "  TEST RELEASE v1.1.0 - TALENTYS PLATFORM" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

$testResults = @{
    Passed = 0
    Failed = 0
    Warnings = 0
}

function Test-Item {
    param(
        [string]$TestName,
        [scriptblock]$TestScript,
        [string]$ExpectedResult = "OK"
    )
    
    Write-Host "[TEST] $TestName..." -ForegroundColor Yellow -NoNewline
    
    try {
        $result = & $TestScript
        if ($result) {
            Write-Host " ✓ PASS" -ForegroundColor Green
            $script:testResults.Passed++
            return $true
        } else {
            Write-Host " ✗ FAIL" -ForegroundColor Red
            $script:testResults.Failed++
            return $false
        }
    } catch {
        Write-Host " ✗ ERROR: $_" -ForegroundColor Red
        $script:testResults.Failed++
        return $false
    }
}

function Test-Warning {
    param([string]$Message)
    Write-Host "  ⚠ WARNING: $Message" -ForegroundColor Yellow
    $script:testResults.Warnings++
}

Write-Host "1. STRUCTURE DU PROJECT" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan

# Test 1: Fichiers essentiels
Test-Item "README.md existe" {
    Test-Path "README.md"
}

Test-Item "CHANGELOG.md existe" {
    Test-Path "CHANGELOG.md"
}

Test-Item "RELEASE_GUIDE_v1.1.md existe" {
    Test-Path "RELEASE_GUIDE_v1.1.md"
}

Test-Item "docker-compose.yml existe" {
    Test-Path "docker-compose.yml"
}

Test-Item "docker-compose-ai.yml existe" {
    Test-Path "docker-compose-ai.yml"
}

# Test 2: Structure AI Services
Write-Host "`n2. AI SERVICES INFRASTRUCTURE" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan

Test-Item "Chat UI existe" {
    Test-Path "ai-services/chat-ui/app.py"
}

Test-Item "RAG API existe" {
    Test-Path "ai-services/rag-api/app.py"
}

Test-Item "Embedding service existe" {
    Test-Path "ai-services/embedding/app.py"
}

Test-Item "Ollama models folder existe" {
    Test-Path "ai-services/ollama/models"
}

Test-Item "Ollama .gitignore protège les modèles" {
    Test-Path "ai-services/ollama/models/.gitignore"
}

# Test 3: Internationalisation
Write-Host "`n3. INTERNATIONALISATION (i18n)" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan

$languages = @("en", "fr", "es", "pt", "cn", "jp", "ru", "ar", "de", "ko", "hi", "id", "tr", "vi", "it", "nl", "pl", "se")
$languageCount = 0

foreach ($lang in $languages) {
    if (Test-Path "docs/i18n/$lang/ROADMAP.md") {
        $languageCount++
    }
}

Test-Item "18 langues i18n disponibles" {
    $languageCount -eq 18
}

Test-Item "ROADMAP i18n principal existe" {
    Test-Path "docs/i18n/ROADMAP.md"
}

# Test 4: Assets et Branding
Write-Host "`n4. ASSETS ET BRANDING" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan

$logoCount = (Get-ChildItem "assets/images/talentys" -Filter "*.png" -ErrorAction SilentlyContinue).Count

Test-Item "Logos Talentys disponibles" {
    $logoCount -ge 20
}

Test-Item "Guide screenshots existe" {
    Test-Path "assets/screenshots/PLATFORM_SCREENSHOTS_GUIDE.md"
}

# Test 5: Scripts d'automatisation
Write-Host "`n5. SCRIPTS D'AUTOMATISATION" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan

$scriptCount = (Get-ChildItem "scripts" -Filter "*.ps1" -ErrorAction SilentlyContinue).Count + 
               (Get-ChildItem "scripts" -Filter "*.py" -ErrorAction SilentlyContinue).Count + 
               (Get-ChildItem "scripts" -Filter "*.sh" -ErrorAction SilentlyContinue).Count

Test-Item "Scripts automatisation disponibles" {
    $scriptCount -ge 25
}

Test-Item "Script i18n existe" {
    Test-Path "scripts/translate-i18n-auto.py"
}

# Test 6: Sécurité
Write-Host "`n6. SÉCURITÉ" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan

Test-Item ".gitignore exclu les clés SSH" {
    Select-String -Path "ai-services/ollama/models/.gitignore" -Pattern "id_ed25519" -Quiet
}

Test-Item "Clés SSH NON présentes localement" {
    -not (Test-Path "ai-services/ollama/models/id_ed25519")
}

Test-Item "Documentation sécurité existe" {
    Test-Path "SECURITY_SSH_KEY_CHECK.md"
}

Test-Item "Script vérification sécurité existe" {
    Test-Path "scripts/check-ssh-security.ps1"
}

# Test 7: Git et Version Control
Write-Host "`n7. GIT ET VERSION CONTROL" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan

$currentBranch = git branch --show-current
Test-Item "Branch actuelle: main" {
    $currentBranch -eq "main"
}

$tagExists = git tag -l "v1.1.0"
Test-Item "Tag v1.1.0 existe" {
    $tagExists -eq "v1.1.0"
}

$remoteUrl = git remote get-url origin
Test-Item "Remote pointe vers ArcaP" {
    $remoteUrl -match "ArcaP"
}

$uncommittedChanges = git status --porcelain
Test-Item "Pas de changements non commités" {
    $uncommittedChanges.Length -eq 0
}

if ($uncommittedChanges.Length -gt 0) {
    Test-Warning "Changements non commités détectés"
}

# Test 8: Configuration Docker
Write-Host "`n8. CONFIGURATION DOCKER" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan

Test-Item "docker-compose-openmetadata existe" {
    Test-Path "docker-compose-openmetadata-official.yml"
}

Test-Item "docker-compose-superset existe" {
    Test-Path "docker-compose-superset.yml"
}

Test-Item "docker-compose-airbyte existe" {
    Test-Path "docker-compose-airbyte.yml"
}

# Test 9: Documentation
Write-Host "`n9. DOCUMENTATION" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan

Test-Item "QUICK_START.md existe" {
    Test-Path "QUICK_START.md"
}

Test-Item "Documentation API existe" {
    Test-Path "docs/api/README.md"
}

Test-Item "Documentation Architecture existe" {
    Test-Path "docs/architecture/README.md"
}

Test-Item "Guides utilisateur existent" {
    Test-Path "docs/guides"
}

# Test 10: OpenMetadata
Write-Host "`n10. OPENMETADATA INTEGRATION" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan

Test-Item "OpenMetadata Quickstart existe" {
    Test-Path "openmetadata/QUICKSTART.md"
}

Test-Item "OpenMetadata config existe" {
    Test-Path "openmetadata/conf"
}

# Résumé des Tests
Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "  RÉSUMÉ DES TESTS" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

Write-Host "Tests Réussis:  $($testResults.Passed)" -ForegroundColor Green
Write-Host "Tests Échoués:  $($testResults.Failed)" -ForegroundColor $(if ($testResults.Failed -eq 0) { "Green" } else { "Red" })
Write-Host "Avertissements: $($testResults.Warnings)" -ForegroundColor Yellow

$totalTests = $testResults.Passed + $testResults.Failed
$successRate = [math]::Round(($testResults.Passed / $totalTests) * 100, 2)

Write-Host "`nTaux de Réussite: $successRate%" -ForegroundColor $(if ($successRate -ge 95) { "Green" } elseif ($successRate -ge 80) { "Yellow" } else { "Red" })

if ($testResults.Failed -eq 0) {
    Write-Host "`n✓ RELEASE v1.1.0 PRÊTE POUR DÉPLOIEMENT !`n" -ForegroundColor Green
    
    Write-Host "Prochaines étapes:" -ForegroundColor Cyan
    Write-Host "  1. Créer GitHub Release" -ForegroundColor White
    Write-Host "     https://github.com/Monsau/ArcaP/releases/new" -ForegroundColor Gray
    Write-Host "  2. Créer 9 screenshots" -ForegroundColor White
    Write-Host "     Voir: assets/screenshots/PLATFORM_SCREENSHOTS_GUIDE.md" -ForegroundColor Gray
    Write-Host "  3. Publier LinkedIn" -ForegroundColor White
    Write-Host "     Voir: LINKEDIN_POST_READY.md" -ForegroundColor Gray
} else {
    Write-Host "`n✗ ATTENTION: Des tests ont échoué. Corriger avant release.`n" -ForegroundColor Red
}

Write-Host "`nDétails complets: RELEASE_GUIDE_v1.1.md`n" -ForegroundColor Gray

# Ouvrir le navigateur pour GitHub Release
$openGitHub = Read-Host "Ouvrir GitHub Releases dans le navigateur? (o/n)"
if ($openGitHub -eq "o") {
    Start-Process "https://github.com/Monsau/ArcaP/releases/new?tag=v1.1.0"
}
