{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    home = "/srv/ollama";
    acceleration = "rocm";
    user = "ollama";
    group = "ollama";
    openFirewall = true;
    host = "http://0.0.0.0";
    environmentVariables = {
      OLLAMA_HOST = "0.0.0.0";
      OLLAMA_ORIGINES = "*";
    };
  };
}
