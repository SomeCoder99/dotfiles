{
  dotconf = ''
  last_dir=$PWD
  cd $HOME/dotfiles
  $EDITOR .
  cd $last_dir
  '';

  dotswitch = ''
  switch_system() {
    sudo nixos-rebuild switch --flake $HOME/dotfiles#laptop
  }

  switch_home() {
    home-manager switch --flake $HOME/dotfiles
  }

  case $1 in
    system)
      switch_system
      ;;
    home)
      switch_home
      ;;
    all)
      switch_system
      switch_home
      ;;
    *)
      echo "cannot switch $1"
      false
      ;;
  esac
  '';
}
