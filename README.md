# Kubeflow Toolkit
### Status

[![CircleCI](https://circleci.com/gh/CloudXLR8R/kf-toolkit.svg?style=svg)](https://circleci.com/gh/CloudXLR8R/kf-toolkit)

A prebaked image containing useful tools for Kubeflow such as -

- aws-iam-authenticator
- eksctl cli
- kubectl + kustomize cli
- kfp - kubeflow pipelines cli
- kfputils - XL8R kubeflow utils
- kfctl - kubeflow cli

## Run locally
To run locally, simply pull the image and run it via Docker

```
docker run -it --rm cloudxlr8r/kf-toolkit sh
```

