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
    - contents_pillar: sshd:hostkeys:{{ key }} # could/should I use simply {{ key }} here
    - require:
      - pkg: openssh-server # is this necessary
{% endfor %}
