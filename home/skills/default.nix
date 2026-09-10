{ ... }:

{
  home.file.".agents/skills/cognitive-rhythm-writing".source = ./cognitive-rhythm-writing;
  home.file.".agents/skills/english-cognitive-rhythm-writing" = {
    source = ./english-cognitive-rhythm-writing;
    recursive = true;
  };
  home.file.".agents/skills/english-tech-writing".source = ./english-tech-writing;
  home.file.".agents/skills/japanese-tech-writing".source = ./japanese-tech-writing;
}
