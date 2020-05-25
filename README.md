# Karma kick notification
![preview](https://i.imgur.com/iqnccy3.png)

Sends an in-game notification when a player is kicked/banned from a game of Garry's Mod TTT for having too low karma.

[TTT Karma configuration options](http://ttt.badking.net/config-and-commands/convars#TOC-Karma)

<br>

## Discord
The notification can also be send to a [Discord Webhook](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks).<br>
In your `server.cfg`, set `ttt_karmakick_discordwebhookurl` to your Discord webhook URL.

**IMPORTANT**: Unfortunately, Discord's servers block notifications from Garry's Mod servers.<br>
You will need to proxy your requests through another website.

<br><br>


## Debugging
To debug, add the following lines to `lua/autorun/server/karma_kick_notification.lua`

```lua
hook.Remove("PlayerSay", "KarmaKickNotif_PlayerSay")
hook.Add("PlayerSay", "KarmaKickNotif_PlayerSay", function(ply, text, team)
    if(string.lower(text) != "!kkick") then return end
    KarmaKickNotification.SendNotification(ply)

    return false
end)
```

