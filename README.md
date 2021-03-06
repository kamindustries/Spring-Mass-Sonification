# Spring-Mass-Sonification
### Sonification using a Spring-Mass system in TouchDesigner

![alt-tag](thumb.jpg)

This is an example of running a spring-mass simulation on the GPU and using it as a foundation for sonification in TouchDesigner. The spring system is based on [an example by Paul Bourke](http://paulbourke.net/miscellaneous/particle/) with additional impulse and anchor forces added.

Each spring connects to its neighbor horizontally to create a group of strings. The number of strings is controlled by the height of the texture. The difference between a string's current position and its rest position becomes a waveform which is oscillated at audio rates to produce sound. Frequencies are mapped to notes with A4 = 440Hz.  The x and y axes map to the left and right channels. Mouse velocity is used as the impulse force.

Different kinds of attack/decay/sustain/release envelopes can be derived by adjusting the impulse, anchor, and drag forces on the glsl_spring_system node.



#### Licensing
Spring-Mass-Sonification code is released under the [MIT License](https://github.com/kamindustries/Spring-Mass-Sonification/blob/master/LICENSE).