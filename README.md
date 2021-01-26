# SSH daemon salt formula

![Saltstack](https://github.com/chr4/salt-sshd/workflows/Saltstack/badge.svg)

This salt formula installs and configures `sshd` securely.

The optional pillar key `sshd:hostkeys:{{ keyfile }}` can be used to deploy multiple predefined `{{ keyfile }}`s.
When `{{ keyfile }}` ends in `.pub`, its mode will be `0644`, and `0600` otherwise.
See the `pillar.example` for details.
