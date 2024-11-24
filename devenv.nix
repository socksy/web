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

  git-hooks.hooks.build = {
    enable = true;
    name = "Build site before committing";
    entry = "zola build";
    pass_filenames = false;
  };

}
