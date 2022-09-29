terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}
data "archive_file" "source" {
  output_path = "${path.module}/${var.function_name}.zip"
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

resource "google_service_account" "sa" {
  account_id = "${var.function_name}-sa"
}

resource "google_project_iam_member" "sa-roles" {
  project = var.project_id
  for_each = toset(var.roles)
  role = each.key
  member = "serviceAccount:${google_service_account.sa.email}"
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
    ingress_settings = var.ingress_settings
    vpc_connector = var.vpc_connector
    vpc_connector_egress_settings = var.vpc_connector_egress_settings
    service_account_email = google_service_account.sa.email
  }
}

data "google_iam_policy" "invoker" {
  binding {
    role = "roles/run.invoker"
    members = var.invokers
  }
}

resource "google_cloud_run_service_iam_policy" "policy" {
  project = google_cloudfunctions2_function.function.project
  location = google_cloudfunctions2_function.function.location
  service = google_cloudfunctions2_function.function.name
  policy_data = data.google_iam_policy.invoker.policy_data
}