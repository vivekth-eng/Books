# Blueprint: Archival & Decommissioning Standards

## 1. The Decommissioning Checklist
Before a project is marked as "Archived," the following must be verified:

- [ ] **Git Alignment**: Current branch is `main` and all commits are pushed.
- [ ] **Documentation**: `README_ARCHIVE.md` exists with restoration instructions.
- [ ] **Environment Export**: `.tar` images for Backend and DB are generated.
- [ ] **Data Integrity**: `pgdata` volume is backed up and verified.
- [ ] **Asset Backup**: High-res posters or source files are included in the archive.

## 2. External Drive Integrity
Archival is not complete until the backup is validated.
- **Verification**: Run `tar -tvf <backend.tar>` to ensure the file is not corrupted.
- **Redundancy**: Critical data (embeddings/DB dump) should exist in both `.tar` and a raw `.sql` or `.zip` format.

## 3. VHDX Compaction Requirement
For Windows-based long-term development:
- **Requirement**: Once a project is archived and Docker artifacts pruned, the associated `ext4.vhdx` must be compacted using `diskpart`.
- **Guidance**: Refer to `ssd_reclamation_deep_clean.md` for exact commands.

---
*Created: March 2026*
