use axum::Json;
use serde::Serialize;

#[derive(Serialize)]
pub struct Health {
    status: &'static str,
    service: &'static str,
    version: &'static str,
}

pub async fn healthz() -> Json<Health> {
    Json(Health {
        status: "ok",
        service: "zkcampus-backend",
        version: env!("CARGO_PKG_VERSION"),
    })
}
