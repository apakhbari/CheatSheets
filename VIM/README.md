# VIM

VIM has three standard modes:

1. Command Mode
2. Insert Mode (enter: pressing i key, leave: pressing esc key)
3. Ex Mode, or colon command (start with `:`)

## Moving [command mode]

- **h →** Move cursor left one character.
- **l →** Move cursor right one character.
- **j →** Move cursor down one line (the next line in the text).
- **k →** Move cursor up one line (the previous line in the text).
- **w →** Move cursor forward one word to front of next word.
- **e →** Move cursor to end of current word.
- **b →** Move cursor backward one word.
- **^ →** Move cursor to beginning of line.
- **$ →** Move cursor to end of line.
- **gg →** Move cursor to the file’s first line.
- **G →** Move cursor to the file’s last line.
- **nG →** Move cursor to file line number n.
- **Ctrl+B →** Scroll up almost one full screen.
- **Ctrl+F →** Scroll down almost one full screen.
- **Ctrl+U →** Scroll up half of a screen.
- **Ctrl+D →** Scroll down half of a screen.
- **Ctrl+Y →** Scroll up one line.
- **Ctrl+E →** Scroll down one line

## Editing [command mode]

- **a →** Insert text after cursor.
- **A →** Insert text at end of text line.
- **dd →** Delete current line.
- **dw →** Delete current word.
- **i →** Insert text before cursor.
- **I →** Insert text before beginning of text line.
- **ZZ →** Write buffer to file and quit editor.
- **o →** Open a new text line below cursor, and move to insert mode.
- **O →** Open a new text line above cursor, and move to insert mode.
- **p →** Paste copied text after cursor.
- **P →** Paste copied (yanked) text before cursor.
- **yw →** Yank (copy) current word.
- **yy →** Yank (copy) current line.
- **Alt+U →** undo last modification.

### COMMAND [NUMBER-OF-TIMES] ITEM

- **d-3-w →** delete three words
- **d-3-d →** delete three lines
- **d-G →** delete to end of file
- **Y-3 →** copy (yank) the 3 lines from the cursor
- **Y-$ →** copy (yank) the text from the cursor to the end of the text line

## Searching [command mode]

- **? →** Start a backward search
- **/ →** Start a forward search.
- **n →** Move to the next matching text pattern.
- **N →** Move to the previous matching text pattern

## Ex mode commands

- **:! command →** Execute shell command and display results, but don’t quit editor.
- **:r! command →** Execute shell command and include the results in editor buffer area.
- **:r file →** Read file contents and include them in editor buffer area.

## Saving changes

- **:x →** Write buffer to file and quit editor.
- **:wq →** Write buffer to file and quit editor.
- **:wq! →** Write buffer to file and quit editor (overrides protection).
- **:w →** Write buffer to file and stay in editor.
- **:w! →** Write buffer to file and stay in editor (overrides protection).
- **:q** Quit editor without writing buffer to file.
- **:q! →** Quit editor without writing buffer to file (overrides protection).


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