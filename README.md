# Brave Frontier Godot

This is a partial remake of the mobile game Brave Frontier. Brave frontier shutdown within the last year. This project implements many of the same features and structure.

![Home screen, team selector, and battle scenes](https://github.com/aMytho/brave-frontier-godot/assets/58316242/b7d97886-8e13-4c37-a58e-ace2fbb32f8f)

We are **not** remaking the full game. This project solely exists so we can practice with the Godot game engine. If you want to play the full game again, have a look at [Brave Frontier Recoded](https://www.bravefrontierrecoded.online//).

*Side note, if any of the BFR folks want to use this project, they are more than welcome to!

## Key Differences
This project has several features. Many are different compared to the original. Unlike the ReCoded project, we do not intend to complete the full game. Instead, we will build the base systems and allow the players to create what they want.

Users can:
- Create custom units.
- Create custom animations for new/existing units
- Create their own dungeons and stages (levels).

The project is open source so changes that require code (such as adding a new feature) could also be added.

## Main Features

- Experience basic combat.
- Play through a few of the early levels.
- - Once you've beaten them, try [Creating Your Own](https://github.com/aMytho/brave-frontier-godot/wiki/Creating-a-Unit)!
- - If you can't beat them, add more units via the Dev Menu on the Unit Page.
- Add units via the dev menu. All summoners start with one of the Six Heroes and a Sparky and Burny.
- View the old menus and manage your team.
- Create multiple accounts to test different team combinations.
- View dialogue-based scenes.
- Single-player, offline only.

## Creating Custom Levels/Units/Animations

All related info is on our [Wiki](https://github.com/aMytho/brave-frontier-godot/wiki)

## Requirements

Brave-Frontier-Godot can run on Windows, Mac, and Linux. However, only windows and Linux have been tested. Mobile *may* work, but it would require that the game be ran from the engine instead of the production build.

> In the following week I will provide production builds of the current state of the project. These will not require the engine to use. Windows and Linux only.

## Installation

You must download the [Godot Engine v4.2.x](https://godotengine.org/) (normal installation) and [this project](https://github.com/aMytho/brave-frontier-godot/archive/refs/heads/main.zip) to play the game. Once both are downloaded, open Godot and import the project. It will take a few minutes. Once complete, hit the play button near the top right of the editor and the game will begin.

![image](https://github.com/aMytho/brave-frontier-godot/assets/58316242/dc721d08-9b28-419c-9fa7-f0081977e39c)

You will have to sit through the Lucius cutscene (Sorry!), create an account, choose a starter unit, and beat the first level. Then you are able to move between the existing levels. 

For development purposes, we only have a few levels in the in-game selector, but you can easily add more with Godot resources. This is a **very** beginner friendly engine, and we highly suggest you tinker with it! If you have any questions, create an issue to receive support. We are all volunteers, but we will do our best to respond in a timely fashion.

## Tech Stack

Most of the data (Units, animations, etc) is stored as Godot resource files. For example, each unit works off of the [unit_base](https://github.com/aMytho/brave-frontier-godot/blob/main/Units/unit_base.gd) and extends it with its own properties. This differs from the JSON and CSV data that the original game used.

Player data is stored in an SQLite database. Rather than keep a full record of all player units, items, and other data, the database only contains what data the player has modified. For example, when the player acquires a unit it is added to the DB. When the player views the unit, we load the data from the DB and override the godot resource.

![DB and Godot Resource](https://github.com/aMytho/brave-frontier-godot/assets/58316242/39dacee8-5dc4-462b-b888-9dc1dc17227f)


Unlike the original game, this is a purely offline implementation. There are no plans to add multiplayer of any kind. As noted above, this project is just for practice with the Godot engine.

## Contributing

We do accept contributions for new levels, units, and features. We ask that you try to follow our [coding guidelines](https://github.com/aMytho/brave-frontier-godot/issues/28). If you want to add a feature but are not sure how, open an issue! We would be happy to discuss ideas and implementation details.

If you have received any value from the project, consider starring it on Github. This boosts its discoverability and allows others to find the project.

## Copyright Notice

We do not own any of the assets. They are owned by Gumi / Alim and the Brave Frontier team. This project earns no revenue and is purely for educational purposes.
