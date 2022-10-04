# GCP Cloud Function 2nd gen

Opinionated module to create a GCP 2nd gen Cloud Function, without  the need to create a separate zip file and
upload it to GCS, and without the need to create a separate service account and manually assign roles to it.

The module will create  the zip-file, upload it to GCS, create a service account for the function, assign the `roles` you specified to it,
and allow invocation by the members specified in `invokers` (if any). 


## Example

```HCL
module "otp-webhook" {
  source = "Polite-Code/cloud-function-2nd-gen/google"
  entry_point = "main"
  function_name = "otp-webhook"
  function_path = "../otp_webhook"
  project_id = var.project_id
  region = var.region
  runtime = "python310"
  roles = ["roles/datastore.user"]
  invokers = ["serviceAccount:your-sa@your-project.iam.gserviceaccount.com"]
}
```