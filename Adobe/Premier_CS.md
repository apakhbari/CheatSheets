# Adobe Premier Pro

```
 _______  ______   _______  _______  _______      _______  ______    _______  __   __  ___   _______  ______        _______  ______    _______ 
|   _   ||      | |       ||  _    ||       |    |       ||    _ |  |       ||  |_|  ||   | |       ||    _ |      |       ||    _ |  |       |
|  |_|  ||  _    ||   _   || |_|   ||    ___|    |    _  ||   | ||  |    ___||       ||   | |    ___||   | ||      |    _  ||   | ||  |   _   |
|       || | |   ||  | |  ||       ||   |___     |   |_| ||   |_||_ |   |___ |       ||   | |   |___ |   |_||_     |   |_| ||   |_||_ |  | |  |
|       || |_|   ||  |_|  ||  _   | |    ___|    |    ___||    __  ||    ___||       ||   | |    ___||    __  |    |    ___||    __  ||  |_|  |
|   _   ||       ||       || |_|   ||   |___     |   |    |   |  | ||   |___ | ||_|| ||   | |   |___ |   |  | |    |   |    |   |  | ||       |
|__| |__||______| |_______||_______||_______|    |___|    |___|  |_||_______||_|   |_||___| |_______||___|  |_|    |___|    |___|  |_||_______|
```

## Table of Contents
1. [Shortcuts](#shortcuts)
2. [Source Window (north west)](#source-window-north-west)
3. [Monitor Panel (north east)](#monitor-panel-north-east)
4. [TimeLine (south east)](#timeline-south-east)
5. [Project (south west)](#project-south-west)
6. [Audio](#audio)
7. [Definition](#definition)
8. [Links](#links)
9. [Tips & Tricks](#tips--tricks)
10. [Implementation](#implementation)
    1. [Proxies](#proxies)
    2. [Media Browser](#media-browser)
    3. [Render In & Render Out](#render-in--render-out)
    4. [Cache & scratch disk](#cache--scratch-disk)
10. [TimeLine tricks](#timeline-tricks)
11. [Color](#color)
12. [Transitions](#transitions)
13. [Stabilizing](#stabilizing)
14. [Freeze & Hold Frame](#freeze--hold-frame)
15. [Tools](#tools)
16. [Slow Motion](#slow-motion)
17. [Effects](#effects)
18. [Storyboard](#storyboard)
19. [Link vs Group vs Nest & subclip](#link-vs-group-vs-nest--subclip)
20. [Essential graphics](#essential-graphics)
21. [File Management](#file-management)
22. [Audio](#audio-1)
23. [Subtitles](#subtitles)
24. [Export](#export)

---

## Shortcuts

- Expand section to full screen → ~
- Zooming in timeline → + for zoom in & \ for zoom out
- Zooming all in to a specific frame in timeline → Option + /
- Changing height of Tracks in Timeline → Select Timeline, Command + +/- OR double click in gray left area
- Changing height of Audio in Timeline → Select Timeline, Option + +/- OR double click in gray left area
- Minimizing all clips in timeline → Shift + -
- Maximizing all clips in timeline → Shift + +
- Timeline Track Height Preset → Command + 1
- View a clip of timeline in source monitor → Select clip + F
- Cancelling connection between video and audio of a clip in timeline → Hold Option key
- Find → Command + F
- Define In and Out in source window to import in timeline → I & O
- Jump 1 frame forward or back in timeline → Arrow keys ← →
- Jump 5 frames forward or back in timeline → Shift + Arrow keys ← →
- Shifting a clip/audio 1 frame at a time in timeline → Command + Arrow keys ← →
- Shifting a clip/audio 5 frames at a time in timeline → Command + Shift + Arrow keys ← →
- Doing an action (toggle lock/mute) in all of tracks of timeline → Hold Shift while clicking on appropriate button
- When lots of tabs are open, to close them all → Command + click on title of one of the Tabs

---

## Source Window (north west)

- Can mark a moment of video → M

---

## Monitor Panel (north east)

- Monitor Panel (north east) zoom in → Control + +
- Monitor Panel (north east) zoom out → Control + -
- Monitor Panel (north east) zoom to fit → Control + 0
- Move around in zoomed Monitor panel so mouse turns to a hand → Hold H

---

## TimeLine (south east)

- ⭐ Go back 2 seconds in time while playing → Shift + K
- Mark a moment → M
- Make clip shorter → Hold Option + Cut from side of clip
- Looping a part of video → Shift + K
- ⭐ Define In and Out in timeline window to trim → W & Q
  - Cut all that is after this moment → W
  - Cut all that is before this moment → Q
- Add a Clip KeyFrame → Hold command
- ⭐ Cut clip wherever play head bar ▶️ is for targeted layer → Command + K
- Cut clip wherever play head bar ▶️ is for all layer → Shift + Command + K
- Go to start and end of a clip → Hold Shift

---

## Project (south west)

---

## Audio

- You can lower/higher volume by using { or } shortcut on keyboard
- Hold Option key and click on one of fx buttons in Effect Controls to turn all effects off

---

## Definition

- Color Grading = Getting consistency across multiple shots
- Hue = Color
- Luma = Lightness
- Sat = Saturation
- Saturation = All the colors up/down, regardless of how strong they are initially
- Vibrance = Leave saturated colors alone, bring up/down other colors

---

## Links

- [pexels.com](https://www.pexels.com) → Free videos for using commercially
- [Elements.envato.com](https://elements.envato.com) → Music

---

## Tips & Tricks

- Convenient file structure for a project
  - Audio
  - Footage
  - Graphics
  - Project Files
  - Renders
- Bin is another name for folder
- h264 is very compressed and kind of hard for machine to interact with it. It is best practice to work with Format: QuickTime & Preset: Apple ProRes 422
- Naming standard of tracks: A roll (main one) - B roll - C roll
- It is best practice to start footage using an absolute white + black thing for later on color correction (clapper board 🎬 for example)
- Don’t have lights reflecting on your screen when you are doing color correction details. Do it in a dark room
- Use a color checker for tuning your camera (tell it this is 50% gray) and post-filming you can correct colors easier
- Whenever you think it's the best spot of effect range sliders, bring it a little back
- For changing the color of a clip: In Effects (south east) > Tint > Change black to whatever you want
- MP4 can’t have transparency, MOV can
- Window > History → For seeing all changes that have been made
- By Snap To Program Monitor you are able to use the mouse to position a logo

---

## Implementation

### Proxies

- Proxies: A lighter version of footage in order to edit it, on machine could be hard to process things because of being large or codec. When you render, the original one gets rendered
- First method: When you are in the middle of a project and realize your laptop can’t handle the process because of its heaviness
  - To create: Go to Media browser (left bottom), select all videos, right-click, choose Proxy > Create Proxies
  - To add in Premiere: In the right top window, find the + button (button editor) for hidden buttons, find toggle proxies
- Ingesting: Kind of proxy. Should be activated when you are creating your project. Choose “Create Proxy.” In this way, when you import, it is going to create proxies whenever you import something.
  - If you have not activated it when creating a new project: File > Project Settings > Ingest settings
- For relinking proxies to an old project or inherited project: Go to Media browser (left bottom), right-click on video, Proxy > Attach Proxies …
- For adding Proxy metadata display to Media browser (left bottom): Right-click on any metadata, search for proxy
- It is possible to export using proxies

### Media Browser

- Window > Media Browser, should appear in the bottom left
- It is good for bigger projects or when you are filming & editing yourself
- It’s a way of navigating in directories, inside Premiere without Finder
- For previewing footages in full size: Drag them in the source monitor (top left) and preview it

### Render In & Render Out

- Alternative to proxies, usually happens when we apply effects to our footage and it becomes heavy and can’t preview
- When in top right window, nav gets red; it’s a sign that it can’t be previewed because it needs lots of CPU, we can use proxies or Sequence Tab > Render In to Out
- For selecting parts of video, click + “i” on the starting point and then click + “i” on the ending point
- Shortcut is Enter

### Cache & Scratch Disk

- Cache is being made because, for example, MP3 is not that fast for Premiere to work with, so it creates CFA files as cache to work faster
- We create scratch files. They are Render In & Render Out
- For deleting cache: Premiere Pro Tab > Preferences > Media Cache > Delete Cache
- For deleting scratch disk: Sequence Tab > Delete Render Files
- For moving all of the projects to an external hard drive:
  - Premiere Pro Tab > Preferences > Media Cache > Media Cache Files > Browse
  - Premiere Pro Tab > Preferences > Media Cache Database > Browse
  - File Tab > Project Settings > Scratch Disks > Browse

---

## TimeLine Tricks

- For replacing a clip that has cuts and effects, drag a new clip and hold the option key OR right-click on the clip Replace With Clip > From bin
- If there is a shape for track heights that is desired, it is possible to make a preset for it and make a shortcut for it, so after it’s messy by hitting a shortcut, everything is in place again. To do that:
  - 🔧 (Timeline display setting) > Save Preset > Name: <name> & Keyboard Shortcut: Track Height Preset 1
- Sync lock: When you are adding a clip in timeline everything will shift. To stop shifting everything, we can lock or sync lock it. When we lock it, we can’t do any editing on it, but sync lock is like a soft lock; it won’t shift by the time a clip is added, but we are still able to edit
- Default Colors:
  - Audio + Video → Blue
  - Video → Purple
  - Audio → Green
  - Adjustment layers & styles → Magenta pink
- For changing the color of a clip:
  - In Timeline: Right-click Label Tab > Brown
  - In Media Browser: Right-click Label Tab > Brown
- For Renaming color names (labels) → Premiere Pro Tab > Preferences > Labels
- Video and audio of a clip are connected to each other, if you want to cancel that, use Link selection button in timeline OR Sequence Tab > Link selection OR hold option key and do what you want in timeline
- Thumbnails: For changing thumbnail (for example, to be at head and tail of clip), go to hamburger menu ☰ button in northwest of timeline and choose Video Head and Tail Thumbnails. You can hide thumbnails or text names of it from 🔧 (Timeline display setting)
- FX icon in clips:
  - Gray → Untouched
  - Yellow → Used effect controls (motion or opacity or scale)
  - Purple → Used effect panel (noise), or color adjustment
  - Green → Used effect controls, motion or opacity or scale + effect panel (noise), or color adjustment
- Match Frame: In a long interview when there are lots of cuts, for finding where this little clip is in original video, select it on timeline and bring play head bar ▶️ to the selected clip, then press F OR right-click and Reveal in Project
- Reverse Match Frame: When you want to see if you have used a video, first select it in your bin, then go to the moment you want to check if it’s in your video or not (00:32 for example), then Shift + R, if you’ve used it, it’s gonna pop
- How to check if my footage is being used in timeline?
  - In Project (bottom left) go to icon view, used footage has a blue badge at the bottom right of them, by clicking on the blue badge you can see where it’s being used
  - In Project (bottom left) go to list view, add video usage or audio usage tag to metadata
- Playback tricks:
  - L → Goes forward, LL → Double speed forward, LLL → Triple speed forward, Shift + L → Slowmo forward
  - J → Goes backward
  - K → Stop, Shift + K → Go back 2 seconds in time while playing
- Editing timeline Tricks:
  - For importing a clip from footage on Source Window (left top), set in and out then click Insert Button OR “,” shortcut OR Drag
  - Move a clip in timeline and press others along → Command + Option + drag clip
- Editing Zen:
  - Delete unused tracks in timeline: Click in gray empty space in north/south west of timeline, Delete Tracks > Video & Audio > Delete All empty Tracks
  - Customizing track buttons: Click in gray empty space in north/south west of timeline, Customize … >
  - Rename Tracks name as A roll - B roll - C roll
- Use razor tool for cutting a clip into multiple clips
- Option + Delete in timeline won’t leave a big hole in the timeline and is going to automatically adjust other clips
- Command + K → Cut clip wherever play head bar ▶️ is for targeted layer
- Shift + Command + K → Cut clip wherever play head bar ▶️ is for all layers
- Doing an action (toggle lock/mute) in all of the tracks of the timeline, you can hold Shift while clicking on the appropriate button

---

## Color

- It’s best practice to turn off proxies when working on colors
- The most important thing here: Get consistency in all your video, when there are 2 different cameras with 2 different lenses, result color should be consistent
- Matching color of 2 different clips: Window > Lumetri Color > Color Wheel & Match, click on Comparison view for a dual screen in Preview, in dual side, the left side is reference, click on Apply Match. It automatically corrects colors
- Lumetri Color > Curves > RGB Curves: Is for correcting highlights + shadows + RGB correctness. Double-click on the black curve box to go back to default. A simple S curve is going to work like a charm 90% of the time. Curves are another way of controlling contrast + shadow + highlight
- Lumetri Color > Curves > Hue Saturation Curves: It’s for correcting a spectrum of a color
- Some words:
  - Hue: Color
  - Luma: Lightness
  - Sat: Saturation
- Lumetri Color > HSL Secondary: It’s for selecting colors and then correcting them with a lot of controls. Key & Refine Tabs are for selecting colors, Correction Tab is for correcting colors. In this part, it is possible to select two different blues (for example) and correct each of them uniquely
- Lumetri was a company that made technologies, Adobe bought it and did not change the name of it
- Lumetri scopes can help us manage shadow + highlight + exposure correction. It is under Color pre-scope (north), right-click on Lumetric scope to customize, We use Waveform (RGB) with Waveform > Luma
- For correcting colors using Lumetri scopes we are using Color pre-scope (north), right-click on Lumetric scope to customize, We use Vectorscope YUV with Waveform > Luma, the center of scope is white, that line (north-west to south-west) is the skin tone line, which is a reference that skin tone looks great there

---

## Transitions

- For getting free premiere pro graphic transition MOGRT → Motionarray.com
- J & L Transition: Audio plays a big role in this one. Hold the command key for setting audio transition points in the audio timeline

---

## Stabilizing

- Effects > Warp Stabilizer
- Scene Edit Detection: When there is a rendered video that is jumping from this scene to that scene, it is convenient to use this tool in order to automatically slice it to same/original shots: Right-click > Scene Edit Detection

---

## Freeze & Hold Frame

- Freeze frame pause: Go to the moment you want in timeline, right-click > Insert Frame Hold Fragment
- Hold frame (at the end of YouTube video): Go to the moment you want in timeline, right-click > Add Frame Hold

---

## Tools

- Rate Stretch Tool (R): It makes a clip longer by reducing its speed. After using it make sure you right-click on the clip > Speed/Duration > Time Interpolation: Optical flow, since the default one is not smooth enough

---

## Slow Motion

- Speed Duration: In timeline right-click on clip > Speed/Duration > Change Speed + Time Interpolation: Optical flow
  - Frame Sampling: Duplicate each scene
  - Frame Blending: First half of scene adds to the second half of the scene
  - Optical Flow
- Interpret Video: In Source window (south west) right-click on clip > Modify > Interpret Footage > Frame Rate
- Speed Ramp / Time Remapping:
  - For Video: In timeline right-click on clip > Show Clip Keyframes > Time Remapping > Speed: Now can add KeyFrames, Hold Command Key and click on the line to add Keyframe at the start and end of where you want to change the speed, drag down to speed down, drag KeyFrames right/left for giving it an ease in/out look, Also make sure you right-click on clip > Speed/Duration > Time Interpolation: Optical flow.
  - For Audio: Use razor tool to cut start and end of slow motion part, use Rate Stretch Tool (R) to fill the gap created in timeline, Also make sure you right-click on clip > Speed/Duration > Select maintain Audio Pitch
- Reverse: In timeline right-click on clip > Speed/Duration > Reverse Speed
- Reverse a tiny bit of clip: In timeline right-click on clip > Show Clip Keyframes > Time Remapping > Speed: Now can add KeyFrames, Hold Command Key and click on the line to add Keyframe where you want to go back, drag to the right, then play with ramps + ease in/out

---

## Effects

- Most used ones are:
  - Gaussian Blur
  - Flip
  - Warp Stabilizer
- It is convenient to work in Timeline
- Video Effects > Transitions > Linear Wipe: Is like typewriter
- Add responsive time to the first and end of your footage to make it auto-responsive

---

## Storyboard

- Hit Freeform view in bottom left of Project window (south west), then full screen (~)

---

## Link vs Group vs Nest & Subclip

- Link (when in doubt go for linking): When you click on one of them all are going to be selected + gives you more editable control so you are able to view edit panel and do whatever you want + when trimming a linked thing, all of the linked ones are going to be trimmed
- Group: Use for things that are not stacked on top of each other + not giving editable controls + do this when link is not working
- Nest Sequence (when in doubt go for nest): Make it compact on timeline & also make a component out of it and puts it in the south west + you can animate nested clips all together (not possible in group)
- SubSequence: Like nesting but doesn’t compact it on timeline
- For making a subclip out of a footage, define in and out points in Source Monitor (north east) then right-click > Make Subclip …, then it’s going to
ing to be added to Sequence Window

Essential graphics

- You can create a template of your own to re-use, by right click > Export As Motion Graphics Template, now it’s in your essential graphics
- Do responsive time to your effects in order to be responsive whenever there are trims
- It is possible to create text styles and export them for re-use

File Management

- For removing duplicate footages from Project Window (south west), Select Project Window (south west) > Edit Tab > Consolidate Duplicates
- For removing unused footages from Project Window (south west), Select Project Window (south west) > Edit Tab > Remove Unused. TIP: You can do this and then Undo so unused ones are getting highlighted

Audio

- You can lower/higher volume by using { or } shortcut on keyboard
- WAV format is better than mp3 for editing
- Tips For recording:
  - Don’t use long cables because they have noise
  - Don’t record with high gain because theres gonna be lots of hiss
  - Don’t plugged in to power your laptop when recording because theres gonna be noise, unless you adaptor have earth connection
  - check different laptop plugs for lesser noise/hiss, because they are not the same
- Iran’s electronics work on 50 hz so for dehuming use proper 50 hz tools
- Hold Option key an click on one of fx buttons in Effect Controls to turn all effects off
- in Effects Control you can play only audio part of a heavy clip + make playback
- changing audio effects while playing clip might add KeyFrames to it, its best practice to pause clip then change effect then play it again
- You can right click on timeline > Show Audio Time Units , in order to edit sound in hz

Subtitles

- subtitles: for speaker of another language
- Close Caption: for people with hear loss
- Open Caption: burned on video, can’t take it off

Export

- FHD:
  - 25 fps = 10 Mbps
  - 60 fps = 15 Mbps
- UHD/4K: - 25 fps = 50 Mbps - 60 fps = 75 Mbps

# acknowledgment
## Contributors

APA 🖖🏻

## Links

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