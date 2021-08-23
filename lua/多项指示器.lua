--由柒翻译修复-2878713023
--免费lua从aw论坛修改翻译--原文地址找不到了
--
local tab_2 = gui.Tab(gui.Reference("Visuals"), "tab_ind", "指示器")
local gb_3 = gui.Groupbox(tab_2, "指示器", 15, 15, 300, 900)
--local clr_qi = gui.ColorPicker(gb_3, "clr_qi", "Cfg by ZC Color", 210, 210, 210, 255)
local chk_lr = gui.Checkbox(gb_3, "chk_lr", "合法/暴力指示器", 1)
local chk_af = gui.Checkbox(gb_3, "chk_af", "自动开枪指示器", 1)
local chk_fov = gui.Checkbox(gb_3, "chk_fov", "FOV 指示器", 1)
local chk_aw = gui.Checkbox(gb_3, "chk_aw", "自动穿墙指示器", 1)
local chk_hc = gui.Checkbox(gb_3, "chk_hc", "命中率指示器", 1)
local chk_dmg = gui.Checkbox(gb_3, "chk_dmg", "最低伤害指示器", 1)
local chk_dt = gui.Checkbox(gb_3, "chk_dt", "DT 指示器", 1)
local chk_fd = gui.Checkbox(gb_3, "chk_fd", "假蹲指示器", 1)
local chk_bombinfo = gui.Checkbox(gb_3, "chk_bombinfo", "C4 指示器", 1)
local chk_lc = gui.Checkbox(gb_3, "chk_lc", "Lagcomp 指示器", 1)
local clr_lr = gui.ColorPicker(chk_lr, "clr_lr", "Legit/Rage Indicator Color", 210, 210, 210, 255)
local clr_af = gui.ColorPicker(chk_af, "clr_af", "Autofire/Trigger Indicator Color", 210, 210, 210, 255)
local clr_fov = gui.ColorPicker(chk_fov, "clr_fov", "FOV Indicator Color", 210, 210, 210, 255)
local clr_aw = gui.ColorPicker(chk_aw, "clr_aw", "Autowall Indicator Color", 210, 210, 210, 255)
local clr_hc = gui.ColorPicker(chk_hc, "clr_hc", "Hc Indicator Color", 210, 210, 210, 255)
local clr_dmg = gui.ColorPicker(chk_dmg, "clr_dmg", "Dmg Indicator Color", 210, 210, 210, 255)
local clr_dt = gui.ColorPicker(chk_dt, "clr_dt", "DT Indicator Color", 210, 210, 210, 255)
local clr_bombinfo = gui.ColorPicker(chk_bombinfo, "clr_bombinfo", "C4 Indicators Color", 200, 200, 0, 255)
local clr_fd = gui.ColorPicker(chk_fd, "clr_fd", "FD Indicator Color", 210, 210, 210, 255)

local w, h = draw.GetScreenSize()
i = 0
local gb_1 = gui.Groupbox(tab_2, "位置", 325, 15, 300, 900)
local xpos = gui.Slider(gb_1, "xpos", "X ", 15, 0, w)
local ypos = gui.Slider(gb_1, "ypos", "Y ", h/4*3, 0, h)
local dist = gui.Slider(gb_1, "dist", "间隔", 43, 0, 100)
local font = draw.CreateFont("Segoe UI",30, 650)
local font2 = draw.CreateFont("MS Gothic",40,0)
local obj = {}

Indicator = {text = "", color = {255, 255, 255, 255}, visible = true, drawCircle = false, circleP = 0, circleT = 1, circleR = 1, circleX = 0, circleY = 0}


Indicator.font = {
	name = "Tahoma",
	size = 33,
	weight = 500
}

function Indicator:New(text, color, visible)
	i = i + 1
	obj[i] = {}
	setmetatable(obj[i], self)
	self.__index = self
	self.text = text or ""
	self.color = color or {255, 255, 255, 255}
	self.visible = visible

	return obj[i]
end

function Indicator:Add(text, color, visible)
	local a = Indicator:New(text, color, visible)
	a:SetText(text)
	a:SetColor(color)
	a:SetVisible(visible)
	return a
end



function Indicator:SetText(text)
	self.text = text
end

function Indicator:SetColor(color)
	self.color = color
end

function Indicator:SetVisible(vis)
	self.visible = vis
end

function Indicator:SetDrawCircle(drawCircle)
	self.drawCircle = drawCircle
end

function Indicator:DrawCircle(x, y, radius, thickness, percentage)
	self.drawCircle = true
	self.circleX = x
	self.circleY = y
	self.circleR = radius
	self.circleT = thickness
	self.circleP = percentage
end

callbacks.Register("Draw", "Draw Indicators", function()
	local pLocal = entities.GetLocalPlayer()
	if not pLocal then return end
	if not pLocal:IsAlive() then return end

	local temp = {}

	local y = ypos:GetValue()

	draw.SetFont(font)

	for i = 1, #obj do
		if obj[i].visible then
			table.insert(temp, obj[i])
		end
	end

	for i = 1, #temp do
		local __ind = temp[i]
		if __ind.visible then
			draw.Color(28, 28, 28, 50)
			draw.Color(unpack(__ind.color))
			draw.Text(xpos:GetValue(), y, __ind.text)
			if __ind.drawCircle then
				for i = 0, 360 / 100 * __ind.circleP do
			        --local angle = ((i - 90) % 360) * math.pi / 180
			        local angle = i * math.pi / 180
			        draw.Color(210, 210, 210, 255)
			        local ptx, pty = __ind.circleX + __ind.circleR * math.cos(angle), y + __ind.circleY + __ind.circleR * math.sin(angle)
			        local ptx_, pty_ = __ind.circleX + (__ind.circleR-__ind.circleT) * math.cos(angle), y + __ind.circleY + (__ind.circleR-__ind.circleT) * math.sin(angle)
			        draw.Line(ptx, pty, ptx_, pty_)
			    end
			    for i = 360 / 100 * __ind.circleP + 1, 360 do
			        --local angle = ((i - 90) % 360) * math.pi / 180
			        local angle = i * math.pi / 180
			        draw.Color(45, 45, 45, 45)
			        local ptx, pty = __ind.circleX + __ind.circleR * math.cos(angle), y + __ind.circleY + __ind.circleR * math.sin(angle)
			        local ptx_, pty_ = __ind.circleX + (__ind.circleR-__ind.circleT) * math.cos(angle), y + __ind.circleY + (__ind.circleR-__ind.circleT) * math.sin(angle)
					draw.Line(ptx, pty, ptx_, pty_)
					
			    end
			end
		    y = y - dist:GetValue()
		end
	end
end)



local bomb = {
	display = false,
	planting = false,
	defusing = false,
	plantTime = 0,
	plantStarted = 0,
	bombsite = ""
}

local function lerp_pos(x1, y1, z1, x2, y2, z2, percentage) 

	local x = (x2 - x1) * percentage + x1 
	local y = (y2 - y1) * percentage + y1
	local z = (z2 - z1) * percentage + z1 

	return x, y, z 
	
end

local function calcSite(site)
	-- "borrowed" from Cheeseot (ty lol)
	local avec = entities.GetPlayerResources():GetProp("m_bombsiteCenterA")
	local bvec = entities.GetPlayerResources():GetProp("m_bombsiteCenterB")
	local sitevec1 = site:GetMins()
	local sitevec2 = site:GetMaxs()
	local site_x, site_y, site_z = lerp_pos(sitevec1.x, sitevec1.y, sitevec1.z , sitevec2.x, sitevec2.y, sitevec2.z, 0.5)
	local distance_a, distance_b = vector.Distance({site_x, site_y, site_z}, {avec.x, avec.y, avec.z}), vector.Distance({site_x, site_y, site_z}, {bvec.x, bvec.y, bvec.z})
	return distance_b > distance_a and "A" or "B"
end

function BombDamage(Bomb, Player)

    local playerOrigin = Player:GetAbsOrigin()
    local bombOrigin = Bomb:GetAbsOrigin()

	local C4Distance = math.sqrt((bombOrigin.x - playerOrigin.x) ^ 2 + 
	(bombOrigin.y - playerOrigin.y) ^ 2 + 
	(bombOrigin.z - playerOrigin.z) ^ 2);

	local Gauss = (C4Distance - 75.68) / 789.2 
	local flDamage = 450.7 * math.exp(-Gauss * Gauss);

		if Player:GetProp("m_ArmorValue") > 0 then
			local flArmorRatio = 0.5;
			local flArmorBonus = 0.5;

			if Player:GetProp("m_ArmorValue") > 0 then
				local flNew = flDamage * flArmorRatio;
				local flArmor = (flDamage - flNew) * flArmorBonus;
			 
				if flArmor > Player:GetProp("m_ArmorValue") then
					flArmor = Player:GetProp("m_ArmorValue") * (1 / flArmorBonus);
					flNew = flDamage - flArmor;
				end
			flDamage = flNew;
			end
		end 
	return math.max(flDamage, 0);
end

local function weapon_info(id)
	if id == 1 or id == 64 then
		return "hpistol"
	elseif id == 2 or id == 3 or id == 4 or id == 30 or id == 32 or id == 36 or id == 61 or id == 63 then
		return "pistol"
	elseif id == 7 or id == 8 or id == 10 or id == 13 or id == 16 or id == 39 or id == 60 then
		return "rifle"
	elseif id == 11 or id == 38 then
		return "asniper"
	elseif id == 17 or id == 19 or id == 23 or id == 24 or id == 26 or id == 33 or id == 34 then
		return "smg"
	elseif id == 14 or id == 28 then
		return "lmg"
	elseif id == 25 or id == 27 or id == 29 or id == 35 then
		return "shotgun"
	elseif id == 9 then
		return "sniper"
	elseif id == 40 then
		return "scout"
	end
end

local function is_dt(name)
	if name ~= nil then
		if name == "sniper" or name == "scout" then
			return true
		end
		return gui.GetValue("rbot.accuracy.weapon." .. name .. ".doublefire") ~= 0
	else
		return false
	end
end


originRecords = {}

local lc = Indicator:Add("LC", {212, 18, 4, 255}, false)
local fd = Indicator:Add("FD", {clr_fd:GetValue()}, false)
local bomb_2 = Indicator:Add("", {210, 210, 210, 255}, false)
local bomb_1 = Indicator:Add("", {clr_bombinfo:GetValue()}, false)
local dmg = Indicator:Add("", {clr_dmg:GetValue()}, false)
local hc = Indicator:Add("", {clr_hc:GetValue()}, false)
local aw = Indicator:Add("AW", {clr_aw:GetValue()}, false)
local raw = Indicator:Add("AW: R", {clr_aw:GetValue()}, false)
local law = Indicator:Add("AW: L", {clr_aw:GetValue()}, false)
local dt = Indicator:Add("DT", {clr_dt:GetValue()}, false)
local fov = Indicator:Add("", {clr_fov:GetValue()}, false)
local af = Indicator:Add("", {clr_af:GetValue()}, false)
local lr = Indicator:Add("", {clr_lr:GetValue()}, false)
local qi = Indicator:Add("", {0,0,0,0}, false)

local indicators = {
	qi,lc, fd, bomb_2, bomb_1, dt, hc, dmg, aw, fov, af, lr
}

callbacks.Register("Draw", "Indicators Updater", function()
	local pLocal = entities.GetLocalPlayer()
	if not pLocal then return end
	if not pLocal:IsAlive() then return end

	local xpos = gui.GetValue("esp.tab_ind.xpos")
	local ypos = gui.GetValue("esp.tab_ind.ypos")
	--qi:SetColor({clr_qi:GetValue()})
	dt:SetColor({clr_dt:GetValue()})
	fd:SetColor({clr_fd:GetValue()})
	hc:SetColor({clr_hc:GetValue()})
	dmg:SetColor({clr_dmg:GetValue()})
	lr:SetColor({clr_lr:GetValue()})
	af:SetColor({clr_af:GetValue()})
	fov:SetColor({clr_fov:GetValue()})
	aw:SetColor({clr_aw:GetValue()})
	raw:SetColor({clr_aw:GetValue()})
	law:SetColor({clr_aw:GetValue()})
	bomb_1:SetColor({clr_bombinfo:GetValue()})

	for i = 1, #indicators do
		indicators[i]:SetVisible(false)
		indicators[i]:SetDrawCircle(false)
	end

	if chk_lc:GetValue() then
		if originRecords[1] ~= nil and originRecords[2] ~= nil then
			local delta = Vector3(originRecords[2].x - originRecords[1].x, originRecords[2].y - originRecords[1].y, originRecords[2].z - originRecords[1].z)
			delta = delta:Length2D()^2
			if delta > 4096 then
				lc:SetVisible(true)
			end
			if originRecords[3] ~= nil then
			    table.remove(originRecords, 1)
			end
		end
	end

	if chk_dt:GetValue() then
		dt:SetColor({clr_dt:GetValue()})
		if gui.GetValue("rbot.master") and is_dt(weapon_info(entities.GetLocalPlayer():GetWeaponID())) then
			dt:SetVisible(true)
		end
	end



	if chk_bombinfo:GetValue() then
	    if bomb.display then
	        if bomb.planting then
	            local PlantMath = (globals.CurTime() - bomb.plantStarted) / 3.125
	            if PlantMath < 1 then
	                bomb_1:SetVisible(true)
	                bomb_1:SetText("Planting " .. bomb.bombsite)
	                local percentage = 100 * PlantMath
	                bomb_1:DrawCircle(xpos + 180, Indicator.font.size/3, Indicator.font.size/3, 3, percentage)
	            end
	        end
	        if entities.FindByClass("CPlantedC4")[1] ~= nil then
	            local Bomb = entities.FindByClass("CPlantedC4")[1]
	            local Player = entities.GetLocalPlayer()
	            if Bomb:GetProp("m_bBombTicking") and Bomb:GetProp("m_bBombDefused") == 0 and globals.CurTime() < Bomb:GetProp("m_flC4Blow") then
	                local Player = entities.GetLocalPlayer()
	                local bombtimer = math.floor((bomb.plantTime - globals.CurTime() + Bomb:GetProp("m_flTimerLength")) * 10) / 10
	                if bombtimer < 0 then
	                    bombtimer = 0.0
	                    bomb.defusing = false
	                end
	                if bomb.defusing == true then
	                    local BombMath = ((globals.CurTime() - Bomb:GetProp("m_flDefuseCountDown")) * (0 - 1)) / ((Bomb:GetProp("m_flDefuseCountDown") - Bomb:GetProp("m_flDefuseLength")) - Bomb:GetProp("m_flDefuseCountDown")) + 1
	                    bombtimer = tostring(bombtimer)
	                    if not string.find(bombtimer, "%.") then
	                        bombtimer = bombtimer .. ".0"
	                    end

	                    local defusetime = math.floor((Bomb:GetProp("m_flDefuseCountDown") - globals.CurTime()) * 10) / 10
	                    local idk = ( Bomb:GetProp("m_flDefuseCountDown") - globals.CurTime() ) / Bomb:GetProp("m_flDefuseLength")
	                    local percentage = 100 * idk
	                    defusetime = tostring(defusetime)
	                    if not string.find(defusetime, "%.") then
	                        defusetime = defusetime .. ".0"
	                    end
	                    bomb_1:SetVisible(true)
	                    bomb_1:SetText("Defusing " .. bomb.bombsite)
	                    bomb_1:DrawCircle(xpos + 180, Indicator.font.size/3, Indicator.font.size/3, 3, percentage)
	                else
	                    local BombMath = ((globals.CurTime() - Bomb:GetProp("m_flC4Blow")) * (0 - 1)) / ((Bomb:GetProp("m_flC4Blow") - Bomb:GetProp("m_flTimerLength")) - Bomb:GetProp("m_flC4Blow")) + 1

	                    bombtimer = tostring(bombtimer)
	                    if not string.find(bombtimer, "%.") then
	                        bombtimer = bombtimer .. ".0"
	                    end

	                    bomb_2:SetText(bomb.bombsite .. " - " .. bombtimer)
	                    bomb_2:SetVisible(true)
	                end
	            end

	            if Player:IsAlive() and globals.CurTime() < Bomb:GetProp("m_flC4Blow") and not bomb.defusing then
	                local hpleft = math.floor(0.5 + BombDamage(Bomb, Player))

	                if hpleft >= Player:GetHealth() then
	                    bomb_1:SetColor({240, 20, 0, 255})
	                    bomb_1:SetText("FATAL")
	                    bomb_1:SetVisible(true)
	                elseif hpleft <= 0 then
	                else
	                    bomb_1:SetText("-" .. hpleft .. " HP")
	                    bomb_1:SetVisible(true)
	                end
	            end
	        elseif Bomb ~= nil then
	            if Bomb:GetProp("m_bBombTicking") and Bomb:GetProp("m_bBombDefused") == 0 and globals.CurTime() < (Bomb:GetProp("m_flC4Blow") + 2) then
		            local Player = entities.GetLocalPlayer()

		            if Player:IsAlive() and globals.CurTime() < (Bomb:GetProp("m_flC4Blow") + 1) and not bomb.defusing then
		                local hpleft = math.floor(0.5 + BombDamage(Bomb, Player))

		                if hpleft >= Player:GetHealth() then
		                    bomb_2:SetColor({240, 20, 0, 255})
		                    bomb_2:SetText("FATAL")
		                    bomb_2:SetVisible(true)
		                elseif hpleft <= 0 then
		                else
		                    bomb_2:SetText("-" .. hpleft .. " HP")
		                    bomb_2:SetVisible(true)
		                end
		            end
		        end
	        end
	    end
	end

	if chk_fd:GetValue() then
		fd:SetColor({clr_fd:GetValue()})
		local fd_key = gui.GetValue("rbot.antiaim.extra.fakecrouchkey")
		if fd_key ~= 0 then
			if input.IsButtonDown(fd_key) then
				if not gui.Reference("Menu"):IsActive() then
					fd:SetVisible(true)
				end
			end
		end
	end


	if chk_lr:GetValue() then
		lr:SetText(gui.GetValue("lbot.master") and "LEGIT" or gui.GetValue("rbot.master") and "RAGE")
		lr:SetVisible(true)
	end

	if chk_af:GetValue() then
		local ren = false
		if gui.GetValue("rbot.master") then
			if gui.GetValue("rbot.aim.enable") then
				af:SetText("AUTOFIRE")
				af:SetVisible(true)
			end
		elseif gui.GetValue("lbot.master") then
			if gui.GetValue("lbot.aim.fireonpress") or gui.GetValue("lbot.trg.autofire") then
				if gui.GetValue("lbot.aim.key") == 0 or gui.GetValue("lbot.trg.autofire") then
					af:SetText("AUTOFIRE")
					af:SetVisible(true)
					ren = true
				end
			end
			if not ren then
				if gui.GetValue("lbot.trg.enable") then
					if gui.GetValue("lbot.trg.autofire") or gui.GetValue("lbot.trg.key") ~= 0 and input.IsButtonDown(gui.GetValue("lbot.trg.key")) then
						af:SetText("TRIGGER")
						af:SetVisible(true)
					end
				end
			end
		end
	end

	if chk_fov:GetValue() then
		if gui.GetValue("rbot.master") then
			fov:SetText("FOV: "..gui.GetValue("rbot.aim.target.fov"))
			fov:SetVisible(true)

			
		end
	end

	if chk_aw:GetValue() then
		if gui.GetValue("rbot.master") then
			local wepInfo = weapon_info(entities.GetLocalPlayer():GetWeaponID())
			if wepInfo ~= nil then
				local awall;
				if gui.GetValue("rbot.hitscan.mode") == [["Shared"]] then
					awall = gui.GetValue("rbot.hitscan.mode.shared.autowall")
				else
					awall = gui.GetValue("rbot.hitscan.mode."..wepInfo..".autowall")
				end
			aw:SetVisible(awall)
			end
		elseif gui.GetValue("lbot.master") then
			local wepInfo = weapon_info(entities.GetLocalPlayer():GetWeaponID())
			if wepInfo ~= nil then
				local awall = gui.GetValue("lbot.weapon.vis") == [["Shared"]] and gui.GetValue("lbot.weapon.vis.shared.autowall") or gui.GetValue("lbot.weapon.vis."..wepInfo..".autowall")
				aw:SetVisible(awall)
			end
		end
	end

	if chk_hc:GetValue() then

		local wepInfo = weapon_info(entities.GetLocalPlayer():GetWeaponID())
		if gui.GetValue("rbot.master") then
			local wepInfo = weapon_info(entities.GetLocalPlayer():GetWeaponID())
			if wepInfo ~= nil then
				local hitchance;
				if gui.GetValue("rbot.accuracy.weapon") == [["Shared"]] then
					hitchance = gui.GetValue("rbot.accuracy.weapon.shared.hitchance")
				else
					hitchance = gui.GetValue("rbot.accuracy.weapon."..wepInfo..".hitchance")
					
				end
			--	hc:SetVisible(hitchance)
				hc:SetText("Hit Chance➤"..hitchance)
				hc:SetVisible(true)
			end
		
		end
	end

	if chk_dmg:GetValue() then

		local wepInfo = weapon_info(entities.GetLocalPlayer():GetWeaponID())
		if gui.GetValue("rbot.master") then
			local wepInfo = weapon_info(entities.GetLocalPlayer():GetWeaponID())
			if wepInfo ~= nil then
				local mindmg;
				if gui.GetValue("rbot.accuracy.weapon") == [["Shared"]] then
					mindmg = gui.GetValue("rbot.accuracy.weapon.shared.mindmg")
				else
					mindmg = gui.GetValue("rbot.accuracy.weapon."..wepInfo..".mindmg")
					
				end
			--	hc:SetVisible(hitchance)
			if mindmg >= 101 then
				mindmg = "HP+" .. mindmg-100
				end
				dmg:SetText("Min Damage➤ "..mindmg)
				dmg:SetVisible(true)
			end
		
		end
	end

end)

callbacks.Register("CreateMove", function(cmd)
	local pLocal = entities.GetLocalPlayer()
	if not pLocal then return end
	if not pLocal:IsAlive() then return end
	if chk_lc:GetValue() then
	    if cmd.sendpacket then
	        table.insert(originRecords, entities.GetLocalPlayer():GetAbsOrigin())
	    end
	end
end)

client.AllowListener("bomb_beginplant")
client.AllowListener("bomb_abortplant")
client.AllowListener("bomb_begindefuse")
client.AllowListener("bomb_abortdefuse") 
client.AllowListener("bomb_defused")
client.AllowListener("bomb_exploded")
client.AllowListener("round_officially_ended")
client.AllowListener("bomb_planted")

callbacks.Register("FireGameEvent", function(e)
	if e:GetName() == "bomb_beginplant" then
		bomb.display = true
		bomb.plantStarted = globals.CurTime() 
		bomb.bombsite = calcSite(entities.GetByIndex(e:GetInt("site")))
		bomb.planting = true 
	end
	
	if e:GetName() == "bomb_abortplant" then 
		bomb.planting = false
	end

	if e:GetName() == "bomb_begindefuse" then
		bomb.display = true
		bomb.defusing = true
	elseif e:GetName() == "bomb_abortdefuse" then
		bomb.defusing = false
	elseif e:GetName() == "round_officially_ended" or e:GetName() == "bomb_defused" or e:GetName() == "bomb_exploded" then
		bomb.defusing = false
		bomb.planting = false
		bomb.display = false
	end
	
	if e:GetName() == "bomb_planted" then
		bomb.plantTime = globals.CurTime()
		bomb.planting = false
		bomb.display = true
	end
end)

local chk_fl = gui.Checkbox( gb_3, "asbjkndhijzxhjc.chk", "Fake Lag 指示器", true )
local fl_color = gui.ColorPicker( chk_lr, "asbjkndhijzxhjc.color", "颜色", 220,220,220,255 )
--fl_color:SetPosition(20)
local function Draw()
	if(not chk_fl:GetValue() ) then 
		return 
	end

	local flnum = gui.GetValue("misc.fakelag.factor")
	if(not gui.GetValue( "misc.fakelag.enable" )) then
      flnum = 0 
	end

    local xpos = gui.GetValue("esp.tab_ind.xpos")
	local ypos = gui.GetValue("esp.tab_ind.ypos")

	draw.Color(fl_color:GetValue())
	draw.SetFont(font)
	draw.TextShadow( xpos ,ypos + dist:GetValue(), "FL: " .. tostring(flnum) )
end

callbacks.Register("Draw", Draw)
