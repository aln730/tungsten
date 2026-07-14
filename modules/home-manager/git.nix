{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    delta.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      # commit.gpgsign = true;
      # user.signingkey = "";
    };
    aliases = {
      st = "status -sb";
      co = "checkout";
      br = "branch";
      ci = "commit";
      lg = "log --oneline --graph --decorate";
      last = "log -1 HEAD";
      amend = "commit --amend --no-edit";
      unstage = "reset HEAD --";
    };
  };
}
