resource "kubernetes_namespace" "jx-namespace" {
  depends_on = [google_container_node_pool.primary_preemptible_nodes]
  metadata {
    name = "jx"
  }

  lifecycle {
    ignore_changes = [metadata[0].labels, metadata[0].annotations]
  }
}

resource "kubernetes_secret" "kaniko-secret" {
  depends_on = [kubernetes_namespace.jx-namespace]
  metadata {
    name      = "kaniko-secret"
    namespace = "jx"
  }

  data = {
    "kaniko-secret" = base64decode(google_service_account_key.kaniko-sa-key.private_key)
  }
}

resource "google_storage_bucket" "lts-bucket" {
  name     = "${google_container_cluster.dev_cluster.name}-lts"
  location = "US"
}

resource "kubernetes_secret" "external-dns-gcp-sa" {
  depends_on = [kubernetes_namespace.jx-namespace]
  metadata {
    name      = "external-dns-gcp-sa"
    namespace = "jx"
  }
  data = {
    "credentials.json" = base64decode(google_service_account_key.external-dns-gcp-sa-key.private_key)
  }
}