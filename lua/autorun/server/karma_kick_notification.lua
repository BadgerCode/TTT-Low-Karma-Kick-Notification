KarmaKickNotification = {
    DiscordWebhookURL = CreateConVar("ttt_karmakick_discordwebhookurl", "", FCVAR_PROTECTED + FCVAR_LUA_SERVER, "Discord Webhook URL for karma kick notifications")
}

hook.Remove("PlayerDisconnected", "KarmaKickNotif_PlayerDisconnected")
hook.Add("PlayerDisconnected", "KarmaKickNotif_PlayerDisconnected", function(ply)
    -- ply.karma_kicked is set via TTT
    -- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/terrortown/gamemode/karma.lua#L337
    if(not ply.karma_kicked) then return end

    KarmaKickNotification.SendNotification(ply)
end)



KarmaKickNotification.SendNotification = function(kickedPlayer)
    local minKarma = GetConVar("ttt_karma_low_amount"):GetInt()
    local playerKarma = kickedPlayer:GetBaseKarma()
    local isBanned = GetConVar("ttt_karma_low_ban"):GetInt() == 1
    local disconnectReason = isBanned and "banned" or "kicked"

    local chatMessage = string.format("%s was %s for low karma (%d), below minimum karma of %d", kickedPlayer:Nick(), disconnectReason, playerKarma, minKarma)
    for k, ply in pairs(player.GetAll()) do
        ply:ChatPrint(chatMessage)
    end

    local discordWebhookURL = KarmaKickNotification.DiscordWebhookURL:GetString()
    if(discordWebhookURL != "") then
        KarmaKickNotification.SendDiscordNotification(discordWebhookURL, chatMessage)
    end
end


local limit = 5
local reset = 0
KarmaKickNotification.SendDiscordNotification = function(webhookURL, message)
    local now = os.time(os.date("!*t"))

    if limit == 0 and now < reset then
        local function tcb()
            KarmaKickNotification.SendDiscordNotification(webhookURL, message)
        end

        timer.Simple(reset - now, tcb)
    end

    HTTP({
        method = "POST",
        url = webhookURL,
        headers = {
            accept = "application/json"
        },
        body = util.TableToJSON({
            content = message
        }),
        type = "application/json",
        success = function(status, body, headers)
            if(status == 403) then
                print("Error calling discord webhook for karma kick- access denied.\nGarry's Mod servers are not allowed to directly call Discord Webhooks.\nPlease use a proxy and check your URL for mistakes.")
            elseif(status < 200 or status > 299) then
                print(string.format("Error calling discord webhook for karma kick (check data/discord-kick-notification-errors.txt)- \"%s\".", tostring(status), body))
                file.Append("discord-kick-notification-errors.txt", string.format("%s\n%s\n\n\n", tostring(status), body))
            end
            limit = headers["X-RateLimit-Remaining"]
            reset = headers["X-RateLimit-Reset"]
        end,
        failed = function(reason)
            print(string.format("Error calling discord webhook for karma kick- \"%s\"", reason))
        end
    })
end
