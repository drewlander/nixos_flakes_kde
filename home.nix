{ config, pkgs, ... }:

{
  home.username = "user";
  home.homeDirectory = "/home/user";

  # Set this to the Home Manager release you first used, and leave it alone after.
  home.stateVersion = "26.05";

  # Per-user packages (moved here from users.users."user".packages).
  home.packages = with pkgs; [
    kdePackages.kate
    # thunderbird
    mullvad-browser
    audacious
    xiphos
    google-chrome
    go
    gcc
    deskflow
    pkg-config 
    zlib
    qbittorrent
    neovim
    pandoc
    alacritty
  ];

  # Example: manage git through Home Manager. Fill in and uncomment if you want it.
   programs.git = {
     enable = true;
     settings.user = {
       name = "drewski";
       email = "drewskiwooskie@gmail.com";
     };
   };

services.flatpak = {

  enable = true;

    remotes = [{
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }];

    packages = [
      "org.mozilla.firefox"
    ];
};


  # Lets Home Manager manage itself.
  programs.home-manager.enable = true;
}
