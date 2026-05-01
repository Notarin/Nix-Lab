{
  # Vesktop likes to randomly disregard your wishes on gain control and just randomly tank your mic volume.
  # Pretty sick of vesktop acting like it owns MY computer, so screw you vesktop, try to fuck with my mic now!
  services.pipewire.extraConfig.pipewire-pulse = {
    "51-deny-vesktop-gain-control"."pulse.rules" = [
      {
        "match" = [
          {"application.process.binary" = "vesktop";}
          {"application.name" = "vesktop";}
          {"application.name" = "Vesktop";}
        ];
        "actions" = {
          "quirks" = ["block-source-volume"];
        };
      }
    ];
  };
}
