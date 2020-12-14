FROM alpine:latest

# https://docs.docker.com/engine/reference/builder/#maintainer-deprecated
LABEL MAINTAINER github.com/cloudxlr8r

RUN apk update && apk add curl jq libc6-compat go bash \
    && wget $(curl -s https://api.github.com/repos/mikefarah/yq/releases/latest | grep browser_download_url | grep linux_amd64 | cut -d '"' -f 4) -O /usr/local/bin/yq \
    && chmod +x /usr/local/bin/yq

# install eksctl
ENV DOWNLOAD_URL_EKSCTL="https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_Linux_amd64.tar.gz"
RUN curl --location --retry 5  "$DOWNLOAD_URL_EKSCTL" -o eksctl_download.tar.gz \
    && tar xzvf eksctl_download.tar.gz && rm eksctl_download.tar.gz \
    && chmod +x ./eksctl && mv ./eksctl /usr/local/bin/

RUN echo "==>" && eksctl version

# install aws-iam-authenticator
# https://api.github.com/repos/kubernetes-sigs/aws-iam-authenticator/releases/latest --
ENV DOWNLOAD_URL_IAM="https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.5.0/aws-iam-authenticator_0.5.0_linux_amd64"
RUN curl -sL -o aws-iam-authenticator "$DOWNLOAD_URL_IAM" \
    && chmod +x ./aws-iam-authenticator \
    && mv ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

# install kustomize, pinned to v3.2.3
ENV KUSTOMIZE_VERSION="3.2.3"
RUN curl -sLO "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.2.3/kustomize_kustomize.v${KUSTOMIZE_VERSION}_linux_amd64" \
    && chmod +x ./kustomize_kustomize.v${KUSTOMIZE_VERSION}_linux_amd64 \
    && mv ./kustomize_kustomize.v${KUSTOMIZE_VERSION}_linux_amd64 /usr/local/bin/kustomize

RUN GO111MODULE=on go get sigs.k8s.io/kustomize/kustomize/v3@v3.2.3

RUN echo "==>" && kustomize version

# install kubectl
# KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
ENV KUBECTL_VERSION=1.18.5
RUN curl -sLO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

RUN echo "==>" && kubectl version --client

# TODO Fix versioning on next release. Note: libc6-compat required to run kfctl on alpine see https://github.com/kubeflow/kfctl/issues/333
ENV KFCTL_VERSION=1.2.0
RUN curl -sLO "https://github.com/kubeflow/kfctl/releases/download/v1.2.0/kfctl_v1.2.0-0-gbc038f9_linux.tar.gz" \
    && tar xvf kfctl_v1.2.0-0-gbc038f9_linux.tar.gz && chmod +x kfctl \
    && mv kfctl /usr/local/bin/kfctl

RUN echo "==>" &&  kfctl version

    #  gpgme-dev
RUN apk --no-cache update && \
    apk --no-cache add git make bash py3-pip python3 python3-dev python2-dev libc-dev libffi-dev musl-dev linux-headers && \
    pip3 --no-cache-dir install -Iv kfp==1.1.2 && \
    pip3 --no-cache-dir install -Iv kfputils==0.3.0 && \
    pip3 --no-cache-dir install awscli j2cli[yaml] && \
    rm -rf /var/cache/apk/*

# RUN curl -sLO https://github.com/CloudXLR8R/pipelines/archive/master.zip && \
#     unzip master.zip && \
#     cd pipelines-master/sdk/python && \
#     ln -s /usr/bin/python3 /usr/bin/python && \
#     ./build.sh && \
#     pip3 install kfp.tar.gz

RUN echo "==>" && aws --version

