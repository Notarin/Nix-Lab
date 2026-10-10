{config, ...}: {
  config = {
    sops.secrets."forgejo/hardlight" = {};
    virtualisation.docker.enable = true;
    services.forgejo-runner.instances.uriel = {
      enable = true;
      secrets.server.connections.main.token_url = config.sops.secrets."forgejo/hardlight".path;
      settings = {
        runner.labels = ["ubuntu-latest:docker://ghcr.io/catthehacker/ubuntu:act-22.04"];
        server.connections.main = {
          url = "https://code.hardlight.space/";
          uuid = "a70b22a4-4855-46cd-96bb-5963e6b6ca8b";
        };
      };
    };
  };
}
