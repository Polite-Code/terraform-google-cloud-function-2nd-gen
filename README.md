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

## When to use Cloud Functions 2nd gen vs. Cloud Run

This is a matter of opinion at this point. Cloud Functions 2nd gen are just a way to deploy a Cloud Run container; the end result is very similar indeed.
With EventArc, the distinction between Cloud Functions and Cloud Run has become even smaller, to the point that Cloud Functions vs. Cloud Run
is really a matter of how you prefer to _deploy_ your code.

Cloud Functions are slightly easier in the sense that you don't need to define a Docker image and can be fully managed by Terraform.
With this module, you can just point to the function path, specify a runtime, and everything will work. Especially for small snippets of code that don't 
require a lot of ongoing development, this is quite convenient.

Using Cloud Run directly is better if you want a separate build pipeline, which is usually the case if the code is being actively developed
or if your infrastructure is defined in a different repository than your code. 
It is also preferable if you want direct control of the container runtime, for example
if you want to configure concurrency, or if you want a more complex pipeline. And of course, if you want all the advantages that
containers bring, such as portability, different and more complex runtimes,...,
then Cloud Run is the only option.

So in short, use Cloud Functions with this module for small and simple snippets of code that don't change often. 
Use Cloud Run for everything else. 

Also read [Why I definitively switched from Cloud Functions to Cloud Run](https://medium.com/google-cloud/why-i-definitively-switched-from-cloud-functions-to-cloud-run-635d03f1eb4d). 