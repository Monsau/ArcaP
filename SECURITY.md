# Security Policy — ArcaP

**Maintained by:** [Mustapha Fonsau](https://www.linkedin.com/in/mustapha-fonsau/) · [Talentys](https://talentys.eu)
**LinkedIn:** [linkedin.com/company/talentysdata](https://www.linkedin.com/company/talentysdata)

---

## Supported Versions

| Version | Status |
|---------|--------|
| 4.x     | ✅ Active support |
| 3.x     | ⚠️ Security fixes only |
| < 3.0   | ❌ End of life |

---

## Reporting a Vulnerability

**Please do NOT open a public GitHub issue for security vulnerabilities.**

Report security issues privately to:
- 📧 **Email:** mfonsau@talentys.eu
- 🔐 **Subject:** `[SECURITY] ArcaP — <brief description>`

### What to include

1. Description of the vulnerability
2. Steps to reproduce (proof-of-concept if possible)
3. Affected component(s) and version(s)
4. Potential impact assessment
5. Your suggested mitigation (optional)

### Response timeline

| Stage | Target |
|-------|--------|
| Acknowledgement | ≤ 48 h |
| Initial assessment | ≤ 5 business days |
| Fix / mitigation | ≤ 30 days for critical, 90 days for others |
| Public disclosure | Coordinated with reporter |

---

## Security Architecture

ArcaP is designed as a **fully on-premise** platform — no data leaves your infrastructure:

- All LLM inference runs locally via **Ollama** (no cloud API calls)
- Vector search via **Qdrant** (local container)
- All credentials managed via `.env` (never committed — see `.gitignore`)
- See [`CREDENTIALS_STANDARDS.md`](CREDENTIALS_STANDARDS.md) for credential hygiene

### Default credentials (change before production)

| Service | Default user | Notes |
|---------|-------------|-------|
| Dremio | admin | Change immediately |
| Superset | admin / admin | Change immediately |
| MinIO | minioadmin | Change immediately |
| PostgreSQL | postgres | Change immediately |

---

## Security-Related Files

- [`CREDENTIALS_STANDARDS.md`](CREDENTIALS_STANDARDS.md) — credential handling policy
- [`SECURITY_SSH_KEY_CHECK.md`](SECURITY_SSH_KEY_CHECK.md) — SSH key verification
- [`SECURITY_VERIFICATION_SUMMARY.md`](SECURITY_VERIFICATION_SUMMARY.md) — verification log
- [`.env.example`](.env.example) — safe template with no real values

---

*ArcaP · [github.com/Monsau/ArcaP](https://github.com/Monsau/ArcaP) · [Talentys](https://talentys.eu)*
