{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    pkgs.zola
    pkgs.imagemagick
    pkgs.inkscape
  ];

  processes = {

    zola.exec = "zola serve";
  };

}
