# Pre-Commit

Simple docker image built on top of [bridgecrew/checkov](https://hub.docker.com/r/bridgecrew/checkov/). Adds in pre-commit along with the latest version of:

* terraform
* tflint

Built ever day at 2AM to get latest changes.

## Usage

You can use the image in GitHub actions with a job definition like the one below:

```yaml
  pre-commit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Run pre-commit
        uses: docker://ghcr.io/batinicaz/pre-commit:latest
```
