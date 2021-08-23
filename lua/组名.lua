--原贴地址:https://aimware.net/forum/thread/146427
--组名lua by 直男
local ref = gui.Reference("misc", "enhancement", "appearance")
local clantag = gui.Checkbox(ref, "clantag", "启用封夕组名", true);
clantag:SetDescription("启动组名");
ffi.cdef[[
    typedef int(__fastcall* clantag_t)(const char*, const char*);
	void* GetProcAddress(void* hModule, const char* lpProcName);
    void* GetModuleHandleA(const char* lpModuleName);
    
    typedef struct {
        uint8_t r;
        uint8_t g;
        uint8_t b;
        uint8_t a;
    } color_struct_t;

    typedef void (*console_color_print)(const color_struct_t&, const char*, ...);
    typedef void* (__thiscall* get_client_entity_t)(void*, int);
]]

local c_hud_chat =
    ffi.cast("unsigned long(__thiscall*)(void*, const char*)", mem.FindPattern("client.dll", "55 8B EC 53 8B 5D 08 56 57 8B F9 33 F6 39 77 28"))(
    ffi.cast("unsigned long**", ffi.cast("uintptr_t", mem.FindPattern("client.dll", "B9 ?? ?? ?? ?? E8 ?? ?? ?? ?? 8B 5D 08")) + 1)[0],
    "CHudChat"
)

local fn_change_clantag = mem.FindPattern("engine.dll", "53 56 57 8B DA 8B F9 FF 15")
local set_clantag = ffi.cast("clantag_t", fn_change_clantag)
local ffi_log = ffi.cast("console_color_print", ffi.C.GetProcAddress(ffi.C.GetModuleHandleA("tier0.dll"), "?ConColorMsg@@YAXABVColor@@PBDZZ"))
local ffi_print_chat = ffi.cast("void(__cdecl*)(int, int, int, const char*, ...)", ffi.cast("void***", c_hud_chat)[0][27])
local w, h = draw.GetScreenSize();
local x = w/2;
local y = h/2;
local current_angle = 0;
local drawLeft = 0;
local drawRight = 0;
local drawBack = 0;
local stupidlagsync = 1;
local stupidlagsync2 = 1;
local stupidlagsync3 = 1;
local kek = 1;
local gaben = 1;
local clantagset = 0;
local old_time = 0;
local saved = false;
local overriden = false;
local manually_changing = false;
local old_lby_offset = gui.GetValue("rbot.antiaim.base.lby");
local old_rotation_offset = gui.GetValue("rbot.antiaim.base.rotation");
local sv_maxusrcmdprocessticks = gui.Reference("Misc", "General", "Server", "sv_maxusrcmdprocessticks")
local tbl = {};
cache = {};

local saved_values = {
   	["rbot.antiaim.base"] = gui.GetValue("rbot.antiaim.base"),
    ["rbot.antiaim.advanced.autodir.edges"] = gui.GetValue("rbot.antiaim.advanced.autodir.edges"),
    ["rbot.antiaim.advanced.autodir.targets"] = gui.GetValue("rbot.antiaim.advanced.autodir"),
    ["rbot.antiaim.advanced.pitch"] = gui.GetValue("rbot.antiaim.advanced.pitch"),
    ["rbot.antiaim.condition.use"] = gui.GetValue("rbot.antiaim.condition.use")
}

local animation = {
    "                  ",
    "f",
    "fe",
    "fen",
    "feng",
    "封",
    "封x",
    "封xi",
    "封夕",
    "封夕d",
    "封夕di",
    "封夕din",
    "封夕ding",
    "封夕定z",
    "封夕定zh",
    "封夕定zhi",
    "封夕定制",
    "封 夕定制",
    "封 夕 定制",
    "封 夕 定 制",
    "封 夕 定 制",
    "封 夕 定 制",
    "封 夕 定 制",
    "封 夕 定 制",
    "封 夕 定 制",
    "封 夕 定 制",
    "封 夕 定 制"
}

function client.color_log(r, g, b, msg, ...)
    for k, v in pairs({...}) do
        msg = tostring(msg .. v)
    end
    local clr = ffi.new("color_struct_t")
    clr.r, clr.g, clr.b, clr.a = r, g, b, 255
    ffi_log(clr, msg)
end

function client.PrintChat(msg)
    ffi_print_chat(c_hud_chat, 0, 0, " " .. msg)
end
local function gui_set_disabled()
	local tradition = clantag:GetValue() == false;
	clantag:SetDisabled(tradition);
end
local function Clantag()
	if gui.GetValue("rbot.master") == true and clantag:GetValue() == true then
		local curtime = math.floor(globals.CurTime() * 2.3);
    	if old_time ~= curtime then
    	    set_clantag(animation[curtime % #animation+1], animation[curtime % #animation+1]);
    	end
    	old_time = curtime;
		clantagset = 1;
	else
		if clantagset == 1 then
            clantagset = 0;
            set_clantag("", "");
        end
	end
end
callbacks.Register( "Draw", Clantag);