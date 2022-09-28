variable "project_id" {
  type = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "The project_id must be a string of alphanumeric or hyphens, between 6 and 3o characters in length."
  }
  description = <<EOD
The GCP project identifier where the function will be created.
EOD
}

variable "function_path" {
  type = string
}

variable "runtime" {
  type = string
  # TODO: add validation from a list of choices
}

variable "region" {
  type = string
}

variable "min_instance_count" {
  type = number
  default = 0
}

variable "timeout_seconds" {
  type = number
  default = 60
}

variable "available_memory" {
  type = string
  default = "128Mi"
}

variable "all_traffic_on_latest_revision" {
  type = bool
  default = true
}

variable "entry_point" {
  type = string
}

variable "environment_variables" {
  type = map(string)
  default = {}
}

variable "max_instance_count" {
  type = number
  default = 1
}

variable "function_name" {
  type = string
  # TODO: add validation
  #validation {
   # condition     = can(regex("^[a-zA-Z0-9_-]{1,255}$", var.secret_id))
  #  error_message = "The function_name must be a string of alphanumeric, hyphen, and underscore characters, and upto 255 characters in length."
  #}
  description = <<EOD
The function name.
EOD
}

# TODO: add validation (starts with roles/)

variable "roles" {
  type = list(string)
  description = "The list of roles to assign to the service account"
  default = []
}

variable "invokers" {
  type = list(string)
  description = "The list of members that can invoke the function. Include allUsers to make the function public."
  default = ["allUsers"]
}