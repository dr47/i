# Bugs:

* run => Lazy (l) => failed section - 27 plugins failed?!?

# TODO

ContainerFile

* debian:forky? Neni uplne stable...
* LazyVim se klonuje z `master` bez připnuté verze
* doinstalovat Treesitter parsery už při buildu (chybí např. `jsonc`)
* `tree-sitter-cli` z apt nemusí odpovídat verzi požadované nvim-treesitter


Build.sh

* `chown -R root:root /home/nvim` znemožňuje zápis do ~/.local/share (vědomé rozhodnutí, ověřit při prvním běhu)
* při `:cq` skript skončí s chybou bez vysvětlení, zvážit hlášku
* Tagovat verse, mozna lepe pojmenovat..

run.sh

* prejmenovat .claude => .claude.key (mozna kolize)
* automaticky nacitat sessions? (jeste promyslet)
* `source "$HOME/.claude"` spustí libovolný kód, zvážit čtení klíče bez source
* API klíč je viditelný přes `podman inspect`
* `.cache` jako tmpfs s `noexec` může blokovat spouštění nástrojů z cache
* bez argumentů se nastaví `cwd=/`, což je pravděpodobně nežádoucí
* seznam chráněných cest doplnit o `/boot` a `/srv`

nvim.config
* dalsi zkratky?
