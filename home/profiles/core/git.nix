# Git configuration
{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Goksel Kabadayi";
        email = "gokselk.dev@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        lg = "log --oneline --graph --decorate";
      };
    };
  };
}
