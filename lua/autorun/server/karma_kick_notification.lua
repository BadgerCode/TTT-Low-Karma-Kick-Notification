KarmaKickNotification = {}

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
end
