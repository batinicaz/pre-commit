FROM ubuntu:latest as build
RUN apt-get update && apt-get install -y curl git unzip
RUN mkdir "/executables"
RUN curl -fL https://releases.hashicorp.com/terraform/1.5.2/terraform_1.5.2_linux_amd64.zip -o terraform.zip && unzip terraform.zip && mv terraform /executables
RUN curl -fL https://github.com/terraform-linters/tflint/releases/download/v0.47.0/tflint_linux_amd64.zip -o tflint.zip && unzip tflint.zip && mv tflint /executables

FROM bridgecrew/checkov:latest

# Pre-commit setup
RUN pip3 install --no-cache-dir pre-commit

# Copy tools used by pre-commit hooks
COPY --from=build /executables/terraform /bin/terraform
COPY --from=build /executables/tflint /bin/tflint

ENTRYPOINT ["/bin/sh", "-c", "git config --global --add safe.directory \"$(pwd)\" && pre-commit run -a"]