output "function_url" {
  value = google_cloudfunctions2_function.function.service_config[0].uri
  description = "The HTTP trigger url for the function"
}

output "function_name" {
  value = google_cloudfunctions2_function.function.name
  description = "The name of the function"
}

output "function_location" {
  value = google_cloudfunctions2_function.function.location
  description = "The location (region) where the function was deployed"
}

output "function_project" {
  value = google_cloudfunctions2_function.function.project
  description = "The project in which the function was deployed"
}