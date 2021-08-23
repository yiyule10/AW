local set_clan_tag = ffi.cast("int(__fastcall*)(const char*)", mem.FindPattern("engine.dll", "53 56 57 8B DA 8B F9 FF 15"))

function client.SetClanTag(...)
    local clan = ""

    for k, v in pairs({...}) do
        clan = tostring(clan .. v)
    end

    set_clan_tag(clan)
end

local ref = gui.Reference("misc", "enhancement", "appearance")
local stealclan = gui.Combobox(ref, "stealclan", "偷组名", "Off")

callbacks.Register(
    "Draw",
    function()
        local lp = entities.GetLocalPlayer()

        if not entities.GetLocalPlayer() then
            return
        end

        local name = {"Off"}
        local clan = {}

        for k, v in pairs(entities.FindByClass("CCSPlayer")) do
            local idx = v:GetIndex()
            local m_szClan = idx ~= lp:GetIndex() and entities.GetPlayerResources():GetPropString("m_szClan", idx)
            if m_szClan then
                table.insert(name, v:GetName())
                table.insert(clan, m_szClan)
            end
        end

        stealclan:SetOptions(unpack(name))

        if clan[stealclan:GetValue()] and entities.GetPlayerResources():GetPropString("m_szClan", lp:GetIndex()) ~= clan[stealclan:GetValue()] then
            client.SetClanTag(clan[stealclan:GetValue()])
        end
    end
)
