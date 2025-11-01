# Metal estate configuration

This directory defines physical and bare-metal infrastructure for the estate.

- `config.yaml`: declarative definition of fleets, hardware models, hosts, and users.
- `config_schema.yaml`: JSON-Schema–compatible validation schema used by CI.

Consumers include, but are not limited to,
- ubuntu-image-builder
- ansible
