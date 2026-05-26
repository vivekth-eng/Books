ROLE: Project Manager
COMMAND: /pm [Action: fix / execute / propose / audit]

CONTEXT:

- Handover Protocol: Section 10 (Global) is ACTIVE.
- Sprint Status: [e.g., Sprint v1.3 Phase 0].
- Environment: Flutter Web (Chrome), Supabase Backend, Riverpod State.
- Key Reference: .agent/context/inventory.md & variables.md.

OBJECTIVES:

1. [Primary Goal: e.g., Implement Drag-and-Drop Ordering].
2. [Secondary Goal: e.g., Optimize Provider rebuilds].

CONSTRAINTS & GUARDRAILS:

- No "Hallucinated" Imports: Verify all file paths before adding imports.
- Zero-Inference: Use UUIDs from variables.md, not hardcoded strings.
- UI Consistency: Maintain Material 3 styling and existing typography.

INSTRUCTIONS:

1. ORCHESTRATE [Agent Name]: [Specific task for that agent].
2. VALIDATION: Check for [Common Errors, e.g., compilation issues].
3. DOCUMENTATION: Update [File Name] with any new changes.

COMPLIANCE:

- Apply Phase 4 Mandatory Output Requirements.
- End with a copy-pasteable 🚀 NEXT STEP prompt for the [Next Agent].

GO: "[Direct, clear command to start the work]"

---

ROLE: Project Manager
COMMAND: /pm fix [PROVIDER_IMPORT_DRIFT]

CONTEXT:

- Handover Protocol: Section 10 (Global) is ACTIVE.
- Issue: 'todoFilterProvider' is undefined in 'todo_providers.dart'.
- Environment: Flutter Web (Chrome).

INSTRUCTIONS:

1. ORCHESTRATE BUILDER: Locate 'todo_filter_provider.dart' and import it into 'todo_providers.dart'.
2. VALIDATION: Ensure no circular dependencies are created between the two files.
3. COMPLIANCE: Adhere to Phase 4. Provide the 🚀 NEXT STEP prompt for the Tester.

GO: "Fix the undefined provider reference and restore build integrity."

---

ROLE: Project Manager
COMMAND: /pm execute [COMPLETED_TASKS_UI_SECTION]

CONTEXT:

- Handover Protocol: Section 10 (Global) is ACTIVE.
- Sprint: v1.3 Complex Ordering.
- Key Reference: .agent/context/variables.md.

INSTRUCTIONS:

1. ORCHESTRATE BUILDER: Create a collapsible 'ListView' header named "Completed Tasks" at the bottom of the main task screen.
2. STATE SYNC: Use 'ref.watch' to ensure tasks move into this section the moment 'is_completed' becomes true.
3. UI FIDELITY: Maintain Material 3 styling with a subtle grey-out effect for completed text.
4. COMPLIANCE: Provide the copy-pasteable prompt for the BUILDER.

GO: "Implement the Completed Tasks archive section logic and UI."

---

ROLE: Project Manager
COMMAND: /pm propose [DRAG_AND_DROP_STRATEGY]

CONTEXT:

- Handover Protocol: Section 10 (Global) is ACTIVE.
- Constraint: READ-ONLY. Do not modify any files.
- Requirement: We need a way to manually reorder tasks.

INSTRUCTIONS:

1. ANALYSIS: Evaluate if we should use 'ReorderableListView' vs. a third-party package for Chrome compatibility.
2. DATA DESIGN: Propose the SQL schema change (e.g., adding a 'position' float column) to the 'todos' table.
3. RECOMMENDATIONS: Provide a "Pros/Cons" list for the proposed implementation.
4. COMPLIANCE: Provide a 🚀 NEXT STEP prompt for me to "Accept" or "Reject" the proposal.

GO: "Propose a robust architecture for task reordering on Flutter Web."

---

ROLE: Project Manager
COMMAND: /pm audit [REPOSITORY_SECURITY_CHECK]

CONTEXT:

- Handover Protocol: Section 10 (Global) is ACTIVE.
- Scope: .agent/rules/monitoring_policy.md and todo_repository.dart.

INSTRUCTIONS:

1. SECURITY SCAN: Verify that the 'SERVICE_ROLE_KEY' is only used for destructive 'delete' operations and not for standard fetches.
2. RULE COMPLIANCE: Check if the 'TodoRepository' follows the 'operational_standards.md' for error handling.
3. OPTIMIZATION: Identify any redundant 'print' statements that should be removed for the production build.
4. COMPLIANCE: Provide a "Compliance Report" and a 🚀 NEXT STEP for cleanup.

GO: "Perform a security and standards audit of the data layer."

---
