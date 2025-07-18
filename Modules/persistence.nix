{...}: {
  environment.persistence."/persistent" = {
    hideMounts = true;
    files = [
      "/etc/machine-id" # Used for various inter-pc communication purposes
      # All these keys are used to persist SSH identity
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
    directories = [
      "/var/lib/nixos" # Needed for uid persistence
      "/var/lib/iwd" # Needed to keep wifi passwords and settings
      "/var/lib/bluetooth" # Needed to keep bluetooth pairings
      "/root" # Could probably be done better, but keeps the root user home
      "/srv" # Persists server data stores
    ];
  };
}
