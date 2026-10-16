# Credits and licences

`arvn lib` is written by [koteqjjjj](https://github.com/koteqjjjj).

The resolution/stretch system, the shape and style options and the motion
options added on top of the original library were inspired by the open-source
projects below. Only permissively licensed work was used, and no code is copied
verbatim unless stated. Each entry lists the exact licence under which that
project is distributed.

## Direct runtime dependency

| Project | Author | Licence | Used for |
|---|---|---|---|
| [Footagesus/Icons](https://github.com/Footagesus/Icons) | Footagesus | MIT | The icon set the library loads at runtime (`D.ICONS`). This was already a dependency of arvn lib before this work. |

## Design references and ideas

| Project | Author | Licence | Inspired |
|---|---|---|---|
| [Fusion](https://github.com/dphfox/Fusion) | dphfox (Daniel P H Fox) | MIT | Declarative state → view model, clean-up tracking. |
| [react-luau](https://github.com/Roblox/react-luau) | Roblox | MIT | Component composition, effect/dispose patterns. |
| [Iris](https://github.com/SirMallard/Iris) | SirMallard | MIT | Value-driven theme table and live theme repaint. |
| [WindUI](https://github.com/Footagesus/WindUI) | Footagesus | MIT | Settings surface, per-element scale overrides. |
| [roact-spring](https://github.com/chriscerie/roact-spring) | chriscerie | MIT | Easing presets and motion levels. |
| [plasma](https://github.com/evaera/plasma) | evaera | MIT | Easing-curve catalogue. |
| [Feather](https://github.com/SuboptimalEngineer/feather) | SuboptimalEngineer | MIT | Icon rendering and glyph fallback. |
| [Phosphor](https://github.com/phosphor-icons/core) | Phosphor Icons | MIT | Icon naming conventions. |

## Assets

| Asset | Author | Licence |
|---|---|---|
| [Material Design Icons](https://github.com/google/material-design-icons) | Google | Apache-2.0 |
| [Lucide](https://github.com/lucide-icons/lucide) | Lucide contributors | ISC (plus MIT for Feather-derived icons) |

## Tooling (not shipped)

| Project | Author | Licence |
|---|---|---|
| [TestEZ](https://github.com/Roblox/testez) | Roblox | Apache-2.0 |
| [Wally](https://github.com/UpliftGames/wally) | Uplift Games | MPL-2.0 |

## Notes

- No external runtime assets are loaded. Everything draws with Roblox
  primitives, the bundled icon data, or the Roblox glyph fallback.
- Full licence texts are available at the links above.
