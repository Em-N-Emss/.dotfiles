## Neovim setup

### Requirements

- Neovim >= **0.9.0** (needs to be built with **LuaJIT**)
- Git >= **2.19.0** (for partial clones support)
- [LazyVim](https://www.lazyvim.org/)
- a [Nerd Font](https://www.nerdfonts.com/)(v3.0 or greater) **_(optional, but needed to display some icons)_**
- [lazygit](https://github.com/jesseduffield/lazygit) **_(optional)_**
- [Brew](https://brew.sh/) - Package/Plugin manager
- [Tmux](https://doc.ubuntu-fr.org/tmux) - LE SANG DE LA VEINE
- a **C** compiler for `nvim-treesitter`. See [here](https://github.com/nvim-treesitter/nvim-treesitter#requirements)
- for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) **_(optional)_**
  - **live grep**: [ripgrep](https://github.com/BurntSushi/ripgrep)
  - **find files**: [fd](https://github.com/sharkdp/fd)
- a terminal that support true color and _undercurl_:
  - [kitty](https://github.com/kovidgoyal/kitty) **_(Linux & Macos)_**
  - [wezterm](https://github.com/wez/wezterm) **_(Linux, Macos & Windows)_**
  - [alacritty](https://github.com/alacritty/alacritty) **_(Linux, Macos & Windows)_**
  - [iterm2](https://iterm2.com/) **_(Macos)_**
- [Solarized Osaka](https://github.com/craftzdog/solarized-osaka.nvim)

## Importer mes dotfiles

- Avant de cloner faire ceci pour le shell de base :

```bash
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

- Afin d'éviter des problèmes de récursivité :

```bash
echo ".dotfiles" >> .gitignore
```

- Maintenant cloner le repo en BARE (très important ) :

```bash
git clone --bare <git-repo-url> $HOME/.dotfiles
```

- Enfin redéfinir l'alias cette fois ci pour fish (Non nécessaire si bash est utilisé):

```bash
config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

- Récupérer tout en faisant :

```bash
config checkout
```

- Il va y avoir de conflits si .gitignore est déjà présent dans ce genre la :

```bash
error: The following untracked working tree files would be overwritten by checkout:
    .bashrc
    .gitignore
Please move or remove them before you can switch branches.
Aborting
```

- Solution :

  - Back up les fichiers si y a besoin :

  ```bash
  mkdir -p .config-backup && \
  config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
  xargs -I{} mv {} .config-backup/{
  ```

  - Dégager les fichiers en conflit le plus souvent juste .gitignore (ajouter les autres fichiers derrière .gitignore si besoin) :

  ```bash
  rm -rf .gitignore
  ```

- Enfin dans $HOME faire :

```bash
config config --local status.showUntrackedFiles no
```

## Shell setup (macOS & Linux)

- [Fish shell](https://fishshell.com/) - BIEN SUIVRE LES INSTRUCTIONS SINON CRASH TERMINAL
- [Fisher](https://github.com/jorgebucaran/fisher) - Plugin manager
- [Tide](https://github.com/IlanCosman/tide) - Shell theme. Use version 6:

```bash
fisher install ilancosman/tide@v6
```

- [Nerd fonts](https://github.com/ryanoasis/nerd-fonts) - Powerline-patched fonts. I use Hack.
- [z for fish](https://github.com/jethrokuan/z) - Directory jumping (ne pas oublier de prendre [Zoxide](https://github.com/ajeetdsouza/zoxide))
- [Eza](https://github.com/eza-community/eza) - `ls` replacement (Même chose ne pas oublier de prendre avec la version fish cette fois ci : [Eza_fish](https://github.com/plttn/fish-eza))
- [ghq](https://github.com/x-motemen/ghq) - Local Git repository organizer
- [fzf](https://github.com/PatrickF1/fzf.fish) - Interactive filtering (Normal [Fzf](https://github.com/junegunn/fzf))

## PowerShell setup (Windows)

- [Scoop](https://scoop.sh/) - A command-line installer
- [Git for Windows](https://gitforwindows.org/)
- [Oh My Posh](https://ohmyposh.dev/) - Prompt theme engine
- [Terminal Icons](https://github.com/devblackops/Terminal-Icons) - Folder and file icons
- [PSReadLine](https://docs.microsoft.com/en-us/powershell/module/psreadline/) - Cmdlets for customizing the editing environment, used for autocompletion
- [z](https://www.powershellgallery.com/packages/z) - Directory jumper
- [PSFzf](https://github.com/kelleyma49/PSFzf) - Fuzzy finder

## Dossier bin, link au système Windows

- Ne pas oublier de créer le dossier bin dans la racine avec :

```bash
mkdir -p ~/bin/
```

- le dossier bin sert d'alias symlink pour tous les fichiers présent dans Windows, ça permet d'éviter de ReDL des fichiers pour le système WSL.
- La technique d'alias symlink est :

```bash
ln -s /mnt/c/chemin/vers/fichier ~/bin/fichier
```

## Windows Tiling

- [Komorebi](https://github.com/LGUG2Z/komorebi) - Un peu comme i3 mais pour Windows
- Après avoir suivi l'installation de Komorebi, créer un lien symbolique avec `komorebic`.
  Pour cela la commande est :

```bash
ln -s /mnt/c/chemin/vers/komorebic/komorebic.exe ~/bin/komorebic
```

- Exemple avec moi ce serait : `ln -s /mnt/c/Users/imran/scoop/shims/komorebic.exe ~/bin/komorebic`

## Remap hotkeys

- [AutoHotKey](https://www.autohotkey.com/) - Permet de remap des touches sur windows
- Installer aussi Ahk2Exe.exe ça facilitera la tâche en transformant vos scripts en .exe
- Le lien symbolique est :

```bash
ln -s /mnt/c/chemin/vers/AutoHotKey ~/bin/AutoHotKey
```

- Exemple avec moi ce serait : `ln -s /mnt/c/Divers/AutoHotKey ~/bin/AutoHotKey`
- L'utilisation des scripts permet d'avoir les même touches que sur VIM ou faciliter l'utilisation de VIM
- Pour lancer les scripts dès le démarrage du pc, ouvrir l'explorateur de fichiers et copier/coller ce chemin :

```bash
%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup`. Déposer vos scripts dans le dossier.
```

## Git workflow

- [commitizen](https://github.com/commitizen/cz-cli) - Permet de générer des meilleurs commits
- Afin de pouvoir utiliser commitizen dans tous le système :

```bash
npm install -g cz-conventional-changelog
```

et ensuite :

```bash
echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc
```

- [hub](https://github.com/mislav/hub) - Permet d'ouvrir la page github du projet
- Pour cela il faut initialiser le token ici https://github.com/settings/tokens, installer [wslu](https://github.com/wslutilities/wslu#feature), enfin mettre ces deux lignes

```bash
export DISPLAY=:0
export BROWSER=/usr/bin/wslview
```

dans `.bashrc`
