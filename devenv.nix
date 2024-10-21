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
  ];

  processes = {

    zola.exec = "zola serve";
  };

}
