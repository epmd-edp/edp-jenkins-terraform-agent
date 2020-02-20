# Copyright 2020 EPAM Systems.
FROM openshift/jenkins-slave-base-centos7:v3.11

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
USER root

ENV DEFAULT_TERRAFORM_VERSION=0.12.13 \
    TERRAFORM_COMPLIANCE_VERSION=1.0.57 \
    TERRAFORM_DOCS_VERSION=v0.6.0 \
    TFENV_VERSION=v1.0.2 \
    TFLINT_VERSION=v0.12.1 \
    TFSEC_VERSION=v0.19.0

RUN yum remove java-1.8.0-openjdk-headless java-1.7.0-openjdk-headless java-1.7.0-openjdk java-1.7.0-openjdk-devel -y && \
    yum -y install java-11-openjdk-devel.x86_64 \
                   python3

RUN python3 -m pip install terraform-compliance==$TERRAFORM_COMPLIANCE_VERSION

RUN git clone https://github.com/tfutils/tfenv.git --branch $TFENV_VERSION ~/.tfenv && \
    ln -s ~/.tfenv/bin/* /usr/local/bin && \
    tfenv install $DEFAULT_TERRAFORM_VERSION

RUN curl -Lo ~/tflint.zip https://github.com/wata727/tflint/releases/download/$TFLINT_VERSION/tflint_linux_amd64.zip && \
    unzip ~/tflint.zip -d /usr/local/bin/ && rm ~/tflint.zip && \

    curl -Lo /usr/local/bin/terraform-docs https://github.com/segmentio/terraform-docs/releases/download/$TERRAFORM_DOCS_VERSION/terraform-docs-$TERRAFORM_DOCS_VERSION-linux-amd64 && \

    curl -Lo /usr/local/bin/tfsec https://github.com/liamg/tfsec/releases/download/$TFSEC_VERSION/tfsec-linux-amd64 && \

    chmod -R +x /usr/local/bin/

USER 1001