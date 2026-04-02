# World Conqueror Strategy - Changelog

## [2.0.0] - 2026-04-03
### Major Enhancements
- **Unit Recruitment System** - Recruit Infantry (50g), Tank (100g), Aircraft (150g) from owned cities
- **Commander System** - 6 commander types with aura buffs (+ATK%, +DEF%, +MOV) and special abilities
- **Tutorial System** - 6-step interactive tutorial with overlay, arrows, and skip button
- **Difficulty Selection** - 4 levels: Easy, Normal, Hard, Brutal with AI scaling
- **Achievement System** - 30 achievements with popup notifications
- **Fog of War** - Hidden map tiles revealed by unit proximity
- **Daily Reward System** - 30-day rotating login rewards
- **Unit Veterancy** - XP, Level (1-3), stat bonuses per level

### New Objects (+27)
- RecruitButton, RecruitPanel, RecruitInfantry, RecruitTank, RecruitAircraft
- Commander, Commander (AI), CommanderBuffCircle
- TutorialOverlay, TutorialText, TutorialArrow, SkipButton
- DifficultyPanel, EasyBtn, NormalBtn, HardBtn, BrutalBtn
- AchievementPopup, AchievementPopupText
- FogTile, VeteranStar
- DailyRewardPanel, DailyRewardDay1-7, ClaimRewardBtn

### New Scene Variables (+36)
- Recruitment: CanRecruit, SelectedCityX, SelectedCityY, PlayerOwnsCity
- Commander: PlayerCommanderActive, AICommanderActive
- Tutorial: TutorialStep, TutorialEnabled, ShowTutorial
- Difficulty: Difficulty, AIGoldMultiplier, AIATKBonus, AIHPBonus, AIThinkDelay, DifficultySelected
- Achievement: TotalKills, TotalCitiesCaptured, TotalTurnsPlayed, GamesWon, GamesLost, Achievement1-6
- Daily: DailyRewardDay, LastDailyReward, ShowDailyReward
- Fog: Various fog state variables

### New Event Groups (+10)
- COMMANDER BUFF, TUTORIAL SYSTEM, DIFFICULTY SELECTION, ACHIEVEMENT TRACKER
- FOG OF WAR, DAILY REWARDS, UNIT VETERANCY, RECRUITMENT SYSTEM
- VETERANCY LEVEL UP, AI COMMANDER AI

### Stats
- Game Objects: 22 → 49 (+123%)
- Scene Variables: 13 → 49 (+277%)
- Events: 33 → 113 (+242%)
- Event Groups: 13 → 23 (+77%)
- Instances: 35 → 60 (+71%)

## [1.0.0] - 2026-04-03
### Initial Release
- Core turn-based strategy gameplay
- 3 unit types: Infantry, Tank, Aircraft
- 6 terrain types
- 20-region strategic map
- AI opponent
- Economy system
- Mobile touch controls
- Health bars and damage text
- Win/loss conditions
