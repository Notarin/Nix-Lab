{...}: {
  # Enable libvirt VM management
  virtualisation.libvirtd.enable = true;
  # Adding my main user to the libvirt group
  users.users.notarin.extraGroups = ["libvirtd"];
}
