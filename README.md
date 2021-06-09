# Karma kick notification
![preview](https://i.imgur.com/iqnccy3.png)

Sends an in-game notification when a player is kicked/banned from a game of Garry's Mod TTT for having too low karma.

[TTT Karma configuration options](http://ttt.badking.net/config-and-commands/convars#TOC-Karma)

<br><br>

---

<br><br>

## Enabling Discord Notifications

<br>

### 1. Install CHTTP
_Discord blocks requests from Garry's Mod clients/servers using the built-in HTTP capabilities._<br>
_You must the CHTTP Lua module (recommended) or use a proxy HTTP server (hard)._

1. Go to https://github.com/timschumi/gmod-chttp/releases
2. Download the correct version
    * If you are running on a **Windows server**, on the **32-bit Gmod branch** (currently the default branch for servers)
        * Download `gmsv_chttp_win32.dll`
    * If you are running on a **Windows server**, on the **x86-64 Gmod branch**
        * Download `gmsv_chttp_win64.dll`
    * If you are running on a **Linux server**, on the **32-bit Gmod branch** (currently the default branch for servers)
        * Download `gmsv_chttp_linux.dll`
    * If you are running on a **Linux server**, on the **x86-64 Gmod branch**
        * Download `gmsv_chttp_linux64.dll`
3. If it does not already exist in your server's files, create the `garrysmod/lua/bin/` folder on your server.
    * E.g. If your Garry's Mod server is located at `myserver/garrysmod/gameinfo.txt`
    * Then this folder should be made at `myserver/garrysmod/lua/bin`
4. Drop the file you downloaded into this folder

_Thanks to [GMod Store](https://www.gmodstore.com/help/addon/6016/discord/topics/curl-http) for this guide._

<br>

### 2. Create a Discord Webhook URL
_You must have edit channel permissions_

1. In Discord, right click on the channel you want notifications to appear in
2. Select Edit Channel
3. Go to Integrations
4. View Webhooks
5. New Webhook
6. Fill in the information and click "Copy Webhook URL"

The webhook URL should look something like `https://discord.com/api/webhooks/700000000123456789/EXAMPLEEXAMPLEEXAMPLE`

<br>

### 3. Set up your GMod server's configuration
1. Open the file `garrysmod/cfg/server.cfg` on your server.
2. Add the line - `ttt_karmakick_discordwebhookurl "https://discord.com/api/webhooks/700000000123456789/EXAMPLEEXAMPLEEXAMPLE"`
3. Replace `https://discord.com/api/webhooks/700000000123456789/EXAMPLEEXAMPLEEXAMPLE` with the Discord Webhook URL in step 2.

<br><br>

## Using Discord notifications without CHTTP

If you don't want to use the CHTTP module, you can proxy your Discord notifications through a website.

GMod server => Website => Discord API

This requires some experience with creating web services.

In `garrysmod/cfg/server.cfg`, set the `ttt_dmglogs_discordurl` to your proxy website URL.<br>
E.g.<br>
`ttt_dmglogs_discordurl "https://example.com/report-notifications"`


<br><br>

---

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

