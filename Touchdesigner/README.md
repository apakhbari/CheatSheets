# TouchDesigner


## User Interface
- navigation bar
- pame (main network system)
- timeline
- palete

## Shortcuts
- opening operator tab: double click anywhere on pane OR TAB
- openning parameters of an operator: ` P `
- When you have toggled ` viewer active ` : 
  - If you press ` H ` you go back to its initial position
  - If you press ` W ` you see its wireframe version

## Operators
- COMP: components - can hold other compenets
- TOP: Texture Operators - deal with 2d imagary and pixels - video and image based - craete 2d shapes - text - render a 3d object to 2d image - works directly on GPU (so it's fast)
- CHOP: Channel Operators - data and signal - audio channels - creating random number - MIDI controller - microsoft kinect
- SOP: Surface Operators - 3d geometry - processed on CPU (not that fast) - don't do too many of this family at once 
- MAT: materials - color and image on objects - works on GPU
- DAT: Data family - plain text - input a csv file - scripts. If you want to do some python scripts, Use this operator

- You can't connect different families of operators to eachother
- The flow of operators is from left to right

## TOP
- For adding/differentiating and lots of other processes, ` composite ` is a pretty good operator
- ` null ` operators are for when you need an endpoint, whether for connecting something to other families, whether to export it

## CHOP
- When we are working on audio in TD, we are in CHOP world


## COMP
- base: is a container for our things, used to structure our networks
- container: is also a container but for outputing. It is good for creating UI
  

## Tips & Tricks
- Instancing happens on GPU

Add contents to touchdesigner.md
https://www.youtube.com/watch?v=_W_qOMhEnfI&list=PLFrhecWXVn5862cxJgysq9PYSjLdfNiHz&index=18
15 audio overview - 00:00

# acknowledgment
## Contributors

APA 🖖🏻

## Links
[Glossary](https://docs.derivative.ca/TouchDesigner_Glossary)

A few great artists:
https://vincenthouze.com/
http://www.maotik.com/
https://www.simonaa.media/
http://www.ryoichikurokawa.com/projec...
https://push1stop.com/

## APA, Live long & prosper
```
  aaaaaaaaaaaaa  ppppp   ppppppppp     aaaaaaaaaaaaa
  a::::::::::::a p::::ppp:::::::::p    a::::::::::::a
  aaaaaaaaa:::::ap:::::::::::::::::p   aaaaaaaaa:::::a
           a::::app::::::ppppp::::::p           a::::a
    aaaaaaa:::::a p:::::p     p:::::p    aaaaaaa:::::a
  aa::::::::::::a p:::::p     p:::::p  aa::::::::::::a
 a::::aaaa::::::a p:::::p     p:::::p a::::aaaa::::::a
a::::a    a:::::a p:::::p    p::::::pa::::a    a:::::a
a::::a    a:::::a p:::::ppppp:::::::pa::::a    a:::::a
a:::::aaaa::::::a p::::::::::::::::p a:::::aaaa::::::a
 a::::::::::aa:::ap::::::::::::::pp   a::::::::::aa:::a
  aaaaaaaaaa  aaaap::::::pppppppp      aaaaaaaaaa  aaaa
                  p:::::p
                  p:::::p
                 p:::::::p
                 p:::::::p
                 p:::::::p
                 ppppppppp
```