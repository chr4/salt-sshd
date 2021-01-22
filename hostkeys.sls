{% for keypair in salt['pillar.get']('sshd:hostkeys') %}
# Deploy private key part
/etc/ssh/{{ keypair['name'] }}:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - contents_pillar: sshd:hostkeys:{{ keypair['name'] }}:private # could/should I use simply {{ keypair['private'] }} here
    - require:
      - pkg: openssh-server # is this necessary

# Deploy public key part
/etc/ssh/{{ keypair['name'] }}.pub:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents_pillar: sshd:hostkeys:{{ keypair['name'] }}:pub # could/should I use simply {{ keypair['pub'] }} here
    - require:
      - pkg: openssh-server # is this necessary
{% endfor %}
