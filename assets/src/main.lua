
cc.FileUtils:getInstance():setPopupNotify(false)
-- 平台 0-window,1-linux,2-mac,3-android, 4-iphone,5-ipad
__Platform__ = cc.Application:getInstance():getTargetPlatform()

-- if __Platform__ == 3 then
--cc.FileUtils:getInstance():addSearchPath("src/")
--cc.FileUtils:getInstance():addSearchPath("res/")
-- end
--登陆器IP地址
GameServerIP = "120.33.34.198"
GameServerPort = 9108

GameServerIP = "120.27.100.131"
GameServerPort = 13000
G_Loaded = {}

-- 打印 资源搜索路径
local resPathArr = cc.FileUtils:getInstance():getSearchPaths()
for k,v in pairs(resPathArr) do
	print("res path:", v)
end
-- 打印 lua搜索路径
print("lua path:", package.path)


require "cocos.init"

for k,v in pairs(package.loaded) do
	G_Loaded[k] =  true
end	

require("ccext.run")

cclog = function(...)
    print(string.format(...))
end

function __G__TRACKBACK__(msg)
    local debuglog = debug.traceback()
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debuglog)
    cclog("----------------------------------------")

    return msg
end

local director = cc.Director:getInstance()
local view = director:getOpenGLView()
local framesize = view:getFrameSize()


local function setDesignResolution(r, framesize)
    if r.autoscale == "FILL_ALL" then
        view:setDesignResolutionSize(framesize.width, framesize.height, cc.ResolutionPolicy.FILL_ALL)
    else
        local scaleX, scaleY = framesize.width / r.width, framesize.height / r.height
        local width, height = framesize.width, framesize.height
        if r.autoscale == "FIXED_WIDTH" then
            width = framesize.width / scaleX
            height = framesize.height / scaleX
            view:setDesignResolutionSize(width, height, cc.ResolutionPolicy.NO_BORDER)
        elseif r.autoscale == "FIXED_HEIGHT" then
            width = framesize.width / scaleY
            height = framesize.height / scaleY
            view:setDesignResolutionSize(width, height, cc.ResolutionPolicy.NO_BORDER)
        elseif r.autoscale == "EXACT_FIT" then
            view:setDesignResolutionSize(r.width, r.height, cc.ResolutionPolicy.EXACT_FIT)
        elseif r.autoscale == "NO_BORDER" then
            view:setDesignResolutionSize(r.width, r.height, cc.ResolutionPolicy.NO_BORDER)
        elseif r.autoscale == "SHOW_ALL" then
            view:setDesignResolutionSize(r.width, r.height, cc.ResolutionPolicy.SHOW_ALL)
        else
            print(string.format("display - invalid r.autoscale \"%s\"", r.autoscale))
        end
    end
end

CC_DESIGN_RESOLUTION = {
    width = 1334,
    height = 750,
    autoscale = "FIXED_WIDTH"
    --autoscale = "FIXED_HEIGHT"
}


setDesignResolution(CC_DESIGN_RESOLUTION, framesize)


--重启游戏
function reloadGame()
    local scene = cc.Scene:create()
    scene:addChild(require("modules.Login.AutoUpdate").new())
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(scene)
    else
        cc.Director:getInstance():runWithScene(scene)
    end
end

local function main()
	-- print("resourceCount:"..str[1])
    collectgarbage("collect")
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    director:setDisplayStats(true)
	
	
    --if __Platform__ == 3 or __Platform__ == 4 or __Platform__ == 5 then
    --    reloadGame()
	--else
        require("util.functions")
        scheduler = require("util.scheduler")
        EventProtocol = require "util.EventProtocol"
        SocketTCP = require("util.SocketTCP")
        require("util.init")
    	util.changeUI(ui.Login)
    --end
end



local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
