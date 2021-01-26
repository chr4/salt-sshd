openssh-server:
  pkg.installed: []

ssh:
  service.running:
    - enable: true
    - watch:
      - pkg: openssh-server
      - file: /etc/ssh/sshd_config
      - file: /etc/ssh/moduli

/etc/ssh/sshd_config:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://{{ tpldir }}/sshd_config.jinja
    - template: jinja
    - defaults:
      port: {{ salt['pillar.get']('sshd:port', 22) }}
      permit_root_login: {{ salt['pillar.get']('sshd:permit_root_login', false) }}
      log_level: 'VERBOSE'
    - require:
      - pkg: openssh-server

# Remove insecure moduli
/etc/ssh/moduli:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://{{ tpldir }}/moduli
    - require:
      - pkg: openssh-server

# Deploy any specified hostkey files
{% for key in salt['pillar.get']('sshd:hostkeys') %}
/etc/ssh/{{ key }}:
  file.managed:
    - user: root
    - group: root
  {% if key.endswith('.pub') %}
    - mode: 644
  {% else %}
    - mode: 600
  {% endif %}
    - contents_pillar: sshd:hostkeys:{{ key }}
    - require:
      - pkg: openssh-server
{% endfor %}
