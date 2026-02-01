# OpenSSH configuration
_: {
  services.openssh = {
    enable = true;

    settings = {
      # Security hardening
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;

      # Only allow key-based authentication
      PubkeyAuthentication = true;

      # Disable unused features
      X11Forwarding = false;
    };

    # Listen on all interfaces
    openFirewall = true;
  };
}
