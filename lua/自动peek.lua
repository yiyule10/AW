local gradual_circle = true

--v
local lp_abs_origin = {}
local is_peeking
local has_weapon_fire
local alpha_peek = 0
local sin = math.sin
local cos = math.cos
local rad = math.rad

--ui
local reference = gui.Reference("misc", "movement", "other")
local quick_peek = gui.Checkbox(reference, "quick.peek", "Quick peek", 0)
quick_peek:SetDescription("Return to the original position after firing.")
local quick_peek_clr = {
    gui.ColorPicker(quick_peek, "clr", "clr", 255, 65, 65, 66),
    gui.ColorPicker(quick_peek, "clr2", "clr2", 255, 255, 255, 200)
}

--clamp
local function clamp(val, min, max)
    if val > max then
        return max
    elseif val < min then
        return min
    else
        return val
    end
end

--draw circle 3d
local function draw_circle_3d(pos, radius, clr)
    local center = {client.WorldToScreen(Vector3(pos.x, pos.y, pos.z))}
    local r, g, b, a = clr[1], clr[2], clr[3], clr[4]
    local r2, g2, b2, a2 = quick_peek_clr[2]:GetValue()

    if center[1] and center[2] then
        for degrees = 1, 22, 1 do
            local cur_point = nil
            local old_point = nil

            local pos_x1 = pos.x + sin(rad(degrees * 16.365)) * radius
            local pos_x2 = pos.x + sin(rad(degrees * 16.365 - 16.365)) * radius
            local pos_y1 = pos.y + cos(rad(degrees * 16.365)) * radius
            local pos_y2 = pos.y + cos(rad(degrees * 16.365 - 16.365)) * radius
            if pos.z then
                cur_point = {client.WorldToScreen(Vector3(pos_x1, pos_y1, pos.z))}
                old_point = {client.WorldToScreen(Vector3(pos_x2, pos_y2, pos.z))}
            end

            if cur_point[1] and cur_point[2] and old_point[1] and old_point[2] then
                draw.Triangle(cur_point[1], cur_point[2], old_point[1], old_point[2], center[1], center[2], draw.Color(r, g, b, a))
                if not gradual_circle then
                    draw.Line(cur_point[1], cur_point[2], old_point[1], old_point[2], draw.Color(r2, g2, b2, a2))
                end
            end
        end
    end
end

--paint
local function on_paint()
    local lp = entities.GetLocalPlayer()
    if not (lp and lp:IsAlive()) then
        return
    end

    local fade = ((1.0 / 0.15) * globals.FrameTime()) * 20

    if quick_peek:GetValue() and not is_peeking then
        lp_abs_origin = lp:GetAbsOrigin()
        is_peeking = true
    end

    alpha_peek = quick_peek:GetValue() and clamp(alpha_peek + fade, 0, 20) or clamp(alpha_peek - fade, 0, 20)

    local r, g, b, a = quick_peek_clr[1]:GetValue()

    if alpha_peek ~= 0 then
        if gradual_circle then
            for i = 1, alpha_peek, 0.6 do
                local a = i / 255 * a
                draw_circle_3d(lp_abs_origin, i, {r, g, b, a})
            end
        else
            draw_circle_3d(lp_abs_origin, alpha_peek * 0.7, {r, g, b, a})
        end
    else
        if is_peeking then
            lp_abs_origin = lp:GetAbsOrigin()
        end
    end
end

--set move
local function on_setup_command(cmd)
    local lp = entities.GetLocalPlayer()

    if has_weapon_fire and quick_peek:GetValue() then
        local local_angle = {engine.GetViewAngles().x, engine.GetViewAngles().y, engine.GetViewAngles().z}
        local world_forward = {
            vector.Subtract({lp_abs_origin.x, lp_abs_origin.y, lp_abs_origin.z}, {lp:GetAbsOrigin().x, lp:GetAbsOrigin().y, lp:GetAbsOrigin().z})
        }

        cmd.forwardmove = (((sin(rad(local_angle[2])) * world_forward[2]) + (cos(rad(local_angle[2])) * world_forward[1])) * 200)
        cmd.sidemove = (((cos(rad(local_angle[2])) * -world_forward[2]) + (sin(rad(local_angle[2])) * world_forward[1])) * 200)

        if vector.Length(world_forward) < 10 then
            has_weapon_fire = false
        end
    end
end

--inspect weapon fire
local function weapon_fire(event)
    if event:GetName() and event:GetName() == "weapon_fire" then
        local lp_index = client.GetLocalPlayerIndex()
        local userid = client.GetPlayerIndexByUserID(event:GetInt("userid"))
        local attacker = client.GetPlayerIndexByUserID(event:GetInt("attacker"))

        if (userid == lp_index and attacker ~= lp_index) then
            has_weapon_fire = true
            if quick_peek:GetValue() then
                cheat.RequestSpeedBurst()
            end
        end
    end
end

--callbacks
callbacks.Register("Draw", on_paint)
callbacks.Register("CreateMove", on_setup_command)
client.AllowListener("weapon_fire")
callbacks.Register("FireGameEvent", weapon_fire)
