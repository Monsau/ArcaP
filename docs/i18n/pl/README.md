# Platforma danych

**Rozwiązanie typu Lakehouse dla przedsiębiorstw**

**Język**: francuski (FR)  
**Wersja**: 3.3.1  
**Ostatnia aktualizacja**: 19 października 2025 r

---

## Przegląd

Profesjonalna platforma danych łącząca Dremio, dbt i Apache Superset do transformacji danych klasy korporacyjnej, zapewniania jakości i analityki biznesowej.

Platforma ta zapewnia kompletne rozwiązanie dla nowoczesnej inżynierii danych, obejmujące zautomatyzowane potoki danych, testy jakości i interaktywne dashboardy.

§§§KOD_0§§§

---

## Kluczowe funkcje

- Architektura Data Lakehouse z Dremio
- Automatyczne transformacje za pomocą dbt
- Inteligencja biznesowa z Apache Superset
- Kompleksowe testowanie jakości danych
- Synchronizacja w czasie rzeczywistym za pośrednictwem Arrow Flight

---

## Skrócona instrukcja obsługi

### Warunki wstępne

- Docker 20.10 lub nowszy
- Docker Compose 2.0 lub nowszy
- Python 3.11 lub nowszy
- Minimum 8 GB pamięci RAM

### Obiekt

§§§KOD_1§§§

---

## Architektura

### Komponenty systemu

| Składnik | Port | Opis |
|--------------|------|------------|
| Dremio | 9047, 31010, 32010 | Platforma danych nad jeziorem |
| db | - | Narzędzie do transformacji danych |
| Nadzbiór | 8088 | Platforma analityki biznesowej |
| PostgreSQL | 5432 | Baza transakcyjna |
| MinIO | 9000, 9001 | Pamięć obiektów (kompatybilna z S3) |
| Elastyczne wyszukiwanie | 9200 | Silnik wyszukiwania i analiz |

Zobacz [dokumentację architektury](architektura/), aby zapoznać się ze szczegółowym projektem systemu.

---

## Dokumentacja

### Uruchamianie
- [Instrukcja instalacji] (wprowadzenie/)
- [Konfiguracja] (wprowadzenie/)
- [Pierwsze kroki] (pierwsze kroki/)

### Podręczniki użytkownika
- [Inżynieria danych](przewodniki/)
- [Tworzenie dashboardów](przewodniki/)
- [Integracja API](przewodniki/)

### Dokumentacja API
- [Odniesienie do API REST](api/)
- [Uwierzytelnianie](api/)
- [Przykłady kodu](api/)

### Dokumentacja architektury
- [Projekt systemu](architektura/)
- [Przepływ danych](architektura/)
- [Przewodnik po wdrażaniu](architektura/)
- [🎯 Wizualny przewodnik po portach Dremio](architektura/dremio-ports-visual.md) ⭐ NOWOŚĆ

---

## Dostępne języki

| Język | Kod | Dokumentacja |
|------------|------|--------------|
| Angielski | PL | [README.md](../../../README.md) |
| Francuski | PL | [docs/i18n/fr/](../fr/README.md) |
| hiszpański | ES | [docs/i18n/es/](../es/README.md) |
| portugalski | PT | [docs/i18n/pt/](../pt/README.md) |
| العربية | AR | [docs/i18n/ar/](../ar/README.md) |
| 中文 | CN | [docs/i18n/cn/](../cn/README.md) |
| 日本語 | JP | [docs/i18n/jp/](../jp/README.md) |
| Rosyjski | Wielka Brytania | [docs/i18n/ru/](../ru/README.md) |

---

## Wsparcie

Pomoc techniczna:
- Dokumentacja: [README główny](../../../README.md)
- Śledzenie problemów: problemy z GitHubem
- Forum społeczności: dyskusje na GitHubie
- E-mail: support@example.com

---

**[Powrót do głównej dokumentacji](../../../README.md)**