# Technical information
This document will describe the architecture of Astrofix. In other words, this is where the "what and why" are explained.

## Game architecture
<!-- maybe clean the table formatting -->
| Key | Value |
|-|-|
| Game engine | [Godot](https://godotengine.org/releases/4.4/) |
| Programming language | GDScript (a python-like language) |
| Rendering | Vulkan (2D) |

### Rendering
| Key | Value |
|-|-|
| Canvas size | `1280x720` |
| Game artboard | `360x180` |
| Assets art style | Pixel art |
| UI | Non-pixel art |

## Project structure
Project structure is somewhat disorganized, but this will be fixed soon.
```
addons/
art/
  characters/
    (art relating to major characters)
  fonts/
    (fonts used)
  level_1/
    (level specific art)
  ...
  level_5/
  logos/
    (logos and other images relating to branding)
  objects/
    (images for objects relating
  tilesets/
    (tileset images)
audio/
  music/
    (background music throughout the game)
  sfx/
    (sfx throughout the game)
cutscenes/
  data/
    level_1.tres
    (where cutscenes are made)
  images/
    level_1/
      01.png
      (images relating to each scene)
      ...
  music/
    level_1.wav
    (music)
  sfx/
    level_1/
      (sfx relating to level 1 cutscene)
dialogue/
  (DialogueManager files)
docs/
  (markdown files)
export/
  (game export)
scenes/
  characters/
    (characters)
  levels/
    level_1/
      (see below)
      ...
  objects/
    (objects used throughout the game, i.e. oxygen, fuel)
  screens/
    (gui and UI specific screens)
  themes/
    (theme resources)
  main.tscn
scripts/
  autoloads/
    (Singletons used for game state)
  levels/
    (scripts for levels)
  objects/
    (scripts for generic objects throughout the game)
  screens/
    (scripts for GUI/UI)
```

Level structure is very finicky, and is somewhat inconsistent with the rest of the folder structure:
```
level_1/
  level_1.tscn
  (`level_1.gd` is in `/scripts/levels/level_1.gd`)
  decorations/
    deco.tscn
    deco.gd
  objects/
     obj_1.tscn
     obj_1.gd
    ..
```

## Tools used
### For concept art and drafts
* GoodNotes
* Excalidraw

### For art and design
* Capcut
* ibisPaint
* Pixilart
* Canva
