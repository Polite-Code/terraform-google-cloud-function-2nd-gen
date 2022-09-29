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
  default = "The (relative) path where the source code for the function can be found. Must point to a directory."
}

variable "runtime" {
  type = string
  description = "The runtime in which to run the function."
  validation {
    condition = contains([
      "node16",
      "node14",
      "node12",
      "node10",
      "python310",
      "python39",
      "python38",
      "python37",
      "go116",
      "go113",
      "go111",
      "java17",
      "java11",
      "dotnet6",
      "dotnet3",
      "ruby30",
      "ruby27",
      "ruby26",
      "php81",
      "php74"])
  }
}

variable "region" {
  type = string
}

variable "min_instance_count" {
  type = number
  default = 0
  description = "The limit on the minimum number of function instances that may coexist at a given time."
}

variable "timeout_seconds" {
  type = number
  default = 60
  description = "The function execution timeout. Execution is considered failed and can be terminated if the function is not completed at the end of the timeout period. Defaults to 60 seconds."
}

variable "available_memory" {
  type = string
  default = "128Mi"
  description = "The amount of memory available for a function. Defaults to 256M. Supported units are k, M, G, Mi, Gi. If no unit is supplied the value is interpreted as bytes."
}

variable "all_traffic_on_latest_revision" {
  type = bool
  default = true
  description = "Whether 100% of traffic is routed to the latest revision. Defaults to true."
}

variable "entry_point" {
  type = string
  description = <<EOD
The name of the function (as defined in source code) that will be executed.
Defaults to the resource name suffix, if not specified.
For backward compatibility, if function with given name is not found, then the system will try to use function named "function".
For Node.js this is name of a function exported by the module specified in source_location.
  EOD
}

variable "environment_variables" {
  type = map(string)
  default = {}
  description = "User-provided build-time environment variables for the function."
}

variable "max_instance_count" {
  type = number
  default = 1
  description = "The limit on the maximum number of function instances that may coexist at a given time."
}

variable "function_name" {
  type = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]{1,255}$", var.function_name))
    error_message = "The function_name must be a string of alphanumeric, hyphen, and underscore characters, and upto 255 characters in length." }
  description = <<EOD
The function name.
EOD
}

variable "ingress_settings" {
  type = string
  validation {
    condition = contains(["ALLOW_ALL", "ALLOW_INTERNAL_ONLY", "ALLOW_INTERNAL_AND_GCLB"], var.ingress_settings)
    error_message = "Must be one of ALLOW_ALL, ALLOW_INTERNAL_ONLY, ALLOW_INTERNAL_AND_GCLB"
  }
  description = "Available ingress settings. Defaults to ALLOW_ALL if unspecified. Default value is ALLOW_ALL. Possible values are ALLOW_ALL, ALLOW_INTERNAL_ONLY, and ALLOW_INTERNAL_AND_GCLB."
  default = "ALLOW_ALL"
}

variable "roles" {
  type = list(string)
  validation {
    condition = can(regex("^^roles/[a-z.]+$$"))
  }
  description = "The list of roles to assign to the service account that the Cloud Function will use."
  default = []
}

variable "invokers" {
  type = list(string)
  description = "The list of members that can invoke the function. Include allUsers to make the function public."
  default = ["allUsers"]
}

variable "vpc_connector" {
  type = string
  description = <<EOD
 The Serverless VPC Access connector that this cloud function can connect to.
 This should be a fully qualified URI in this format: projects/*/locations/*/connectors/*.
EOD
  default = null
}

variable "vpc_connector_egress_settings" {
  type = string
  validation {
    condition = contains(["ALL_TRAFFIC", "PRIVATE_RANGES_ONLY"], var.vpc_connector)
    error_message = "Must be one of ALL_TRAFFIC, PRIVATE_RANGES_ONLY"
  }
  description = <<EOD
  The egress settings for the VPC connector. This controls which traffic flows through it.
Allowed values are ALL_TRAFFIC and PRIVATE_RANGES_ONLY
EOD

}