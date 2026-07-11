{pkgs, ...}: {
  services.nginx.virtualHosts."hl.squishcat.net" = {
    locations."/wiki/" = {
      alias = "${pkgs.callPackage ./package.nix {}}/";
      index = "index.html";
      extraConfig = ''
        try_files $uri $uri/index.html /index.html;
      '';
    };
  };
}
