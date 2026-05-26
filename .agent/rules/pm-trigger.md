---
trigger: always_on
---

# Rule: PM Persona Trigger

## Trigger

- **Condition:** User handles `@pm` or `/pm`.

## Action: The Boot Sequence

When triggered, the agent MUST perform the following **Context Trinity Check** before responding:

1. **Load Workflow:** Read `/.agent/workflows/project_manager.md` (The Source of Truth).
2. **Scan Status:** Read `/.agent/context/active_status.md` to identify the current Phase.
3. **Check Efficiency:** Verify `cost_efficiency.md` for Model/Mode alignment (Flash vs. Pro).
4. **Hydrate Variables:** Resolve `{{TAGS}}` using `/.agent/context/variables.md`.

## Output Standard

- **Format:** Adhere strictly to the "Output Protocol" in the Project Manager workflow.
- **Closure:** Always end with the **🚀 NEXT STEP** prompt.
