# Amphimorpho Base for Figura
Amphimorpho species is not mine, it is TuxedoDragon's work. [See this carrd](https://amphimorpho.carrd.co/) for more info about them.

This model has the geometry set up, and an easy to edit texture. You can also press a key (tab by default) to stand up; you also automatically stand up when using items with custom animations - the shield, for example - so things look nice. You can even transform into a "human" (default playermodel) form and back.

## Development Roadmap
If things are separated into multiple versions, it's probably because of changes in the future versions requiring a change to the texture UVs. I want to keep those as consistant as possible so updating your version to a new base is as easy as possible.

Current model version: 1.1

### Version 1.2
* Completely rework the animation system to be more data based, which will also make the transformation sequence easier
* Make code more readable and easier to edit (particularly for the transformation handler so that retracting added parts is straightforward)
* Add ducking animation to match with camera perspective adjusting to prevent seeing through walls
* Antennae sprites (may be pushed to 2.0 if I can't make room for em)

### Version 2.0
* Add a second pair of arms, which can be toggled on and off.
* Expand the texture to accomodate for the new limbs.
