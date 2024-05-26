Adobe Premier Pro
——————————————————
Shortcuts:

- expand section to full screen —> ~
- zooming in timeline —> + for zoom in & \ for zoom out
- zooming all in to a specific frame in timeline —> option + /
- changing height of Tracks in TimeLine —> select TimeLine, Command + +/- OR double click in gray left area
- changing height of Audio in TimeLine —> select TimeLine, Option + +/- OR double click in gray left area
- minimizing all clips in timeline —> Shift + -
- maximizing all clips in timeline —> Shift + +
- TimeLine Track Height Preset —> command + 1
- view a clip of timeline in source monitor —> select clip + F
- cancelling connection between video and audio of a clip in timeline —> hold option key
- find —> command + F
- define In and Out in source window to import in timeline —> I & O
- Jump 1 frame forward or back in timeline —> arrow keys ← →
- Jump 5 frame forward or back in timeline —> Shift + arrow keys ← →
- shifting a clip/audio 1 frame at a time in timeline —> Command + arrow keys ← →
- shifting a clip/audio 5 frame at a time in timeline —> Command + Shift + arrow keys ← →
- doing an action (toggle lock / mute) in all of tracks of timeline —> hold Shift while clicking on appropriate button
- when lots of tabs are open, to close them all —> Command + click on title of one of a Tabs

Source Window (north west)

- Can Mark a moment of video —> M

Monitor Panel (north east)

- Monitor Panel (north east) zoom in —> Control + +
- Monitor Panel (north east) zoom out —> Control + -
- Monitor Panel (north east) zoom to fit —> Control + 0
- move around in zoomed Monitor panel so mouse turns to a hand —> hold H

TimeLine (south east)

- ⭐ go back 2 seconds in time while playing —> Shift + K
- mark a moment —> M
- Make clip shorter —> Hold Option + Cut from side of clip
- Looping a part of video —> Shift + K
- ⭐ define In and Out in timeline window to trim —> W & Q
  - Cut all that is after this moment —> W
  - Cut all that is before this moment —> Q
- Add a Clip KeyFrame —> Hold command
- ⭐ cut clip wherever play head bar ▶️ is for targeted layer —> Command + K
- cut clip wherever play head bar ▶️ is for all layer —> Shift + Command + K
- Go to start and end of a clip —> Hold Shift

Project (south west)

Audio

- You can lower/higher volume by using { or } shortcut on keyboard
- Hold Option key an click on one of fx buttons in Effect Controls to turn all effects off

——————————————————
Definition:

- Color Grading = getting consistency across multiple shots
- Hue = Color
- Luma = Lughtness
- Sat = saturation
- Saturation = all the colors up/down, regardless of how strong they are initially
- vibrance = leave saturated colors alone, bring up/down other colors

——————————————————
Links:

- pexels.com —> free videos for using commercially
- Elements.envato.com —> music

——————————————————
Tips & Tricks

- convenient file structure for a project
  - Audio
  - Footage
  - Graphics
  - Project Files
  - Renders
- Bin is another name for folder
- h264 is very compressed and kind of hard for machine to interact with it. It is best practice to work with Format: QuickTime & Preset: Apple ProRes 422
- Naming standard of tracks : A roll (main one) - B roll - C roll
- It is best practice to start footage using an absolute white + black thing for later on color correction (clapper board 🎬 for example)
- Don’t have lights reflecting on your screen when you are doing color correction details. Do it in a dark room
- use a color checker for tuning your camera (tell it this is 50% gray is) and post filming you can correct colors easier
- whenever you think its the best spot of effect range sliders, bring it a little back
- For changing color of a clip: in Effects (south east) > Tint > change black to whatever you want
- mp4 can’t have transparency, mov can
- Window > History —> for seeing all changes that has made
- By Snap To Program Monitor you are able to use mouse to position a logo

——————————————————
Implementation

Proxies

- proxies: a lighter version of footage in order to edit it, on machine could be hard to process things because of being large or codec. when you render the original one gets rendered
- first method: when you are in middle of project and realize your laptop can’t handle process because of its heaviness
  - To create: go to Media browser (left bottom) select all videos, right click, choose Proxy > Create Proxies
  - To add in Premier: in right top window find + button (button editor) for hidden buttons, find toggle proxies
- Ingesting: kind of proxy. should be activated when you are creating your project. choose “create proxy”. in this way when you are importing it is going to create proxies whenever you import something.
  - if you have not activate it when creating new project: file > Project Settings > Ingest settings
- For relinking proxies to an old project or inherited project: go to Media browser (left bottom), right click on video, Proxy > Attach Proxies …
- For adding Proxy metadata Display to Media browser (left bottom): right click on any metadata, search for proxy
- It is possible to export using proxies

Media Browser

- Window > Media Browser , should appear in bottom left
- It is good for bigger projects or when you are filming & editing yourself
- It’s a way of navigating in directories, inside Premier without Finder
- For preview footages in full size: drag them in source monitor (top left) and preview it

Render In & Render Out

- alternative to proxies, usually happens when we apply effects to our footage and it becomes heavy and can’t preview
- when in top right window, nav gets red its a sign that can’t be previewed because it needs lots of cpu, we can use proxies or Sequence Tab > Render In to Out
- For selecting parts of video, click+”i” on starting point and then click+”i” on ending point
- shortcut is Enter

Cache & scratch disk

- cache is being made because for example mp3 is not that fast for premier to work with, so it creates cfa files as cache to work faster
- we create scratch files. they are Render in & Render out
- for deleting cache: Premier Pro Tab > Preferences > Media Cache > Delete Cache
- for deleting scratch disk: Sequence Tab > Delete Render Files
- For moving all of project to an external hard drive:
  - Premier Pro Tab > Preferences > Media Cache > Media Cache Files > Browse
  - Premier Pro Tab > Preferences > Media Cache DataBase > Browse
  - File Tab > Project Setting > Scratch Disks > Browse

TimeLine tricks

- for replacing a clip that has cuts and effects, drag new clip and hold option key OR right click on clip Replace With Clip > From bin
- if there is a shape for track heights that is desired, it is possible to make a preset for it and make a shortcut for it, so after its messy by hitting a shortcut everything is in place again. TO that :
  - 🔧 (TimeLine display setting) > Save Preset > Name: <name> & Keyboard Shortcut: Track Height Preset 1
- sync lock : when you are adding a clip in timeline everything will shift. for stop shifting everything, we can lock or sync lock it. when we lock it, we can’t do any editing on it, but sync lock is like a soft lock, it wont shift by the time a clip is added but we are still able to edit
- Default Colors:
  - audio + video —> blue
  - video —> purple
  - audio —> green
  - adjustment layers & styles —> magenta pink
- For changing color of a clip,
  - in TimeLine: right click Label Tab > Brown
  - in Media Browser: right click Label Tab > Brown
- For Renaming color names (labels) —> Premier Pro Tab > Preferences > Labels
- Video and audio of a clip are connected to each other, if you want to cancel that, use Link selection button in timeline OR Sequence Tab > Link selection OR hold option key and do what you want in timeline
- Thumbnails : for changing thumbnail (for example to be at head and tail of clip) go to hamburger menu ☰ button in north west of timeline and choose Video Head and Tail Thumbnails. you can hide thumbnails or text names of it from 🔧 (TimeLine display setting)
- FX icon in clips :
  - gray —> untouched
  - yellow —> used effect controls (motion or opacity or scale)
  - purple —> used effect panel (noise), or color adjustment
  - green —> used effect controls, motion or opacity or scale + effect panel (noise), or color adjustment
- Match Frame: in a long interviews when there are lots of cuts, for finding where this little clip is in original video, select it on timeline and bring play head bar ▶️ to the selected clip, then press F OR right click and Reveal in Project
- Reverse Match Frame: when you want to see if you have used a video, first select it in your bin, then you have to go in moment you want to check if its in your video or not (00:32 for example) , then Shift + R, if you’ve used it, its gonna pop
- How to check if my footage is being used in timeline?
  - in project (bottom left) go to icon view, used footages have a blue badge in bottom right of them, by clicking on blue badge you can see where its being used
  - in project (bottom left) go to list view, add video usage or audio usage tag to metadata
- playback tricks:
  - L —> goes forward, LL —> double speed goes forward, LLL —> triple speed goes forward, shift + L —> slowmo goes forward
  - J —> goes backward
  - K —> stop, Shift + K —> go back 2 seconds in time while playing
- Editting timeline Tricks:
  - for importing clip from footage on Source Window (left top), set in and out then click Insert Button OR “,” shortcut OR Drag
  - move a clip in timeline and press others along —> Command + Option + drag clip
- Editting Zen:
  - delete unused tracks in timeline: click in gray empty space in north/south west of timeline, Delete Tracks > Video & Audio > Delete All empty Tracks
  - customizing tracks buttons: click in gray empty space in north/south west of timeline, Customize … >
  - Rename Tracks name as A roll - B roll - C roll
- Use razor tool for cutting a clip into multiple clips
- Option + Delete in timeline won’t leave a big hole in time line and is going to automatically adjust other clips
- Command + K —> cut clip wherever play head bar ▶️ is for targeted layer
- Shift + Command + K —> cut clip wherever play head bar ▶️ is for all layer
- doing an action (toggle lock / mute) in all of tracks of timeline you can hold Shift while clicking on appropriate button

Color

- it’s best practice to turn off proxies when working on colors
- most important thing here: get consistency in all your video, when there are 2 different cameras with 2 different lenses, result color should be consistent
- Matching color of 2 different clips : Window > Lumetri Color > Color Wheel & Match, click on Comparison view for a dual screen in Preview, in dual side left side is reference, click on Apply Match. it automatically correct colors
- Lumetri Color > Curves > RGB Curves: is for correcting highlights + shadows + RGB correctness. double click on black curve box to go back to default. a simple S curve is going to work like a charm 90% of times. curves are other way of controlling contrast + shadow + highlight
- Lumetri Color > Curves > Hue Saturation Curves: is for correcting a spectrum of a color
- some words:
  - Hue: Color
  - Luma: Lightness
  - Sat: Saturation
- Lumetri Color > HSL Secondary: it’s for selecting colors and then correcting them with a lot of controls. Key & Refine Tabs are for selecting colors, Correction Tab is for correcting colors. in this part it is possible to select two different blues (for example) and correct each of them uniquely
- Lumetri was a company that made technologies, adobe bought it and did not changed the name of it

￼

- Lumetri scopes can help us manage shadow + highlight + exposure correction. It is under Color pre-scope (north), right click on Lumetric scope to customize, We use Waveform (RGB) with Waveform > Luma

- For correcting colors using Lumetri scopes we are using Color pre-scope (north), right click on Lumetric scope to customize, We use Vectorscope YUV with Waveform > Luma, center of scope is white, that line (north-west to south-west) is skin tone line, which is a reference that skin tone looks great there
  ￼
- In color correction find an absolute white piece then use it as reference, it is easy to use WB selector to balance video automatically
- To create a mask: Effect Controls > Opacity > Mask
- Color Grading = getting consistency across multiple shots
- To create an all along color grade style, create an adjustment layer all along for your multiple clips
- Hollywood Cinematic look:
  - To import Ingest settings in premier: file > Project Settings > Ingest settings, Ingest: Create Proxies, Add ingest preset
  - Click on comparison view Button in TimeLine, then activate Shot or Frame Comparison for comparing before and after
  - Try to push Mid tones up and down, so there are not thick in the middle
  - High contrast
  - Shadows Curve —> going more into blue/cyan
  - Highlight Curve —> going more into orange
  - Add vignette
  - Add grain
  - Add bars at top and bottom of video
- Indie / cann festival Look:
  - black and white
    - Mid tones are thick
    - Lower Contrast
    - Blacks are not complete black, whites are not complete white
    - Shadows are whiter
    - Can do all of above in Lumetri Color > Creative Tab, faded film
  - Colors (all inside Lumetri Color > Creative Tab)
    - Tip: whenever you think its the best spot of effect range sliders, bring it a little back
    - Saturation down
    - Vibrance up
    - Shadow tint —> going more into blue/cyan
    - highlight tint —> going more into orange
- Master / source clip effect: we have a footage which is cut to multiple clips in timeline in different places, now we want to apply an effect to it, but it’s hard to apply effect to each one of clips (that are cut from a master clip). to do so select clip (cut instance of master clip) in timeline, a blank window appears in source window (north west) > Effect Control, now drag whatever effect you want to blank area. its good but after edit, its hard to understand there is an effect on master, red line under FX square symbol shows master effect is intact

Transitions

- for getting free premier pro graphic transition mogrt —> Motionarray.com
- J & L Transition: Audio plays a big role in this one. Hold command key for setting audio transition points in audio timeline

Stabilizing

- Effects > Warp stabilizer
- Scene Edit Detection: when there is a rendered video that is jumping from this scene to that scene, it is convenient to use this tool in order to automatically slice it to same/original shots : right click > Scene Edit Detection

Freeze & Hold Frame

- freeze frame pause: go to the moment you want in timeline, right click > Insert Frame Hold Fragment
- Hold frame (at the end of youtube video): go to the moment you want in timeline, right click > Add Frame Hold

Tools

- Rate Stretch Tool (R) : it makes a clip longer by reducing it speed. after using it make sure you right click on clip > Speed/Duration > TIme Interpolation : Optical flow, since default one is not smooth enough

Slow Motion

- Speed Duration: in timeline right click on clip > Speed/Duration > change Speed + TIme Interpolation : Optical flow
  - Frame Sampling: duplicate each scene
  - Frame Blending: first half of scene adds to second half of scene
  - Optical Flow
- Interpret Video: in Source window (south west) right click on clip > Modify > Interpret Footage > Frame Rate
- Speed Ramp / Time Remapping:
  - For Video: in timeline right click on clip > Show Clip Keyframes > Time Remapping > Speed : now can add KeyFrames, Hold Command Key and click on line to add Key frame in start and end of where you want to change the speed, drag down to speed down, drag KeyFrames right/left for giving it an ease in/out look, Also make sure you right click on clip > Speed/Duration > TIme Interpolation : Optical flow.
  - For Audio: use razor tool to cut start and end of slow motion part, use Rate Stretch Tool (R) to fill the gap created in timeline, Also make sure you right click on clip > Speed/Duration > Select maintain Audio Pitch
- Reverse: in timeline right click on clip > Speed/Duration > Reverse Speed
- Reverse a tiny bit of clip: in timeline right click on clip > Show Clip Keyframes > Time Remapping > Speed : now can add KeyFrames, Hold Command Key and click on line to add Key frame where you want to go back, drag to right, then play with ramps + ease in/out

Effects

- most used ones are:
  - Gaussian Blur
  - Flip
  - Warp Stabilizer
- It is convenient to work in Timeline
  ￼
- Video Effects > Transitions > Linear Wipe : is like type writter
- Add rsponsive time to first and end of your footage to make it auto responsive

Storyboard

- hit Freeform view in bottom left of Project window (south west), then full screen (~)

Link vs Group vs Nest & subclip

- link (when in doubt go for linking): when click on one of them all going to be selected + gives you more editable control so you are able to view edit panel and do whatever you want + when trimming a linked thing all of linked ones are going to be trimmed
- Group: use for things that are not stacked on top of each other + not giving editable controls + do this when link is not working :)

- Nest Sequence (when in doubt go for nest): make it compact on timeline & also make a component out of it and puts it in south west + you can animate nested clips all together (not possible in group)
- SubSequence: like nesting but doesn’t compact it on timeline

- For making a subclip out of a footage, define in and out points in Source Monitor (north east )then right click > Make Subclip … , then it’s going to be added to Sequence Window

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
