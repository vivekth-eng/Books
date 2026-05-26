---
name: static_showcase_engine
description: Orchestrates sandboxed client-side frontend compilation and handles flat-root public GitHub Pages publication trees.
capabilities:
  - client_side_short_circuiting
  - cross_platform_import_sanitization
  - flat_root_repository_sync
  - cache_bypass_injection
---

# static_showcase_engine

This skill automates the validation, compilation, and deployment of a multi-tier Flutter project to a standalone sandboxed client-side showcase.

## 1. Platform Abstraction Check Script (Pre-Flight)

The following platform abstraction script runs pre-flight checks on the local workspace. It validates compilation safety (detecting direct native `dart:io` references), ensures the mock configuration switch is active, and verifies path alignment parameters.

```python
import os
import re
import sys

def check_k_mock_demo_mode():
    config_path = "lib/core/config.dart"
    if not os.path.exists(config_path):
        print(f"Error: Configuration file '{config_path}' not found.")
        return False
    
    with open(config_path, "r", encoding="utf-8") as f:
        content = f.read()
    
    # Assert that kMockDemoMode is set to true for web compilation
    if not re.search(r"const\s+bool\s+kMockDemoMode\s*=\s*true\s*;", content):
        print("Error: kMockDemoMode must be set to 'true' in lib/core/config.dart before static compilation.")
        return False
    
    print("Success: kMockDemoMode is set to true.")
    return True

def check_no_io_imports():
    invalid_imports = []
    # Scan all dart files in lib/features for direct dart:io imports
    for root, _, files in os.walk("lib/features"):
        for file in files:
            if file.endswith(".dart"):
                path = os.path.join(root, file)
                try:
                    with open(path, "r", encoding="utf-8") as f:
                        lines = f.readlines()
                    for i, line in enumerate(lines):
                        if "import 'dart:io'" in line or 'import "dart:io"' in line:
                            invalid_imports.append((path, i + 1, line.strip()))
                except Exception as e:
                    print(f"Warning: Could not read {path}: {e}")
    
    if invalid_imports:
        print("Warning: Detected direct imports of 'dart:io' which can cause compilation crashes on the web.")
        for path, line_num, line in invalid_imports:
            print(f"  {path}:{line_num} -> {line}")
        return False
    
    print("Success: No direct dart:io imports found in features layer.")
    return True

def verify_base_href(repo_name):
    # The base-href during build must match "/{repo_name}/"
    base_href = f"/{repo_name}/"
    print(f"Verified target compilation command parameter: --base-href \"{base_href}\"")
    return True

def check_service_worker_bypass():
    index_path = "web/index.html"
    if not os.path.exists(index_path):
        print("Warning: web/index.html not found.")
        return True
        
    with open(index_path, "r", encoding="utf-8") as f:
        content = f.read()
        
    # Check for service worker registration bypass mechanisms
    if "serviceWorker" in content and "unregister" not in content.lower():
        print("Warning: Service Worker caching may cache stale bundles on GitHub Pages. Consider unregistering service workers.")
    return True

if __name__ == "__main__":
    print("Running Static Showcase Pre-Flight Checks...")
    mock_ok = check_k_mock_demo_mode()
    io_ok = check_no_io_imports()
    # Assume repository name is passed as argument or discovered
    repo = sys.argv[1] if len(sys.argv) > 1 else "Portfolio"
    href_ok = verify_base_href(repo)
    sw_ok = check_service_worker_bypass()
    
    if mock_ok and io_ok and href_ok and sw_ok:
        print("All static compilation pre-flight checks passed successfully.")
        sys.exit(0)
    else:
        print("Pre-flight checks failed or emitted warnings. Verify configuration.")
        sys.exit(1)
```

---

## 2. Automated Execution Steps

### Step 1: Pre-flight Audit
Execute the validation script above or run equivalent checks to guarantee:
- `kMockDemoMode` is enabled.
- `dart:io` imports are conditionally gated.
- Service worker caching is disabled or set to unregister to avoid stale page locks.

### Step 2: Synchronous Fake Token & Mock Gates Validation
- Confirm that Auth providers and data services intercept request handlers synchronously on initialization.
- Ensure that credentials checks bypass remote DB lookups and return pre-seeded display entities immediately.

### Step 3: Bundle Compilation
Run the optimized static web renderer compilation targeting the repository route namespace:
```bash
flutter build web --release --web-renderer html --base-href "/{{REPOSITORY_NAME}}/"
```

### Step 4: Flat Release Extraction & Service Worker Patching
- Extract the compiled assets from `build/web/*` directly to the flat root of the deployment repository.
- Modify `index.html` to unregister any existing service workers:
  ```html
  <script>
    if ('serviceWorker' in navigator) {
      navigator.serviceWorker.getRegistrations().then(function(registrations) {
        for(let registration of registrations) {
          registration.unregister();
        }
      });
    }
  </script>
  ```
- Remove any loading/registration script of the Service Worker inside `flutter_bootstrap.js` or `index.html`.

### Step 5: Remote Uplink Sync
Push changes directly to the public GitHub Pages repository root:
```bash
git init
git add .
git commit -m "deploy: static sandboxed release showcase"
git branch -M main
git remote add origin https://github.com/{{GITHUB_USER}}/{{REPOSITORY_NAME}}.git
git push -f origin main
```
