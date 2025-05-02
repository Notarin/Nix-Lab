{ ... }:
{
  services.gitea-actions-runner.instances.uriel-notarin = {
    enable = true;
    name = "uriel-notarin";
    url = "https://git.squishcat.net/";
    tokenFile = /persistent/passwords/gitea-runner-notarin;
    labels = [ "native:host" ];
  };
  services.gitea-actions-runner.instances.uriel-yinyang = {
    enable = true;
    name = "uriel-yinyang";
    url = "https://git.squishcat.net/";
    tokenFile = /persistent/passwords/gitea-runner-yinyang;
    labels = [ "native:host" ];
  };
}
