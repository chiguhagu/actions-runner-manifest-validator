# syntax=docker/dockerfile:1.17
ARG RUNNER_VERSION=2.327.1

FROM --platform=${TARGETPLATFORM} ghcr.io/actions/actions-runner:${RUNNER_VERSION}

ARG TARGETARCH

USER root

ARG CONFTEST_VERSION=0.62.0
ARG KUBECONFORM_VERSION=0.7.0
ARG KUSTOMIZE_VERSION=5.7.0
ARG HELM_VERSION=3.18.4

RUN ARCH_SUFFIX=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "x86_64") \
    && curl -fLo conftest.tar.gz "https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_${ARCH_SUFFIX}.tar.gz" \
    && mkdir conftest \
    && tar xvzf conftest.tar.gz -C conftest \
    && mv conftest/conftest /usr/bin/conftest \
    && rm conftest.tar.gz \
    && rm -r conftest

RUN ARCH_SUFFIX=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "amd64") \
    && curl -fLo kubeconform.tar.gz "https://github.com/yannh/kubeconform/releases/download/v${KUBECONFORM_VERSION}/kubeconform-linux-${ARCH_SUFFIX}.tar.gz" \
    && mkdir kubeconform \
    && tar xvzf kubeconform.tar.gz -C kubeconform \
    && mv kubeconform/kubeconform /usr/bin/kubeconform \
    && rm kubeconform.tar.gz \
    && rm -r kubeconform

RUN ARCH_SUFFIX=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "amd64") \
    && curl -fLo kustomize.tar.gz "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_${ARCH_SUFFIX}.tar.gz" \
    && mkdir kustomize \
    && tar xvzf kustomize.tar.gz -C kustomize \
    && mv kustomize/kustomize /usr/bin/kustomize \
    && rm kustomize.tar.gz \
    && rm -r kustomize

RUN ARCH_SUFFIX=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "amd64") \
    && curl -fLo helm.tar.gz "https://get.helm.sh/helm-v${HELM_VERSION}-linux-${ARCH_SUFFIX}.tar.gz" \
    && mkdir helm \
    && tar xvzf helm.tar.gz -C helm \
    && mv helm/linux-${ARCH_SUFFIX}/helm /usr/bin/helm \
    && rm helm.tar.gz \
    && rm -r helm

USER runner
