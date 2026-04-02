# Contributing to World Conqueror Strategy

Thank you for your interest in contributing! This guide will help you get started.

## Getting Started

### Prerequisites
- GDevelop 5 (download from [gdevelop.io](https://gdevelop.io))
- Image editor (GIMP, Photoshop, or [Piskel](https://www.piskelapp.com/) for pixel art)
- A GitHub account

### Setup
1. Fork the repository
2. Open `WorldConquerorStrategy.json` in GDevelop
3. Click Preview to test

## How to Contribute

### Adding New Units
1. Create a new Sprite object in GDevelop
2. Add standard unit variables (Health, MaxHealth, Attack, Defense, MovementPoints, etc.)
3. Add selection, movement, and combat events for the new unit
4. Update the balance spreadsheet

### Adding New Terrain
1. Create terrain sprite (200x150px)
2. Add Region instance with correct variable values
3. Update movement and combat events for terrain effects

### Adding Campaign Missions
1. Create a new GDevelop scene
2. Set up starting positions and objectives
3. Add victory/defeat conditions
4. Link from the main menu scene

### Art & Design
- Unit sprites: 40x40px, PNG with transparency
- Terrain tiles: 200x150px, PNG format
- UI elements: Match existing style, dark theme
- Color palette: Use the existing color scheme for consistency

## Code Style

Since this is a no-code project using GDevelop events:
- Use descriptive names for events and groups
- Add comment events to explain complex logic
- Keep event groups modular and single-purpose
- Use the existing variable naming convention (PascalCase)

## Reporting Bugs

1. Open an [Issue](https://github.com/yayass3r/World-Conqueror-Strategy/issues)
2. Describe the bug in detail
3. Include steps to reproduce
4. Specify your device and GDevelop version

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
