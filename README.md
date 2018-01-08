# Unity Shaders

This repository contains a variety of shaders developed for use in Unity. These shaders have tested were made for use in Unity 5 and may not be compatible with earlier versions of Unity, however many of them can easily be modified to work in a variety of settings.


### Table of Contents
* Toon Water
* Heat Haze
* Eye Effect
* Television
* Purkinje


## Toon Water
A surface shader in the toon style used in Wind Waker. The shader takes a single texture for the shape of the sea foam. Additional scripts are included to support buoyancy of game objects and synchronizing wave motion with the game time to support various effects.  

![Toon Water Gif](https://github.com/chairswithlegs/shaders/blob/master/Gifs/toon%20water.gif?raw=true)

## Heat Haze

An image effect simulating the visual distoration caused by hot air. The only asset required is a noise texture. This shader utilizes the depth buffer to increase the visual distoration of objects that are far away.

![Heat Haze Gif](https://github.com/chairswithlegs/shaders/blob/master/Gifs/heat%20haze.gif?raw=true)


## Eye Effect

An image effect that combines combines a vignette with a flexible vertical blur to give the impression that the camera is an eye. This image effect uses a vignette gradient to control the shape of the eyelids. One can easily create an effect similar to the one below by animating the image effect with Unity's Mecanim.
![Eye Effect Gif](https://github.com/chairswithlegs/shaders/blob/master/Gifs/eye%20blink.gif?raw=true)


## Television

A highly flexible image effect that can turn the camera into CRT television or an old school film projector. In addition to containing features such as scan lines, noise, and a vignette, the additional color and luminosity controls allow you to create a variety of effects, including the always popular night vision.
![Night Vision Gif](https://github.com/chairswithlegs/shaders/blob/master/Gifs/television.gif?raw=true)


## Purkinje

An image effect that simulates the [Purkinje effect](https://en.wikipedia.org/wiki/Purkinje_effect), i.e. the tendency for certain colors to appear less vibrant to the human eye at low levels of illumination. The gif below shows the same scene with and without the Purkinje effect.
![Purkinje Gif](https://github.com/chairswithlegs/shaders/blob/master/Gifs/purkinje.gif?raw=true)
