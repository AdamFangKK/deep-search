# Evaluation Schemas

Reference documentation for evaluation JSON structures.

## evals.json Schema

```json
{
  "skill_name": "string",
  "description": "string",
  "version": "string",
  "evals": [
    {
      "id": "number",
      "name": "string (kebab-case)",
      "prompt": "string (user task)",
      "expected_output": "string (description)",
      "assertions": ["string array"],
      "category": "string"
    }
  ]
}
```

## eval_metadata.json Schema

```json
{
  "eval_id": "number",
  "eval_name": "string",
  "prompt": "string",
  "assertions": [
    {
      "name": "string",
      "description": "string",
      "check": "string (how to verify)"
    }
  ]
}
```

## grading.json Schema

```json
{
  "eval_id": "number",
  "run_id": "string",
  "assertions": [
    {
      "text": "string",
      "passed": "boolean",
      "evidence": "string"
    }
  ],
  "overall_pass": "boolean",
  "notes": "string"
}
```

## benchmark.json Schema

```json
{
  "skill_name": "string",
  "iteration": "number",
  "timestamp": "ISO-8601",
  "results": [
    {
      "config": "with_skill|without_skill",
      "pass_rate": "number (0-1)",
      "avg_time_ms": "number",
      "avg_tokens": "number",
      "stddev_time": "number",
      "stddev_tokens": "number"
    }
  ]
}
```

## timing.json Schema

```json
{
  "total_tokens": "number",
  "duration_ms": "number",
  "total_duration_seconds": "number"
}
```
