resource "google_storage_bucket" "hello_gcp" {
  name     = "evoteum-hello-gcp-bucket-huzzah"
  location = "europe-west2"
  uniform_bucket_level_access = true
}