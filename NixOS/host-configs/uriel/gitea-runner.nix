{config, ...}: {
  services.gitea-actions-runner.instances.uriel-notarin = {
    enable = true;
    name = "uriel-notarin";
    url = "https://git.squishcat.net/";
    tokenFile = config.sops.secrets."gitea/notarin".path;
    labels = ["native:host"];
  };
  services.gitea-actions-runner.instances.uriel-yinyang = {
    enable = true;
    name = "uriel-yinyang";
    url = "https://git.squishcat.net/";
    tokenFile = config.sops.secrets."gitea/yinyang".path;
    labels = ["native:host"];
  };
}
