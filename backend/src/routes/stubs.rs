use axum::{http::StatusCode, Json};
use serde::Serialize;

#[derive(Serialize)]
struct NotImplemented {
    error: &'static str,
    module: &'static str,
    lands_in: &'static str,
}

fn not_implemented(module: &'static str, lands_in: &'static str) -> (StatusCode, Json<NotImplemented>) {
    (
        StatusCode::NOT_IMPLEMENTED,
        Json(NotImplemented {
            error: "not_implemented",
            module,
            lands_in,
        }),
    )
}

/// Module 2 (Credential Issuance) — university issuer API.
pub async fn issuance() -> impl axum::response::IntoResponse {
    not_implemented("credential-issuance", "phase-2")
}

/// Modules 5-6 (Proof Generator / Recursive Aggregation) — proof job coordination.
pub async fn proofs() -> impl axum::response::IntoResponse {
    not_implemented("proof-coordination", "phase-3")
}

/// Modules 7-9 (Recruitment / Scholarship / Visa portals) — criteria publishing.
pub async fn portals() -> impl axum::response::IntoResponse {
    not_implemented("portal-criteria", "phase-5")
}

/// Module 10 (Revocation) — revocation notifications to verifiers.
pub async fn revocation() -> impl axum::response::IntoResponse {
    not_implemented("revocation-notifications", "phase-8")
}
