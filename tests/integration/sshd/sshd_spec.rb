control 'ssh' do
  title 'should be installed & configured'

  describe package('openssh-server') do
    it { should be_installed }
  end

  describe file('/etc/ssh/sshd_config') do
    its('mode') { should cmp '0644' }
    its('content') { should match /^\s*Port 22$/ }
    its('content') { should match /^\s*PermitRootLogin no$/ }
    its('content') { should match /^\s*MaxStartups 10$/ }
    its('content') { should match /^\s*KexAlgorithms.*curve25519-sha256@libssh.org/ } # Match bionic and jammy versions
    its('content') { should match /^\s*MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com$/ }
    its('content') { should match /^\s*Ciphers chacha20-poly1305@openssh.com$/ }
    its('content') { should match /^\s*ClientAliveInterval 15$/ }
  end

  describe file('/etc/ssh/moduli') do
    its('mode') { should cmp '0644' }
    its('content') { should_not match /\s2047\s/ }
  end

  describe service('sshd') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(22) do
    it { should be_listening }
    its('processes') { should include(/sshd/) }
  end

  describe file('/etc/ssh/ssh_host_ed25519_key') do
    its('mode') { should cmp '0600' }
    its('content') { should match /^PRIVATE KEY CONTENT$/ }
  end

  describe file('/etc/ssh/ssh_host_ed25519_key.pub') do
    its('mode') { should cmp '0644' }
    its('content') { should match /^PUBLIC KEY CONTENT$/ }
  end

end
