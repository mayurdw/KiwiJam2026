# Game Plan

A simple narrative clicker game about processes/beuracracy. The game allows user to click on items to connect dots but when all of the dots are connected in the correct order, the game allows user the untangle the thread.

Two Main Gameplay Aspects:

- Allow user to click on buttons
- Draw lines between the clicked items.

## Objects (Smallest to largest)

- Item button:
  - States: Hidden, Opened, Selected, Start and Completed
- Elemental Grid:
  - Per level. First level 3x3 grid
- Line Connector:
  - Snaps between starting point and the next element one after another.
  - When completed allows to snap back and complete the process. This is the most important aspect

# TODO

- [x] Setup Template
- [x] Setup CI / CD
- [x] Element
- [x] Grid
- [x] Line
- [ ] Theming
- [ ] Line Snapping
- [ ] End Game polish

## Color Scheme

The following colors:
001d3d
000000
14213d
fca311
e5e5e5
ffffff
