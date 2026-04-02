# World Conqueror Strategy

<p align="center">
  <img src="https://img.shields.io/badge/Engine-GDevelop_5-blue" alt="GDevelop 5">
  <img src="https://img.shields.io/badge/Genre-Turn_Based_Strategy-green" alt="Strategy">
  <img src="https://img.shields.io/badge/Platform-Android_iOS_Web-orange" alt="Cross-Platform">
  <img src="https://img.shields.io/badge/License-MIT-yellow" alt="License">
  <img src="https://img.shields.io/badge/Status-Prototype_Ready-success" alt="Status">
</p>

<p align="center">
  <strong>Mobile Turn-Based Strategy Game</strong><br>
  Inspired by World Conqueror 4 | Built with GDevelop Visual Event System
</p>

---

## About The Game

World Conqueror Strategy is a turn-based strategy game where you command military forces across a strategic map. Deploy infantry, tanks, and aircraft to conquer enemy territories, manage your economy, and outsmart an AI opponent.

### Key Features

- **Turn-Based Combat** - Strategic combat with damage calculations, terrain bonuses, and unit counters
- **3 Unit Types** - Infantry, Tank, and Aircraft each with unique stats and roles
- **6 Terrain Types** - Plains, City, Desert, Mountain, Forest, and Sea with strategic modifiers
- **AI Opponent** - Intelligent AI that pursues, attacks, and adapts to your strategy
- **Economy System** - Cities generate gold; control territory to fund your war machine
- **Mobile-First Design** - Touch controls, large UI elements, optimized for phones and tablets
- **2 Difficulty Levels** - Easy and Normal AI with scalable challenge

## Quick Start

### Play in Browser
1. Open [editor.gdevelop.io](https://editor.gdevelop.io)
2. Click **New Project** > **Import**
3. Upload `WorldConquerorStrategy.json`
4. Click **Preview** to play immediately

### Build for Mobile

#### Android (APK)
1. Open the project in GDevelop
2. Go to **Project** > **Build for Android**
3. Download the generated APK
4. Install on any Android device

#### iOS
1. Open the project in GDevelop
2. Go to **Project** > **Build for iOS**
3. Open the generated Xcode project on macOS
4. Compile and submit to App Store

## Project Structure

```
World-Conqueror-Strategy/
├── WorldConquerorStrategy.json   # Main GDevelop project file
├── docs/
│   └── World_Conqueror_GDevelop_Guide.pdf  # 23-page development guide
├── assets/
│   ├── sprites/                  # Unit sprite assets
│   ├── terrain/                  # Terrain tile sprites
│   ├── ui/                       # UI button and panel assets
│   └── effects/                  # Explosion and effect sprites
├── design/
│   └── Game_Balance_Data.xlsx    # Balance sheets and formulas
├── ROADMAP.md                    # Development roadmap
└── README.md                     # This file
```

## Game Systems

### Units
| Unit | HP | ATK | DEF | MOV | Range | Cost |
|------|----|-----|-----|-----|-------|------|
| Infantry | 100 | 20 | 5 | 3 | 1 | 50 |
| Tank | 200 | 40 | 15 | 2 | 1 | 100 |
| Aircraft | 80 | 50 | 2 | 4 | 2 | 150 |

### Terrain Modifiers
| Terrain | Move Cost | DEF Bonus | Income | Passable By |
|---------|-----------|-----------|--------|-------------|
| Plains | 1 | 0% | 0 | All |
| City | 1 | +20% | 20/turn | All |
| Desert | 2 | -10% | 0 | Infantry, Aircraft |
| Mountain | 3 | +30% | 5/turn | Infantry |
| Forest | 2 | +15% | 0 | Infantry, Aircraft |
| Sea | 1 | -20% | 0 | Aircraft |

### Combat Formula
```
Base Damage = ATK * Random(0.8, 1.2)
Defense = DEF * (1 + TerrainBonus/100)
Final Damage = Max(Base - Defense, 5)
Critical Hit = 10% chance, 1.5x damage
Counter Attack = 50% damage if in range
```

## Controls

| Action | Input |
|--------|-------|
| Select Unit | Tap a friendly unit |
| Move Unit | Tap a region after selection |
| Attack Enemy | Tap an enemy within range |
| Deselect | Tap empty area |
| End Turn | Tap "END TURN" button |

## Tech Stack

- **Game Engine**: [GDevelop 5](https://gdevelop.io/) (Visual Event System)
- **Target Platforms**: Android, iOS, Web (HTML5)
- **Design Tool**: Any image editor for sprites (40x40px recommended)

## Documentation

- [Development Guide (PDF)](docs/World_Conqueror_GDevelop_Guide.pdf) - Complete 23-page step-by-step guide
- [Game Balance Data (XLSX)](design/Game_Balance_Data.xlsx) - Unit stats, terrain, economy, tech tree
- [Roadmap](ROADMAP.md) - Future development plans

## How to Contribute

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes in GDevelop
4. Test thoroughly
5. Commit and push: `git commit -m "Add feature"`
6. Open a Pull Request

## Roadmap Highlights

- [x] Core prototype with movement and combat
- [x] AI opponent
- [x] Economy system
- [ ] Multiplayer (online)
- [ ] Campaign mode with 20+ missions
- [ ] Tech tree research system
- [ ] Unit recruitment from cities
- [ ] Weather effects system
- [ ] Leaderboards and achievements
- [ ] Sound effects and music

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  Built with GDevelop | No Code Required<br>
  <strong>Conquer the World, One Turn at a Time</strong>
</p>
