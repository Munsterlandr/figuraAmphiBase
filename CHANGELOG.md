# Info
Avatar version: 1.2a

Texture's accessory layers have basically the same UVs as the base layers, but shifted horizontally +64 pixels.

## Changes
* rewriting code from (almost) scratch to redo the animation system

## Known issues
* animations for using a spyglass and blowing a horn don't look good
* nameplate does not move to a better looking spot (I might fix this later, but it's not easy to test by myself so it could take some time lol)
* new anim system is super lag inducing, particularly on the render function. I plan on doing stuff to optimize it, but it'll defs be tough.