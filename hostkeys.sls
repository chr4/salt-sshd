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
