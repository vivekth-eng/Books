# Blueprint: Master Credential Policy

## 1. Zero-Hardcoding Mandate
- **Rule**: API keys, Database passwords, and JWT secrets MUST NEVER be hardcoded in source files.
- **Enforcement**: Git hooks (if available) or static analysis shall flag potential leaks.

## 2. Standardized Environment
- **Storage**: All projects must use a `.env` file at the project root.
- **Variable Name**: The primary Google AI key MUST be named `GOOGLE_API_KEY`.
- **Loading**:
  ```python
  from dotenv import load_dotenv
  load_dotenv()
  api_key = os.getenv("GOOGLE_API_KEY")
  ```

## 3. Deployment Security
- **Native Stack**: Ensure the `.venv` and `backend/` directories do not inadvertently expose `.env` to public access or unauthorized users on the local machine.

⚓
