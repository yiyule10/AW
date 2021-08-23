--Vote revealer by Cheeseot, improved upon & ported to V5 by Dracer
--汉化作者 An  QQ 2926669800
--实际上V5自带投票显示 在 Misc--Enhancement--Vote Revealer里
local activeVotes = {};
local votecolor = {};
local animend = 0;
local votername = ""
local votetype = 0
local votetarget = ""
local enemyvote = 0
local yescount = 0
local nocount = 0
local voteresult = 0
local displayed = 0
local g_Group = gui.Tab(gui.Reference("MISC"), "MISC.Revealer", "投票显示")
local TP = gui.Groupbox(g_Group, "投票显示", 20, 20, 240, 200);
local g_BroadcastMode = gui.Combobox(TP, "msc_voterevealer_broadcast", "投票发送模式", "关闭", "发送团队频道", "发送全体频道", "发送到控制台")
local g_Draw = gui.Checkbox(TP, "msc_voterevealer_draw", "显示其他人发起的投票", false)
local g_DrawVotes = gui.Checkbox(TP, "msc_voterevealer_drawvotes", "显示其他人的选票", false)
local tx = gui.Text(TP, "  投票显示免费版 By An")----可删除
local tx = gui.Text(TP, "  QQ 2926669800")----可删除
local AnQun = gui.Button(TP, "点击加入An AW交流群", function()
  panorama.RunScript( [[
      SteamOverlayAPI.OpenExternalBrowserURL("https://jq.qq.com/?_wv=1027&k=5HmfQ8s");
  ]] )
end)

g_Draw:SetValue(true)
g_DrawVotes:SetValue(true)

local timer = timer or {}
local timers = {}

local function timerCreate(name, delay, times, func)

  table.insert(timers, {["name"] = name, ["delay"] = delay, ["times"] = times, ["func"] = func, ["lastTime"] = globals.RealTime()})

end

local function timerRemove(name)

  for k,v in pairs(timers or {}) do

    if (name == v["name"]) then table.remove(timers, k) end

  end

end

local function timerTick()

  for k,v in pairs(timers or {}) do

    if (v["times"] <= 0) then table.remove(timers, k) end

    if (v["lastTime"] + v["delay"] <= globals.RealTime()) then
      timers[k]["lastTime"] = globals.RealTime()
      timers[k]["times"] = timers[k]["times"] - 1
      v["func"]()
    end

  end

end

callbacks.Register( "Draw", "timerTick", timerTick);

local function startTimer()
  timerCreate("sleep", 4, 1, function() animend = 1; enemyvote = 0; voteresult = 0; displayed = 0 end)
end

local function getVoteEnd(um)
  if gui.GetValue("misc.master") == false then return end
  if um:GetID() == 47 or um:GetID() == 48 then
    startTimer()
    yescount = 0
    nocount = 0
    enemyvote = 2

    if um:GetID() == 47 then
      voteresult = 1
      if (g_BroadcastMode:GetValue() == 1) then
        client.ChatTeamSay("投票通过")
      elseif (g_BroadcastMode:GetValue() == 2) then
        client.ChatSay("投票通过")
      elseif (g_BroadcastMode:GetValue() == 3) then
        print("投票通过")
      end
    end
    if um:GetID() == 48 then
      voteresult = 2
      if (g_BroadcastMode:GetValue() == 1) then
        client.ChatTeamSay("投票失败")
      elseif (g_BroadcastMode:GetValue() == 2) then
        client.ChatSay("投票失败")
      elseif (g_BroadcastMode:GetValue() == 3) then
        print("投票失败")
      end
    end
  end

  if um:GetID() == 46 then
    local localPlayer = entities.GetLocalPlayer();
    local team = um:GetInt(1)
    local idx = um:GetInt(2)
    votetype = um:GetInt(3)
    votetarget = um:GetString(5)
    votername = client.GetPlayerNameByIndex(idx)
    if localPlayer:GetTeamNumber() ~= team and votetype ~= 1 then
      enemyvote = 1
      displayed = 1
    end

    if votetype == 0 then
      votetypename = "踢出玩家: "
    elseif votetype == 6 then
      votetypename = "投降"
    elseif votetype == 13 then
      votetypename = "发起暂停"
    end

    if (g_BroadcastMode:GetValue() == 1) then
      client.ChatTeamSay(votername .. " 想要 " .. votetypename .. votetarget)
    elseif (g_BroadcastMode:GetValue() == 2) then
      client.ChatSay(votername .. " 想要 " .. votetypename .. votetarget)
    elseif (g_BroadcastMode:GetValue() == 3) then
      print(votername .. " 想要 " .. votetypename .. votetarget)
    end
  end
  end;

  callbacks.Register("DispatchUserMessage", getVoteEnd)

  -- Vote revealer by Cheeseot


  local function add(time, ...)
    table.insert(activeVotes, {
      ["text"] = { ... },
      ["time"] = time,
      ["delay"] = globals.RealTime() + time,
      ["color"] = {votecolor, {10, 10, 10}},
      ["x_pad"] = -11,
      ["x_pad_b"] = -11,
    })
  end

  local function getMultiColorTextSize(lines)
    local fw = 0
    local fh = 0;
    for i = 1, #lines do
      local w, h = draw.GetTextSize(lines[i][4])
      fw = fw + w
      fh = h;
    end
    return fw, fh
  end

  local function drawMultiColorText(x, y, lines)
    local x_pad = 0
    for i = 1, #lines do
      local line = lines[i];
      local r, g, b, msg = line[1], line[2], line[3], line[4]
      draw.Color(r, g, b, 255);
      draw.Text(x + x_pad, y, msg);
      local w, _ = draw.GetTextSize(msg)
      x_pad = x_pad + w
    end
  end

  local function showVotes(count, color, text, layer)
    local y = 650 + (42 * (count - 1));
    local w, h = getMultiColorTextSize(text)
    local mw = w < 50 and 50 or w
    if globals.RealTime() < layer.delay then
      if layer.x_pad < mw then layer.x_pad = layer.x_pad + (mw - layer.x_pad) * 0.05 end
      if layer.x_pad > mw then layer.x_pad = mw end
      if layer.x_pad > mw / 1.09 then
        if layer.x_pad_b < mw - 6 then
          layer.x_pad_b = layer.x_pad_b + ((mw - 6) - layer.x_pad_b) * 0.05
        end
      end
      if layer.x_pad_b > mw - 6 then
        layer.x_pad_b = mw - 6
      end
    elseif animend == 1 then
      if layer.x_pad_b > -11 then
        layer.x_pad_b = layer.x_pad_b - (((mw - 5) - layer.x_pad_b) * 0.05) + 0.01
      end
      if layer.x_pad_b < (mw - 11) and layer.x_pad >= 0 then
        layer.x_pad = layer.x_pad - (((mw + 1) - layer.x_pad) * 0.05) + 0.01
      end
      if layer.x_pad < 0 then
        table.remove(activeVotes, count)
      end
    end
    local c1 = color[1]
    local c2 = color[2]
    local a = 255;
    if(g_DrawVotes:GetValue()) then
      draw.Color(c1[1], c1[2], c1[3], a);
      draw.FilledRect(layer.x_pad - layer.x_pad, y, layer.x_pad + 28, (h + y) + 20);
      draw.Color(c2[1], c2[2], c2[3], a);
      draw.FilledRect(layer.x_pad_b - layer.x_pad, y, layer.x_pad_b + 22, (h + y) + 20);
      drawMultiColorText(layer.x_pad_b - mw + 18, y + 9, text)
    end
  end

  -- Vote revealer by Cheeseot


  local function voteCast(e)
    if gui.GetValue("misc.master") == false then return end
    if (e:GetName() == "vote_cast") then
      timerRemove("sleep")
      animend = 0;
      local index = e:GetInt("entityid");
      local vote = e:GetInt("vote_option");
      local name = client.GetPlayerNameByIndex(index)

      local votearray = {};
      local namearray = {};
      if vote == 0 then
        votearray = { 150, 185, 1, "是" }
        namearray = { 150, 185, 1, name }
        votecolor = { 150, 185, 1}
        yescount = yescount + 1
      elseif vote == 1 then
        votearray = { 185, 20, 1, "否" }
        namearray = { 185, 20, 1, name }
        votecolor = { 185, 20, 1}
        nocount = nocount + 1
      else
        votearray = { 150, 150, 150, "??" }
        namearray = { 150, 150, 150, name }
        votecolor = { 150, 150, 150}
      end

      if (g_BroadcastMode:GetValue() == 1) then
        client.ChatTeamSay(name .. " 投票: " .. votearray[4])
      elseif (g_BroadcastMode:GetValue() == 2) then
        client.ChatSay(name .. " 投票: " .. votearray[4])
      elseif (g_BroadcastMode:GetValue() == 3) then
        print(name .. " 投票: " .. votearray[4])
      end

      add(3,
      namearray,
      { 255, 255, 255, " 投票: " },
      votearray,
      { 255, 255, 255, "   " });
    end
    end;

    callbacks.Register('FireGameEvent', voteCast)

    local function makeVote()
      for index, votes in pairs(activeVotes) do
        showVotes(index, votes.color, votes.text, votes)
      end
      end;

      callbacks.Register('Draw', makeVote)

      client.AllowListener("vote_cast")


      local function drawVote()
        if gui.GetValue("misc.master") == false then return end
        local votetypename = ""
        if(g_Draw:GetValue()) then
          if enemyvote == 1 then
            if votetype == 0 then
              votetypename = "踢出玩家: "
            elseif votetype == 6 then
              votetypename = "投降"
            elseif votetype == 13 then
              votetypename = "暂停"
            else return
            end
            draw.Color(255,150,0,255)
            draw.FilledRect(0, 525, draw.GetTextSize(votername .. " 选择 " .. votetypename .. votetarget) + 30, 625)
            draw.Color(10,10,10,255)
            draw.FilledRect(0, 525, draw.GetTextSize(votername .. " 选择 " .. votetypename .. votetarget) + 20, 625)
            draw.Color(150,185,1,255)
            draw.Text(5 + (draw.GetTextSize(votername .. " 选择 " .. votetypename .. votetarget) / 2) - 25 - (draw.GetTextSize("  是")), 595, yescount .. " 是")
            draw.Color(185,20,1,255)
            draw.Text(5 + (draw.GetTextSize(votername .. " 选择 " .. votetypename .. votetarget) / 2) + 25 , 595, nocount .. " 否")
            draw.Color(255,150,0,255)
            draw.Text(5, 550, votername)
            draw.Color(255,255,255,255)
            draw.Text(draw.GetTextSize(votername .. " ") + 5, 550, "选择 ")
            if votetype == 0 then draw.Color(255,255,255,255) else draw.Color(255,150,0,255) end
            draw.Text(draw.GetTextSize(votername .. " 选择 ") + 5, 550, votetypename)
            draw.Color(255,150,0,255)
            draw.Text(draw.GetTextSize(votername .. " 选择 " .. votetypename) + 5, 550, votetarget)
          elseif enemyvote == 2 and displayed == 1 then
            if voteresult == 1 then
              draw.Color(150,185,1,255)
              draw.FilledRect(0, 525, draw.GetTextSize(votername .. " 选择 " .. votetypename .. votetarget) + 30, 625)
              draw.Color(10,10,10,255)
              draw.FilledRect(0, 525, draw.GetTextSize(votername .. " 选择 " .. votetypename .. votetarget) + 20, 625)
              draw.Color(150,185,1,255)
              draw.Text(5, 575 - 10 , "投票通过.")
            elseif voteresult == 2 then
              draw.Color(185,20,1,255)
              draw.FilledRect(0, 525, draw.GetTextSize("投票失败.") + 110, 625)
              draw.Color(10,10,10,255)
              draw.FilledRect(0, 525, draw.GetTextSize("投票失败.") + 100, 625)
              draw.Color(185,20,1,255)
              draw.Text(50, 575 - 10, "投票失败.")
            end
          end
        end
      end

      callbacks.Register("Draw", drawVote)

      local function reset()
        if entities.GetLocalPlayer() == nil then
          enemyvote = 0;
          activeVotes = {};
          displayed = 0;
        end
      end
      callbacks.Register("Draw", reset)

-- Vote revealer by Cheeseot, improved upon & ported to V5 by Dracer