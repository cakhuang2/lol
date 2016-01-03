local _L = require("ccext.LuaResHelper")	

local _M = { CCSVER = "2.3.3.0" }

function _M.create(callBackProvider)
	local cc, ccui, ccs = cc, ccui, ccs
	local ccspc = cc.SpriteFrameCache:getInstance()
	local ccsam = ccs.ArmatureDataManager:getInstance()
	
	local setValue, bind = _L.setValue, _L.bind
	local setBgColor, setBgImage = _L.setBgColor, _L.setBgImage
	local setClickEvent, setTouchEvent = _L.setClickEvent, _L.setTouchEvent
	
	local roots, obj, inc = {}

	obj = cc.Node:create()
	roots.root = obj
	roots.root.Layer = obj
	setValue(obj, "Layer", 166, cc.size(1334, 750), nil, nil, nil, nil, nil, nil)
	roots.Layer_0 = obj

	obj = ccui.ImageView:create()
	roots.Layer_0:addChild(obj)
	roots.root.Image_1 = obj
	setValue(obj, "Image_1", 167, cc.size(1334, 750), cc.p(671.6974, 372.2421), nil, nil, nil, nil, false)
	obj:loadTexture("zairu/zairu_bj.png", 0)
	bind(obj).setMargin(4.6974, 2.7579, -4.6974, -2.7579)
	roots.Image_1_1 = obj

	obj = cc.Sprite:create()
	roots.Image_1_1:addChild(obj)
	roots.root.zairukuang_1 = obj
	setValue(obj, "zairukuang_1", 168, cc.size(939, 66), cc.p(707.0482, 85.2615), nil, nil, nil, nil, nil)
	obj:setTexture("zairu/zairukuang.png")
	bind(obj).setMargin(237.5482, 631.7385, 157.4518, 52.2615)
	roots.zairukuang_1_2 = obj

	obj = ccui.LoadingBar:create()
	roots.zairukuang_1_2:addChild(obj)
	roots.root.LoadingBar_1 = obj
	setValue(obj, "LoadingBar_1", 169, cc.size(902, 42), cc.p(468.0818, 35.1366), nil, nil, nil, nil, nil)
	obj:setPercent(70)
	obj:loadTexture("zairu/zairutiao.png", 0)
	bind(obj).setMargin(17.0818, 9.8634, 19.9182, 14.1366)

	animations = {}
	obj = ccs.ActionTimeline:create()
	animations.actionTimeline = obj 
	obj:setDuration(0)
	obj:setTimeSpeed(1.0000)

	roots.root.animations = animations

	return roots
end

_M.textures = {
	"zairu/zairu_bj.png",
	"zairu/zairukuang.png",
	"zairu/zairutiao.png",
}

return _M
