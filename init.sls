openssh-server:
  pkg.installed: []

ssh:
  service.running:
    - enable: true
    - watch:
      - pkg: openssh-server
      - file: /etc/ssh/sshd_config

/etc/ssh/sshd_config:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://sshd/sshd_config
    - require:
      - pkg: openssh-server
