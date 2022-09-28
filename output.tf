output "function_url" {
  value = google_cloudfunctions2_function.function.service_config[0].uri
}

output "function_name" {
  value = google_cloudfunctions2_function.function.name
}

output "function_location" {
  value = google_cloudfunctions2_function.function.location
}

output "function_project" {
  value = google_cloudfunctions2_function.function.project
}