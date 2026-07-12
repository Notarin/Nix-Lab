{
  services.nginx.virtualHosts."hl.squishcat.net" = {
    locations."/wiki/" = {
      alias = "${(builtins.getFlake "git+ssh://uriel.squishcat.net:23231/HardLight-Docs.git?rev=ff9cb7bb40ac2ddf74b8c9e3cb0b89a6a008e7f3").packages.x86_64-linux.default}/";
      index = "index.html";
      extraConfig = ''
        try_files $uri $uri/index.html /index.html;
      '';
    };
  };
}
