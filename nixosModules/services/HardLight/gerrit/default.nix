{
  fn,
  pkgs,
  ...
}: {
  services = fn.ifHost "uriel" {
    gerrit = {
      package = (pkgs.callPackage ./package.nix {}).overrideAttrs {patches = [./0001-nuke-AI-features.patch];};
      jvmPackage = pkgs.jdk25_headless;
      enable = true;
      serverId = "a8888a06-4fc9-4f11-9a8d-139c80df39dc";
      jvmHeapLimit = "6g";
      settings = {
        auth = {
          type = "OAUTH";
        };
        gerrit.canonicalWebUrl = "https://hl.squishcat.net/";
        httpd.listenUrl = "proxy-https://127.0.0.1:8080/";
        sshd.listenAddress = "*:29418";
        core = {
          packedGitOpenFiles = "4096";
          packedGitLimit = "2g";
          deltaBaseCacheLimit = "128m";
        };
        gc = {
          autobg = "true";
          aggressive = "true";
        };
        pack = {
          indexObjectsWithoutSize = "true";
          window = "250";
          depth = "250";
          compression = "9";
        };
        automerge.botEmail = "autosubmit@hl.squishcat.net";
        plugin = {
          "gerrit-oauth-provider-discovery-oauth" = {
            root-url = "https://account.spacestation14.com";
            username-claim = "preferred_username";
            email-claim = "email";
          };
        };
      };
      plugins = builtins.attrValues {
        inherit
          ((builtins.getFlake "github:Notarin/nix-gerrit?rev=fe5a7950eb192c7ec54b8612540557d86346e633").packages.x86_64-linux.plugins_3_13)
          download-commands
          checks-jenkins
          events-log
          autosubmitter
          ;
        oauth = builtins.fetchurl {
          url = "https://gerrit-ci.gerritforge.com/job/plugin-oauth-bazel-stable-3.14/lastSuccessfulBuild/artifact/bazel-bin/plugins/oauth/oauth.jar";
          sha256 = "sha256:1scn55lchyiia37n9jvgh6yl9n98cbjld2lwhm6fddjb4icvlhl9";
        };
      };
    };
    nginx = {
      enable = true;
      virtualHosts."hl.squishcat.net" = {
        useACMEHost = "squishcat.net";
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:8080";
            extraConfig = ''
              proxy_set_header Host              $host;
              proxy_set_header X-Real-IP         $remote_addr;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-Host  $host;
              proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
            '';
          };
        };
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [80 29418 443];
  };
}
