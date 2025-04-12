[//]: # (STANDARD README)
[//]: # (https://github.com/RichardLitt/standard-readme)
[//]: # (----------------------------------------------)
[//]: # (Uncomment optional sections as required)
[//]: # (----------------------------------------------)

[//]: # (Title)
[//]: # (Match repository name)
[//]: # (REQUIRED)

#  estate-config

[//]: # (Banner)
[//]: # (OPTIONAL)
[//]: # (Must not have its own title)
[//]: # (Must link to local image in current repository)


[//]: # (Badges)
[//]: # (OPTIONAL)
[//]: # (Must not have its own title)


[//]: # (Short description)
[//]: # (REQUIRED)
[//]: # (An overview of the intentions of this repo)
[//]: # (Must not have its own title)
[//]: # (Must be less than 120 characters)
[//]: # (Must match GitHub's description)

Configuration for the estate

[//]: # (Long Description)
[//]: # (OPTIONAL)
[//]: # (Must not have its own title)
[//]: # (A detailed description of the repo)

This is the configuration of resources that are shared across the estate.

As a continuous delivery organisation, most of our projects define only a single `production` environment. This ensures that changes are delivered rapidly and confidently to live systems, without requiring long-running staging environments or traditional dev/prod splits.

Where multiple environments are used, the common convention is for each to be a mirror of production, differing only in data, scale, or access. That is not the approach taken here.

In this project, the environments reflect how the resources are used, not how closely they resemble production:
- The development environment supports CI/CD and internal tooling. If it breaks, you might delay development, but production will continue to run.
- The production environment contains shared infrastructure relied on by production systems across the estate. If you break this, the impact is real and immediate.

Treat the production environment with care. This is not a sandbox. Here be dragons. 🐉


[//]: # (Keep this note to help people understand how to configure this repo.)
The configuration of this repo is managed by OpenTofu in [estate-repos](https://github.com/evoteum/estate-repos).



## Table of Contents

[//]: # (REQUIRED)
[//]: # (Delete as appropriate)

1. [Security](#security)
1. [Background](#background)
1. [Install](#install)
1. [Usage](#usage)
1. [Contributing](#contributing)
1. [License](#license)

## Security
[//]: # (OPTIONAL)
[//]: # (May go here if it is important to highlight security concerns.)

This repo is public and does not contain any sensitive information. All secrets are variables in the CI/CD pipeline.

## Background
[//]: # (OPTIONAL)
[//]: # (Explain the motivation and abstract dependencies for this repo)

Tofu that impacts everything is defined here. Avoid using this repo for project-specific infra or config.

In the full spirit of FLOSS, we use OpenTofu and its preferred .tofu extension.

## Install

[//]: # (Explain how to install the thing.)
[//]: # (OPTIONAL IF documentation repo)
[//]: # (ELSE REQUIRED)

No installation is required.

## Usage
[//]: # (REQUIRED)
[//]: # (Explain what the thing does. Use screenshots and/or videos.)

Just Tofu here, really. Nothing super fun or exciting. Just tofu.

## Contributing
[//]: # (REQUIRED)

If you need any help, please log an issue and one of our team will get back to you.

PRs are welcome.

## License
[//]: # (REQUIRED)
All our code & software, including that in this repo,
is [free (libre) and open source](https://en.wikipedia.org/wiki/Free_and_open-source_software).

- The license is the  GNU Affero General Public License version 3.
- The license owner is evoteum.
- The full text of the license can be found in the [LICENSE](LICENSE) file.
