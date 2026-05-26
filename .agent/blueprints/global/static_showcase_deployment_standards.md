# Global Blueprint: Static Frontend Showcase Deployment Standards

## 1. Core Philosophy

When migrating a native, multi-tier, data-driven system (e.g., Flutter + FastAPI + PostgreSQL) into an open-source public demonstration platform (e.g., GitHub Pages), the application MUST transition from a server-dependent layout to a completely isolated, 100% Client-Side Static Sandbox. Under no circumstances may a public showcase make outbound requests to a localized loopback address (`127.0.0.1`) or expect a live database engine to be active on the host CDN container.

---

## 2. Identified Bottlenecks & Strategic Mitigations

### 🛑 Bottleneck A: The Platform Compilation Crash (Blank Screens)
* **The Cause:** Compiling code containing imports of native operating system file handles (like `dart:io`) causes deep engine initialization exceptions when executed inside an engine sandbox like a web browser.
* **The Rule:** Sub-agents must decouple all file system readers. Native platform libraries must be safely abstracted behind conditional, cross-platform compilation interfaces or wrappers (e.g., using explicit conditional compilation files or `universal_html`).

### 🛑 Bottleneck B: The Asynchronous Initialization Trap (Infinite Spinners)
* **The Cause:** State management networks (such as Riverpod or Bloc Providers) utilizing initialization hooks (`Future`, `await`) that look for remote network parameters, api heartbeats, or server storage configurations will wait indefinitely on static servers, locking the application interface inside a loading visual.
* **The Rule:** When showcase demo mode is flagged (`kMockDemoMode = true`), all data endpoints and providers MUST immediately bypass async connection configurations and serve pre-seeded memory maps *synchronously* or via a pre-resolved `Future.value()`.

### 🛑 Bottleneck C: Repository Root Path Alignment (Blank Assets)
* **The Cause:** GitHub Pages looks for entry assets (`index.html`) at the specified target branch root. Pushing an entire project workspace hides the compiled release components down deep folders (like `build/web/`), causing path discovery failure.
* **The Rule:** Compilation workflows must perform flat-file deployment. The absolute contents of the release distribution bundle folder (`build/web/*`) must be stripped out and pushed directly to the absolute **Root Tier** of the target remote showcase repository.

---

## 3. Mandatory User Inputs (The Developer Checklist)

To completely automate the sandbox compilation sequence without failure, the user MUST supply these explicit configuration tokens upon initialization:

1. **`MOCK_USER_EMAIL`**: The explicit test profile identity (e.g., `test000@example.com`) that the authentication provider will lock onto automatically.
2. **`MOCK_USER_PASSWORD`**: The accompanying display credentials to authenticate local navigation panels.
3. **`REPOSITORY_NAME`**: The target identifier for remote web path matching (e.g., `Portfolio`).
4. **`BASE_HREF`**: The absolute path string parameter used for routing asset mappings. Must be formatted string: `"/[RepositoryName]/"`.

---

## 4. Standalone Sandbox Core Guardrails (SEBI & Multi-Tenancy)

To maintain mathematical and structural integrity without database/API connectivity:

### A. SEBI Asset Classification & Financial Metrics Standardization
- **Uniform Mappings**: Client-side state engines must enforce strict SEBI categorizations (e.g., Large Cap, Mid Cap, Small Cap, Hybrid Multi-Asset, Flexi-Cap) on all in-memory assets.
- **Precision Auditing**: All valuation aggregations (Current Value, Principal Invested, Gains/Losses) must be calculated dynamically or mapped with exact double precision to prevent floating-point drift (> 1e-6) on the web runtime.
- **Financial Metric Proxies**: In-memory calculations for absolute return percentage, CAGR, and XIRR proxies must apply divide-by-zero safeguards and type coercions:
  ```dart
  final gainLossPct = totalInvested > 0 ? (gainLoss / totalInvested) * 100 : 0.0;
  ```

### B. Multi-Tenant Data Isolation
- **Tenant Scope Isolation**: The mock authentication layer must bind the active showcase user to a specific, unique `userId` and `email` context.
- **State Partitioning**: All state updates (e.g., settings edits, logged dividends, or uploaded CSV files) must reside within scoped memory providers that do not bleed data into other mock identities.
- **Database Decoupling**: If an action is fired, the logic must instantly update the local state provider memory and short-circuit any remote REST client network tasks.

---

## 5. Execution Workflow Steps

1. **Isolate & Toggle:** Validate the global application configuration file to check that `kMockDemoMode` is active.
2. **Short-Circuit Providers:** Enforce synchronous variable loops inside all state models to completely bypass server endpoints.
3. **Compile for Target Distribution:** Trigger compilation paths targeting cross-platform engines using discrete HTML/Canvas graphic renderer values.
4. **Flat Staging:** Relocate compiled release assets up to an independent, clean directory node.
5. **Push and Publish:** Initialize Git inside the target release folder and execute a forced uplink stream straight to the public remote repository root layer.
