<h1>Tem Cmdr</h1>

Tem Cmdr is a command execution script for Roblox because I got bored with javascript.

Stopping work on this cuz I don't feel like exploiting anymore atm.

<h2>How 2 Use</h2>

Take all the code from here main.lua and put it into an executor. Then take the authoriztion and change it to be the user id of the person using the commands. Keep in mind you need two accounts for this script to work. This script works by one account being controlled by the messages sent via the otehr user. Other account must be a high level for this to work correctly. 

Command prefix: ";"

```lua
-- to load the thingy lol
local loadData = {
    ['authedUsers'] = {'525570442', '123'} -- put your user id here
}

loadstring(game:HttpGet('https://raw.githubusercontent.com/ITemply/temCmdr/main/main.lua'))(loadData)
```

<h2>Commands</h2>

1. <b>;setStatus</b> (true/false) - sets the status of the bot (can not be undone once false) | <b>pre:</b> st
2. <b>;bringClient</b> - brings the client to the command executor | <b>pre:</b> b
3. <b>;signSay</b> (message) - brings the client to the command executor holding a sign with a message | <b>pre:</b> ss
4. <b>;hideSign</b> - hides the sign | <b>pre:</b> hs
5. <b>;teleportClient</b> (player) - teleports the client to a player | <b>pre:</b> t
6. <b>;message</b> (player) (message) - teleports the client to a player while holding the sign out with a message | <b>pre:</b> m
7. <b>;leave</b> - leaves the game | <b>pre:</b> l
8. <b>;loopTeleport</b> (player) - loop teleports to a x player | <b>pre:</b> lt
9. <b>;unloopTeleport</b> - stops the looped teleporting | <b>pre:</b> ult
10. <b>;kill</b> (player) - kills a player until they are dead | <b>pre:</b> k
11. <b>;killBoss</b> (cen/cra/dra/gri/lav) - kills a boss depending on the specified one inputted | <b>pre:</b> kb
12. <b>;reset</b> - resets the client | <b>pre:</b> r

<h2>Pre Usage</h2>

Precommand of <b>;message</b>:
<br>
;m (user) (message) [m - the pre for message]
