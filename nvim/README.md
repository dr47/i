# Bugs:

* run => Lazy (l) => failed section - 27 plugins failed?!?

# TODO

ContainerFile

* debian:forky? Nemusi byt uplne stable...
* LazyVim se klonuje z `master` bez připnuté verze
* doinstalovat Treesitter parsery už při buildu (chybí např. `jsonc`)
* build neselže, když selžou pluginy (`Lazy! sync` vrací 0 i při chybách) nebo Mason
* tip: headless kontrola Masonu a Treesitteru přímo v Containerfile (vhodné pro CI)


Build.sh

* při `:cq` skript skončí s chybou bez vysvětlení, zvážit hlášku
* tip: interaktivní krok znemožňuje plně automatický build (CI)

run.sh

* automaticky nacitat sessions? (jeste promyslet)
* `.cache` jako tmpfs s `noexec` může blokovat spouštění nástrojů z cache

nvim.config
* dalsi zkratky?

# Known bug: Treesitter parsery v buildu

Instalace parserů občas selže s hláškou `parser.so not found` (souběžná kompilace). Chyba je nedeterministická, build proto opakujeme, dokud neprojde. Pravděpodobná příčina: souběh instalace z `ensure_installed` na pozadí s dalším voláním instalace (neověřeno).

  * Lazy po chybné instalaci označí build jako hotový, další build parsery nedoinstaluje. Chybějící doinstalují následující kroky a interaktivní nvim.
  * Kontrolní krok v `Containerfile` ověřuje všech 10 jazyků. Je to dočasný workaround (označen komentářem).
  * Pojistka: ruční `:checkhealth nvim-treesitter` v interaktivním nvim v `build.sh`.
  * `tree-sitter` CLI 0.26.11 je vyloučen. nvim-treesitter (větev `main`, commit `19bdfc04`) nemá release tagy, verze se nepřipíná.
  * Možná řešení k prozkoumání: ověřit parsery shellem bez spuštění nvim; oddělit instalaci při buildu v `nvim.config`; nahlásit chybu upstreamu.

Poznámka: `:cq` v interaktivním nvim přeruší `build.sh` (kvůli `set -e`), commit image se neprovede.

