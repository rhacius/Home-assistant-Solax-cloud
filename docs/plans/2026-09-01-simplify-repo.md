# Repository Simplification Plan

> **For Hermes:** Execute the tasks in order and verify the final diff without committing.

**Goal:** Remove the over-engineered and demonstrably unused repository surface found by the Ponytail audit.

**Architecture:** Keep the Home Assistant integration entry points, coordinator, sensor descriptions, manifest, HACS metadata, and required runtime dependency unchanged. Delete only unreferenced scaffolding and the unsupported standalone diagnostic script; replace the generic ignore template with a small repository-specific list.

**Tech Stack:** Python/Home Assistant custom integration, Voluptuous config flow, HACS metadata, GitHub Actions.

---

### Task 1: Replace the generic ignore template

**Objective:** Keep only local Python/cache/environment artifacts relevant to this repository.

**Files:**
- Modify: `.gitignore`

**Steps:**
1. Retain patterns for Python bytecode, virtual environments, local `.env`, test cache, coverage, and editor state.
2. Remove framework-specific sections for Django, Flask, Scrapy, Sphinx, Jupyter, Celery, SageMath, PyBuilder, and unused packaging tools.
3. Verify the file contains no patterns tied to tools absent from the tracked tree.

### Task 2: Remove unreferenced repository surface

**Objective:** Delete code and metadata with no in-repository consumer.

**Files:**
- Delete: `query_solax.sh`
- Modify: `custom_components/solax_cloud/const.py`
- Modify: `custom_components/solax_cloud/sensor.py`
- Modify: `custom_components/solax_cloud/strings.json`

**Steps:**
1. Confirm `query_solax.sh` has no README, workflow, manifest, or source reference, then delete it.
2. Remove `DEFAULT_NAME`, `ISSUE_PLACEHOLDER`, and the commented debug print.
3. Remove the unused `invalid_auth` and `unknown` config-flow translation entries.
4. Do not alter Home Assistant lifecycle callbacks or sensor behavior.

### Task 3: Remove redundant text-selector configuration

**Objective:** Use the native default text selector instead of explicitly encoding its default type twice.

**Files:**
- Modify: `custom_components/solax_cloud/config_flow.py:12-16,61-64`

**Steps:**
1. Replace both configured selectors with `TextSelector()`.
2. Remove `TextSelectorConfig` and `TextSelectorType` imports.
3. Preserve the existing required fields and suggested default values.

### Task 4: Verify the cleanup

**Objective:** Prove the cleanup is syntactically valid and does not introduce unrelated changes.

**Commands:**
- `ruff check .`
- Parse all tracked Python files with `ast.parse`.
- Parse `manifest.json`, `strings.json`, and `hacs.json` as JSON.
- `git diff --check`
- `git status --short --untracked-files=all`

**Expected:** Lint and parsing pass; no tracked tests exist; only the planned files change; no unused dependency is removed because `solaxcloud` remains used by the integration.
