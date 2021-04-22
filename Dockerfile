ARG ARGOCD_VERSION=v2.0.0
FROM argoproj/argocd:$ARGOCD_VERSION

ENV SOPS_VERSION=3.7.1 \
  HELM_SECRETS_VERSION=3.6.1

USER root

RUN set -x && \
  apt-get update && \
  apt-get install -y --no-install-recommends curl ca-certificates && \
  curl -sSL https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux -o /usr/local/bin/sops && \
  chmod 755 /usr/local/bin/sops && \
  mv /usr/local/bin/helm /usr/local/bin/helm.bin && \
  mv /usr/local/bin/helm2 /usr/local/bin/helm2.bin && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

COPY helm.sh /usr/local/bin/helm
COPY helm2.sh /usr/local/bin/helm2

USER argocd

RUN set -x && \
  helm.bin plugin install https://github.com/jkroepke/helm-secrets --version v${HELM_SECRETS_VERSION}
