"""
OOC-Guard API — Ontology Operations Contract Validator
Exposes the three-layer OOC-Guard pipeline (Syntax → Semantic → SHACL)
as a REST API for the ArcaP Data Platform.
"""

from __future__ import annotations

import json
import tempfile
from pathlib import Path
from typing import Any, Dict, Optional

import yaml
from fastapi import FastAPI, File, Form, HTTPException, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from ooc_guard.validator import validate
from ooc_guard.models.report import OverallStatus

app = FastAPI(
    title="OOC-Guard API",
    description=(
        "The Logic Firewall for Industry 4.0 Ontologies. "
        "Three-layer OOC validation: Syntax (Pydantic) → Semantic (OWL 2) → SHACL."
    ),
    version="0.1.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ─── Request / Response models ────────────────────────────────────────────────

class ValidateBodyRequest(BaseModel):
    """Validate an OOC document supplied as a raw JSON/dict body."""
    contract: Dict[str, Any]
    layer: str = "all"
    reasoner: str = "hermit"
    strict: bool = False


class ValidationSummary(BaseModel):
    contract_id: str
    contract_version: str
    overall_status: str
    layers: Dict[str, Any]
    passed: bool


# ─── Helpers ─────────────────────────────────────────────────────────────────

def _report_to_dict(report) -> Dict[str, Any]:
    """Serialize a ValidationReport to a plain dict."""
    return report.model_dump(mode="json")


def _validate_from_dict(
    raw: Dict[str, Any],
    layer: str,
    reasoner: str,
    strict: bool,
    data_graph_path: Optional[str] = None,
) -> Dict[str, Any]:
    """Write raw dict to a temp YAML, run ooc_guard.validate, return report dict."""
    with tempfile.NamedTemporaryFile(
        suffix=".yaml", mode="w", delete=False, encoding="utf-8"
    ) as fh:
        yaml.dump(raw, fh, allow_unicode=True)
        tmp_path = fh.name

    try:
        report = validate(
            tmp_path,
            layer=layer,
            data_graph=data_graph_path,
            reasoner=reasoner,
            strict=strict,
        )
        return _report_to_dict(report)
    finally:
        Path(tmp_path).unlink(missing_ok=True)


# ─── Endpoints ────────────────────────────────────────────────────────────────

@app.get("/")
def root():
    return {
        "service": "OOC-Guard API",
        "version": "0.1.0",
        "description": "Logic Firewall for Industry 4.0 Ontologies (OLM / ArcaP)",
        "layers": ["syntax", "semantic", "shacl"],
        "endpoints": [
            "POST /validate          — full pipeline (file upload)",
            "POST /validate/body     — full pipeline (JSON body)",
            "POST /validate/syntax   — syntax layer only",
            "POST /validate/semantic — semantic layer only",
            "POST /validate/shacl    — SHACL layer only",
            "GET  /health",
        ],
    }


@app.get("/health")
def health():
    return {"status": "healthy", "service": "ooc-guard", "version": "0.1.0"}


@app.post("/validate")
async def validate_file(
    file: UploadFile = File(..., description="OOC contract YAML or JSON file"),
    layer: str = Form("all"),
    reasoner: str = Form("hermit"),
    strict: bool = Form(False),
    data_graph: Optional[UploadFile] = File(None, description="RDF data graph for SHACL layer"),
):
    """
    Full three-layer validation from a file upload.
    Accepts YAML or JSON OOC contract files.
    Optionally accepts an RDF data graph file for the SHACL layer.
    """
    content = await file.read()

    # Parse YAML or JSON
    try:
        if file.filename.endswith((".yaml", ".yml")):
            raw = yaml.safe_load(content.decode("utf-8"))
        else:
            raw = json.loads(content.decode("utf-8"))
    except Exception as exc:
        raise HTTPException(status_code=400, detail=f"Failed to parse contract file: {exc}")

    # Handle optional data graph upload
    data_graph_path = None
    if data_graph is not None:
        dg_bytes = await data_graph.read()
        with tempfile.NamedTemporaryFile(
            suffix=Path(data_graph.filename).suffix or ".ttl",
            delete=False,
        ) as fh:
            fh.write(dg_bytes)
            data_graph_path = fh.name

    try:
        result = _validate_from_dict(
            raw,
            layer=layer,
            reasoner=reasoner,
            strict=strict,
            data_graph_path=data_graph_path,
        )
    finally:
        if data_graph_path:
            Path(data_graph_path).unlink(missing_ok=True)

    result["passed"] = result.get("overall_status") == OverallStatus.PASSED.value
    return result


@app.post("/validate/body")
def validate_body(request: ValidateBodyRequest):
    """
    Full three-layer validation from a JSON body.
    Useful for programmatic use — paste the OOC contract as a dict.
    """
    try:
        result = _validate_from_dict(
            request.contract,
            layer=request.layer,
            reasoner=request.reasoner,
            strict=request.strict,
        )
    except Exception as exc:
        raise HTTPException(status_code=422, detail=f"Validation error: {exc}")
    result["passed"] = result.get("overall_status") == OverallStatus.PASSED.value
    return result


@app.post("/validate/syntax")
async def validate_syntax_only(
    file: UploadFile = File(...),
):
    """Syntax layer only — Pydantic structural validation of the OOC document."""
    content = await file.read()
    try:
        raw = yaml.safe_load(content.decode("utf-8")) if file.filename.endswith((".yaml", ".yml")) else json.loads(content.decode("utf-8"))
    except Exception as exc:
        raise HTTPException(status_code=400, detail=f"Parse error: {exc}")

    result = _validate_from_dict(raw, layer="syntax", reasoner="rdflib", strict=False)
    result["passed"] = result.get("overall_status") == OverallStatus.PASSED.value
    return result


@app.post("/validate/semantic")
async def validate_semantic_only(
    file: UploadFile = File(...),
    reasoner: str = Form("hermit"),
):
    """Semantic layer only — OWL 2 satisfiability and consistency check."""
    content = await file.read()
    try:
        raw = yaml.safe_load(content.decode("utf-8")) if file.filename.endswith((".yaml", ".yml")) else json.loads(content.decode("utf-8"))
    except Exception as exc:
        raise HTTPException(status_code=400, detail=f"Parse error: {exc}")

    result = _validate_from_dict(raw, layer="semantic", reasoner=reasoner, strict=False)
    result["passed"] = result.get("overall_status") == OverallStatus.PASSED.value
    return result


@app.post("/validate/shacl")
async def validate_shacl_only(
    file: UploadFile = File(...),
    strict: bool = Form(False),
    data_graph: Optional[UploadFile] = File(None),
):
    """SHACL layer only — shape constraints validation against optional data graph."""
    content = await file.read()
    try:
        raw = yaml.safe_load(content.decode("utf-8")) if file.filename.endswith((".yaml", ".yml")) else json.loads(content.decode("utf-8"))
    except Exception as exc:
        raise HTTPException(status_code=400, detail=f"Parse error: {exc}")

    data_graph_path = None
    if data_graph is not None:
        dg_bytes = await data_graph.read()
        with tempfile.NamedTemporaryFile(
            suffix=Path(data_graph.filename).suffix or ".ttl", delete=False
        ) as fh:
            fh.write(dg_bytes)
            data_graph_path = fh.name

    try:
        result = _validate_from_dict(
            raw, layer="shacl", reasoner="rdflib", strict=strict,
            data_graph_path=data_graph_path
        )
    finally:
        if data_graph_path:
            Path(data_graph_path).unlink(missing_ok=True)

    result["passed"] = result.get("overall_status") == OverallStatus.PASSED.value
    return result


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8003)
