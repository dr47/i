# Bugs:

* run => Lazy (l) => failed section - 27 plugins failed?!?

# TODO

ContainerFile

* debian:forky? Neni uplne stable...
* LazyVim se klonuje z `master` bez připnuté verze
* doinstalovat Treesitter parsery už při buildu (chybí např. `jsonc`)
* `tree-sitter-cli` z apt nemusí odpovídat verzi požadované nvim-treesitter (zvážit npm nebo binárku s připnutou verzí)
* build neselže, když selžou pluginy (`Lazy! sync` vrací 0 i při chybách) nebo Mason
* `MasonInstall` je asynchronní, kontrola `is_installed()` hned za ním může selhat falešně (počkat na instalaci)
* `fd-find` na Debianu instaluje binárku `fdfind`, zvážit symlink na `fd`
* ověřit verzi `neovim` z apt, cílová je 0.12
* připnout commit LazyVim starteru místo `master`
* zvážit odebrání nepoužitého `python3-pip`
* tip: headless kontrola Masonu a Treesitteru přímo v Containerfile (vhodné pro CI)


Build.sh

* `chown -R root:root /home/nvim` znemožňuje zápis do ~/.local/share (vědomé rozhodnutí, ověřit při prvním běhu)
* při `:cq` skript skončí s chybou bez vysvětlení, zvážit hlášku
* ~~Tagovat verse, mozna lepe pojmenovat..~~
* `read -p` bez `-r` (shellcheck SC2162)
* ~~proměnná `VERSION` se nepoužívá (využít pro tagování, nebo odstranit)~~
* tip: interaktivní krok znemožňuje plně automatický build (CI)

run.sh

* prejmenovat .claude => .claude.key (mozna kolize)
* automaticky nacitat sessions? (jeste promyslet)
* `source "$HOME/.claude"` spustí libovolný kód, zvážit čtení klíče bez source
* API klíč je viditelný přes `podman inspect`
* `.cache` jako tmpfs s `noexec` může blokovat spouštění nástrojů z cache
* bez argumentů se nastaví `cwd=/`, což je pravděpodobně nežádoucí
* seznam chráněných cest doplnit o `/boot` a `/srv`
* API klíč v env kontejneru je viditelný přes `podman inspect`, zvážit Podman secret
* mounty jsou read-write, zvážit `:ro` pro soubory, které se nemají měnit
* proměnná `VERSION` se nepoužívá (využít pro tagování, nebo odstranit)

nvim.config
* dalsi zkratky?
