terraform {
  cloud {}
}
/*
Since variables cannot be used in this block, we will rely on the following env variables during
"terraform init" at the GitHub Actions workflow run in order to specify the details of the backend:
TF_API_TOKEN - TF_CLOUD_ORGANIZATION - TF_WORKSPACE
*/