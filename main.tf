terraform {
  required_providers {
    google = {
      source = "hashicorp/google-beta"
    }
  }
}
data "archive_file" "source" {
  output_path = "/tmp/${var.function_name}.zip"
  type        = "zip"
  source_dir = var.function_path
}

resource "google_storage_bucket" "function_bucket" {
 location = var.region
  name = "${var.project_id}-${var.function_name}"
}

resource "google_storage_bucket_object" "zip" {
  name = "${data.archive_file.source.output_md5}.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = data.archive_file.source.output_path
}

resource "google_cloudfunctions2_function" "function" {

  name = var.function_name
  location = var.region

  build_config {
    runtime = var.runtime

    entry_point = var.entry_point
    source {
      storage_source {
        bucket = google_storage_bucket.function_bucket.name
        object = google_storage_bucket_object.zip.name
      }
    }
  }

  service_config {
    min_instance_count = var.min_instance_count
    max_instance_count = var.max_instance_count
    timeout_seconds = var.timeout_seconds
    available_memory = var.available_memory
    all_traffic_on_latest_revision = var.all_traffic_on_latest_revision
    environment_variables = var.environment_variables
  }
}