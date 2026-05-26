# 🏗️ Blueprint: System Portability (Git Integrity)

> **"The Golden Rule"**:
> *Always merge active feature branches into a stable branch (`main`/`stable`) and push to origin before switching hardware or performing system migrations.*

## 📌 1. Objective
To prevent "Version Drift" (unmerged local commits lost between devices) and ensure the 3-Tier stack (Flutter, FastAPI, Postgres) remains synchronized across development environments.

---

## 🛰️ 2. The "Retrieve Protocol" (New Machine Setup)

Follow these steps exactly when cloning the repository to a new machine:

1. **Clone & Setup**:
   ```powershell
   git clone [url]
   cd movie_database
   ```

2. **Fetch all remote state**:
   ```powershell
   git fetch --all
   ```

3. **Switch to stable**:
   ```powershell
   git checkout stable
   ```

4. **Consolidate Latest Logic**:
   Merge feature branches to ensure no logic was left behind:
   ```powershell
   git merge origin/features/*
   ```

---

## 🤝 3. Handshake Verification (Post-Retrieve)

Code is only considered "Latest" and "Safe" if it passes the following **3-Tier Integrity Checks** on the new hardware:

### Tier 1: Frontend (Flutter)
- [ ] `flutter pub get`
- [ ] `dart run build_runner build --delete-conflicting-outputs`
- [ ] `flutter analyze` (Zero errors)

### Tier 2: Logic (FastAPI/SQLModel)
- [ ] `pip install -r backend/requirements.txt`
- [ ] Verify `backend/models.py` matches current schema.

### Tier 3: Data (PostgreSQL/Alembic)
- [ ] Verify Native PostgreSQL 17 is running.
- [ ] `alembic upgrade head` (Verify database migration state).

---

## 🏛️ 4. Governance
Any agent session starting on a new machine MUST execute `git branch -a` and `git status` as the first step to confirm the working directory matches the intended blueprint state.
⚓
