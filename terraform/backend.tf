terraform {
  cloud {
    organization = "{{TF_CLOUD_ORGANIZATION}}"

    workspaces {
      name = "{{TF_WORKSPACE}}"
    }
  }
}