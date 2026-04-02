# World Conqueror Strategy

<p align="center">
  <img src="https://img.shields.io/badge/Engine-GDevelop_5-blue" alt="GDevelop 5">
  <img src="https://img.shields.io/badge/Version-2.0_Enhanced-green" alt="v2.0">
  <img src="https://img.shields.io/badge/Platform-Android_iOS_Web-orange" alt="Cross-Platform">
  <img src="https://img.shields.io/badge/Systems-8_Major-purple" alt="Systems">
  <img src="https://img.shields.io/badge/License-MIT-yellow" alt="License">
</p>

<p align="center">
  <strong>Mobile Turn-Based Strategy Game</strong><br>
  Inspired by World Conqueror 4 | Built with GDevelop Visual Event System<br>
  <em>No Code Required</em>
</p>

---

## About The Game

World Conqueror Strategy is a turn-based strategy game where you command military forces across a strategic map. Deploy infantry, tanks, and aircraft to conquer enemy territories, manage your economy, recruit new units, lead legendary commanders, and outsmart an AI opponent across 20 campaign missions.

### Key Features (v2.0 Enhanced)

- **Turn-Based Tactical Combat** - Deep combat with damage formulas, terrain bonuses, critical hits, counter-attacks, and commander buffs
- **7 Unit Types** - Infantry, Tank, Aircraft, Artillery, Anti-Air, Scout, Marine - each with unique stats and roles
- **6 Commanders** - Hero units with aura buffs (+ATK, +DEF, +MOV) and special abilities
- **10 Terrain Types** - Plains, City, Desert, Mountain, Forest, Sea, Bridge, HQ, Ruins, Port
- **AI Opponent (4 Difficulties)** - Easy, Normal, Hard, Brutal with scaling stats
- **20-Mission Campaign** - Progressive difficulty from Tutorial to Brutal
- **Unit Recruitment** - Hire new units from cities using gold
- **Unit Veterancy** - Units gain XP, level up (L1-L3), unlock stat bonuses
- **Fog of War** - Hidden map revealed by unit proximity
- **30 Achievements** - Combat, Economy, Territory, and Meta categories
- **Daily Login Rewards** - 30-day rotating rewards cycle
- **Interactive Tutorial** - 6-step guided tutorial for new players
- **Economy System** - Cities generate gold, unit maintenance costs
- **Mobile-First Design** - Touch controls, optimized for phones and tablets

## Quick Start

### Play in Browser
1. Open [editor.gdevelop.io](https://editor.gdevelop.io)
2. Click **New Project** > **Import**
3. Upload `WorldConquerorStrategy_v2.json`
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
├── WorldConquerorStrategy_v2.json        # Enhanced v2.0 GDevelop project
├── WorldConquerorStrategy.json           # Original v1.0 prototype
├── docs/
│   ├── index.html                        # Landing page (GitHub Pages)
│   ├── World_Conqueror_GDevelop_Guide.pdf    # 23-page development guide
│   ├── Marketing_Kit.pdf                # 25-page marketing & launch strategy
│   └── Game_Success_Guide_Arabic.pdf     # Expert success recommendations
├── design/
│   ├── Game_Balance_Data_v2.xlsx         # v2 balance sheets (10 tabs)
│   └── Game_Balance_Data.xlsx            # v1 balance sheets
├── assets/
│   ├── banner.png                        # Game banner artwork
│   ├── sprites/                          # Unit sprite assets
│   ├── terrain/                          # Terrain tile sprites
│   ├── ui/                               # UI button and panel assets
│   └── effects/                          # Explosion and effect sprites
├── ROADMAP.md                            # Development roadmap
├── CHANGELOG.md                          # Version history
├── CONTRIBUTING.md                       # Contribution guide
├── LICENSE                               # MIT License
└── README.md                             # This file
```

## Game Systems

### Units (7 Types)
| Unit | HP | ATK | DEF | MOV | Range | Cost | Unlock |
|------|----|-----|-----|-----|-------|------|--------|
| Infantry | 100 | 20 | 5 | 3 | 1 | 50 | Start |
| Tank | 200 | 40 | 15 | 2 | 1 | 100 | Start |
| Aircraft | 80 | 50 | 2 | 4 | 2 | 150 | Start |
| Scout | 60 | 10 | 3 | 5 | 1 | 40 | Turn 2 |
| Anti-Air | 90 | 15 | 10 | 2 | 2 | 80 | Turn 3 |
| Artillery | 120 | 35 | 3 | 1 | 3 | 120 | Turn 5 |
| Marine | 130 | 25 | 8 | 3 | 1 | 90 | Turn 7 |

### Commanders (6 Types)
| Commander | Specialty | ATK Buff | DEF Buff | Aura | Unique |
|-----------|-----------|----------|----------|------|--------|
| General Alpha | Infantry | +10% | +5% | 200px | +5 XP gain |
| Iron Tanker | Tanks | +15% | +10% | 200px | +1 range at L3 |
| Sky Marshal | Aircraft | +20% | 0% | 250px | Ignore terrain |
| Defender | Defense | 0% | +20% | 300px | HP regen in city |
| Scout Master | Recon | +5% | +5% | 350px | Extended vision |
| War Hero | All | +25% | +15% | 200px | All buffs |

### Terrain (10 Types)
| Terrain | Move Cost | DEF Bonus | Income | Passable By |
|---------|-----------|-----------|--------|-------------|
| Plains | 1 | 0% | 0 | All |
| City | 1 | +20% | 20/turn | All |
| Desert | 2 | -10% | 0 | Infantry, Aircraft |
| Mountain | 3 | +30% | 5/turn | Infantry |
| Forest | 2 | +15% | 0 | Infantry, Aircraft |
| Sea | 1 | -20% | 0 | Aircraft, Marine |
| Bridge | 1 | -10% | 0 | All |
| HQ | 1 | +40% | 30/turn | All |
| Ruins | 2 | +10% | 5/turn | Infantry, Aircraft |
| Port | 1 | +5% | 15/turn | All |

### Combat Formula (v2 Enhanced)
```
Base Damage = ATK * (1 + CommanderBuff/100) * (1 + LevelBonus/100) * Random(0.8, 1.2)
Defense = DEF * (1 + TerrainBonus/100) * (1 + CommanderBuff/100) * (1 + LevelBonus/100) * 0.5
Final Damage = Max(Base - Defense, 5)
Critical Hit = 15% chance, 1.5x damage
Counter Attack = 50% damage if in range
Veterancy: L2 = +10% ATK/+5% DEF, L3 = +20% ATK/+10% DEF/+1 Range
```

### Difficulty Levels
| Level | AI Gold | ATK Bonus | HP Bonus | Think Time |
|-------|---------|-----------|----------|------------|
| Easy | 1.0x | 0% | 0% | 2.0 sec |
| Normal | 1.2x | 10% | 10% | 1.0 sec |
| Hard | 1.5x | 20% | 20% | 0.5 sec |
| Brutal | 2.0x | 30% | 30% | 0.2 sec |

## Controls

| Action | Input |
|--------|-------|
| Select Unit | Tap a friendly unit |
| Move Unit | Tap a region after selection |
| Attack Enemy | Tap an enemy within range |
| Recruit Unit | Tap RECRUIT button (requires city) |
| Deselect | Tap empty area |
| End Turn | Tap "END TURN" button |

## Project Statistics

| Metric | v1.0 | v2.0 | Change |
|--------|------|------|--------|
| Game Objects | 22 | 49 | +123% |
| Scene Variables | 13 | 49 | +277% |
| Events | 33 | 113 | +242% |
| Unit Types | 3 | 7 | +133% |
| Commanders | 0 | 6 | New |
| Achievements | 0 | 30 | New |
| Campaign Missions | 0 | 20 | New |
| Difficulty Levels | 1 | 4 | +300% |

## Documentation

| Document | Pages | Description |
|----------|-------|-------------|
| [Development Guide (PDF)](docs/World_Conqueror_GDevelop_Guide.pdf) | 23 | Complete GDevelop step-by-step guide |
| [Marketing Kit (PDF)](docs/Marketing_Kit.pdf) | 25 | App store listing, trailer script, social media, press release |
| [Success Guide (PDF)](docs/Game_Success_Guide_Arabic.pdf) | 8 | Expert recommendations for game success |
| [Balance Data v2 (XLSX)](design/Game_Balance_Data_v2.xlsx) | 10 tabs | Units, commanders, campaign, achievements, daily rewards, tech tree, monetization |
| [Balance Data v1 (XLSX)](design/Game_Balance_Data.xlsx) | 6 tabs | Original prototype balance data |
| [Roadmap (MD)](ROADMAP.md) | - | 6-phase development plan |

## How to Contribute

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes in GDevelop
4. Test thoroughly
5. Commit and push: `git commit -m "Add feature"`
6. Open a Pull Request

## Roadmap Highlights

- [x] Core prototype with movement and combat
- [x] AI opponent with 4 difficulty levels
- [x] Economy system with recruitment
- [x] Commander system with aura buffs
- [x] 20-mission campaign mode
- [x] Fog of war system
- [x] 30 achievements
- [x] Daily login rewards
- [x] Unit veterancy and leveling
- [x] Interactive tutorial
- [x] Marketing kit and launch strategy
- [ ] Multiplayer (online)
- [ ] Tech tree research system
- [ ] Weather effects system
- [ ] Sound effects and music
- [ ] Original art assets
- [ ] App Store & Google Play launch

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  Built with <a href="https://gdevelop.io">GDevelop</a> | No Code Required<br>
  <strong>Conquer the World, One Turn at a Time</strong>
</p>
