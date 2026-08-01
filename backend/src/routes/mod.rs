mod health;
mod stubs;

use axum::{routing::get, Router};

pub fn router() -> Router {
    Router::new()
        .route("/healthz", get(health::healthz))
        .route("/v1/issuance", get(stubs::issuance))
        .route("/v1/proofs", get(stubs::proofs))
        .route("/v1/portals", get(stubs::portals))
        .route("/v1/revocation", get(stubs::revocation))
}

#[cfg(test)]
mod tests {
    use super::*;
    use axum::body::Body;
    use axum::http::{Request, StatusCode};
    use tower::ServiceExt;

    #[tokio::test]
    async fn healthz_returns_ok() {
        let response = router()
            .oneshot(Request::builder().uri("/healthz").body(Body::empty()).unwrap())
            .await
            .unwrap();

        assert_eq!(response.status(), StatusCode::OK);
    }

    #[tokio::test]
    async fn stub_routes_return_not_implemented() {
        for path in ["/v1/issuance", "/v1/proofs", "/v1/portals", "/v1/revocation"] {
            let response = router()
                .oneshot(Request::builder().uri(path).body(Body::empty()).unwrap())
                .await
                .unwrap();

            assert_eq!(response.status(), StatusCode::NOT_IMPLEMENTED, "path: {path}");
        }
    }
}
