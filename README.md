# Pre-Commit


Adds in pre-commit along with the latest version of:

* checkov
* terraform
* tflint

Built every day at 2AM to get latest changes and scanned for vulnerabilities using Aqua's [Trivy](https://github.com/aquasecurity/trivy).

## Usage

You can use the image in GitHub actions with a job definition like the one below:

```yaml
  pre-commit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Run pre-commit
        uses: batinicaz/gha/.github/actions/pre-commit@latest
```
This makes use of a [custom action](https://github.com/batinicaz/gha/blob/main/docs/actions/pre-commit/README.md) that wraps this image to handle the non-root user.