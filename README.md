# Secure Sum Action

<img align="right" src="https://raw.githubusercontent.com/aunovis/secure_sum/refs/heads/main/img/secure_sam.svg" alt="Secure Sam, Secure Sum's mascot" width="200"/>

Check the security posture of your dependencies directly from your CI/CD pipeline.

This action uses [Secure Sum](https://github.com/aunovis/secure_sum), an open-source application developed by [AUNOVIS GmbH](https://www.aunovis.de), to evaluate the dependencies of your project.

Internally, Secure Sum uses [OSSF Scorecard](https://github.com/ossf/scorecard) to run several so-called "probes" against the first-level dependencies it finds, and evaluates them to assign a "score" between 0 and 10.

If you want to use Secure Sum on your local system, refer to the [Readme](https://github.com/aunovis/secure_sum?tab=readme-ov-file#usage) of the project's repository.

## Getting Started

### Inputs

- `targets`: Any combination of filepaths to dependency files or URLs of repositories.
- `metric`: *(Optional)* Provide a filepath here to overwrite the [default metric](https://github.com/aunovis/secure_sum/blob/main/default_metric.toml) with your own. See the [Secure Sum Readme](https://github.com/aunovis/secure_sum#metric-file) for the syntax and logic of metric files.
- `details`: *(Optional)* Provide the value "false" here if you do **not** want to see a detailed output of the results in the pipeline.
- `error-threshold`: *(Optional)* Secure Sum returns an error code if any evaluated dependency has a score of 3 or lower. If you want to adjust this threshold, provide a numerical value between 0 and 10 here.

## Example Usage

```yaml

name: Example Workflow

on:
  schedule:
    - cron: '0 3 * * 6' # Runs the workflow once a week at 03:00 UTC (minute hour day month weekday)

jobs:
  install:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Evaluate Dependencies
        uses: aunovis/secure-sum-action@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }} # This environment variable is pre-defined by GitHub when you run this action, you do *not* need to set it up yourself.
        with:
          targets: './Cargo.toml package.json https://github.com/aunovis/secure_sum'
          metric: './custom_metric.toml' # Optional
          # details: false # Use this if you prefer less output in your pipelines.
          error-threshold: 3.5 # Optional, default is 3
```

## License

This project is licensed under the MIT License. See the [LICENSE file](https://github.com/aunovis/secure-sum-action/blob/main/LICENSE) for details.
