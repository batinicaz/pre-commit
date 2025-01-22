FROM ubuntu:latest AS build

ARG PACKER_VERSION
ARG TERRAFORM_VERSION
ARG TF_LINT_VERSION

RUN apt-get update && apt-get install -y curl git unzip
RUN mkdir "/executables"
RUN curl -fL https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip -o packer.zip && unzip -o packer.zip && mv packer /executables
RUN curl -fL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip && unzip -o terraform.zip && mv terraform /executables
RUN curl -fL https://github.com/terraform-linters/tflint/releases/download/${TF_LINT_VERSION}/tflint_linux_amd64.zip -o tflint.zip && unzip -o tflint.zip && mv tflint /executables

FROM cgr.dev/chainguard/wolfi-base
# gcc, glibc-dev and rust required until checkov bumps rustowrkx - https://github.com/bridgecrewio/checkov/pull/6045
RUN apk add --no-cache bash gcc glibc-dev git python3 py3-pip rust

# Pre-commit setup
ENV PATH="${PATH}:/home/nonroot/.local/bin"
RUN pip3 install --no-cache-dir pre-commit

# Copy tools used by pre-commit hooks
COPY --from=build /executables/packer /bin/packer
COPY --from=build /executables/terraform /bin/terraform
COPY --from=build /executables/tflint /bin/tflint

ENTRYPOINT ["/bin/sh", "-c", "git config --global --add safe.directory \"$(pwd)\" && pre-commit run -a"]
