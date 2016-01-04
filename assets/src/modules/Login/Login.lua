local Login = class("Login",function()
	local node = util.createlua(ui.Login)
    return node.root
end)


function Login.create(...)
    local node = Login.new(...)
    return node
end

function Login:ctor()
    --[[if not GameTCP then
        self:reloadProto()
        GameTCP = SocketTCP.create(
        GameServerIP,
        GameServerPort,false)

        GameTCP:connect()
        GameTCP:addEventListener(SocketTCP.EVENT_CONNECTED,self,self.onServerState)
        GameTCP:addEventListener(SocketTCP.EVENT_CLOSED,self,self.onServerState)
        GameTCP:addEventListener(SocketTCP.EVENT_CONNECT_FAILURE,self,self.onServerState)
    end]]
end

--ÖØÐÂ¸üÐÂÐ­Òé
function Login:reloadProto()
	local proto = require("proto")
    local sproto = require("sproto")

    local host = sproto.new(proto.s2c):host "package"
    local request = host:attach(sproto.new(proto.c2s))
    SocketTCP.setHost(host,request)
end

-- ·þÎñÆ÷Á´½Ó×´Ì¬
function Login:onServerState(eventSockct)
	if eventSockct.name == SocketTCP.EVENT_CONNECTED then
		--self:initGame()
	elseif eventSockct.name == SocketTCP.EVENT_CLOSED  then
		trace(eventSockct.name)
	elseif eventSockct.name == SocketTCP.EVENT_CONNECT_FAILURE  then
		trace(eventSockct.name..
			GameServerIP..":"..GameServerPort)
	end
end

function Login:addEvents()
    util.clickSelf(self,self.Button_3,self.onStartClick)
    util.clickSelf(self,self.Button_Register,self.onRegisterClick)
end


function Login:refresh()
	
end

function Login:resize()
end

function Login:removeEvents()
end


function Login:onLogin()
end


function Login:dispose()
end


local function getdata() 
    local person_pb = require("test_pb")
    local person= person_pb.PlayerRaw()
    person.username = "name"
    person.pwd = "password"
 
    local data = person:SerializeToString()
 
    local msg = person_pb.PlayerRaw()
 
    msg:ParseFromString(data)
    print("parser:", msg.username, msg.pwd, data) 
    print(msg)
    return data
end
 
local function testProtobuf()  
    local socket = require("socket")
 
    local host = GameServerIP
    local port = GameServerPort
    local sock = assert(socket.connect(host, port))
    sock:settimeout(0)
  
    print("Press enter after input something:")
 
    local input, recvt, sendt, status
        input = getdata() --io.read()
       -- if #input > 0 then
            assert(sock:send(input .. "\n"))
       --     print("send:"..input)
       -- end
     
    while true do
        recvt, sendt, status = socket.select({sock}, nil, 1)
        while #recvt > 0 do
            local response, receive_status = sock:receive()
            if receive_status ~= "closed" then
                if response then
                    print(response)
                    recvt, sendt, status = socket.select({sock}, nil, 1)
                end
            else
                break
            end
        end
    end
end  

local strchar = string.char
local function send(tcp,pack)
	--assert(self.isConnected, self.name .. " is not connected.")
    trace("send1:"..pack)
	local size = #pack
	local package = strchar(bit32.extract(size,8,8)) ..
		strchar(bit32.extract(size,0,8))--..pack
    trace("send2:"..package)
	tcp:send(package)
end

--µã»÷×¢²á
function Login:onRegisterClick()
    --print(getdata() )
    --server.lua
    local socket = require("socket")
 
    local host = "127.0.0.1"
    local port = "12345"
    local server = assert(socket.bind(host, port, 1024))
    server:settimeout(0)
    local client_tab = {}
    local conn_count = 0
 
    print("Server Start " .. host .. ":" .. port) 
 
    local function __tick()
        local conn = server:accept()
        if conn then
            conn_count = conn_count + 1
            client_tab[conn_count] = conn
            print("A client successfully connect!") 
        end
  
        for conn_count, client in pairs(client_tab) do
            local recvt, sendt, status = socket.select({client}, nil, 1)
            if #recvt > 0 then
                local receive, receive_status = client:receive()
                if receive_status ~= "closed" then
                    if receive then
                        assert(client:send("Client " .. conn_count .. " Send : "))
                        assert(client:send(receive .. "\n"))
                        print("Receive Client " .. conn_count .. " : ", receive)   
                    end
                else
                    table.remove(client_tab, conn_count) 
                    client:close() 
                    print("Client " .. conn_count .. " disconnect!") 
                end
            end
         
        end
    end
    scheduler.scheduleGlobal(__tick, 0.1)
end
--[[    MessageIdBit    = 0  //消息来源或者目的id
    MessageUnlenBit = 4  //未压缩前消息体长度，可为0，和len相等表示没有压缩
    MessageLenBit   = 6  //消息体长度，可为0
    MessageCmdBit   = 8  //消息命令字
    MessageSeqBit   = 10 //消息序号
    MessageRetBit   = 12 //消息返回值，消息返回时使用
    MessageMaskBit  = 14 //一些标志

    MessageHeaderLen = 16 //消息长度]]
local function getMessage(pack)
    local header = ""

    local id = 0
    header = header..strchar(bit32.extract(id,24,8))
    header = header..strchar(bit32.extract(id,16,8))
    header = header..strchar(bit32.extract(id,8,8))
    header = header..strchar(bit32.extract(id,0,8))

    local sizeUnLen = #pack
    header = header..strchar(bit32.extract(sizeUnLen,8,8))
    header = header..strchar(bit32.extract(sizeUnLen,0,8))

    local size = sizeUnLen
    header = header..strchar(bit32.extract(size,8,8))
    header = header..strchar(bit32.extract(size,0,8))

    local cmd = 1000
    header = header..strchar(bit32.extract(cmd,8,8))
    header = header..strchar(bit32.extract(cmd,0,8))

    local index = 1
    header = header..strchar(bit32.extract(index,8,8))
    header = header..strchar(bit32.extract(index,0,8))

    local res = 0
    header = header..strchar(bit32.extract(res,8,8))
    header = header..strchar(bit32.extract(res,0,8))

    local mark = 0
    header = header..strchar(bit32.extract(mark,8,8))
    header = header..strchar(bit32.extract(mark,0,8))
    return header
end

--µã»÷¿ªÊ¼ÓÎÏ·
function Login:onStartClick()
    --util.changeUI(ui.GameRoomContr)
    local pack = getdata() 
    local header = getMessage(pack)
    -- client.lua
    local socket = require("socket")
 
    local host = GameServerIP
    local port = GameServerPort   
    --local host = "120.33.34.198"
    --local port = 9108
    --local host = "127.0.0.1"
    --local port = 12345
    local sock = assert(socket.connect(host, port))
    sock:settimeout(0)
  
    print("package:"..header)
    sock:send(header..pack)

    local input, recvt, sendt, status
    local function __tick( ... )
            
            --input = getdata() --"msg..........."--io.read()
           -- if #input > 0 then
                --assert(sock:send("1000000000000000"))
                --assert(sock:send(input .. "\n"))
                --send(sock,input)
            --end
         
           -- recvt, sendt, status = socket.select({sock}, nil, 1)
           -- while #recvt > 0 do
                local response, receive_status = sock:receive(16)
                if receive_status ~= "closed" then
                    if response then
                        print("rev:"..response)
                        recvt, sendt, status = socket.select({sock}, nil, 1)
                    end
                else
             --       break
                end
            --end
    end
    scheduler.scheduleGlobal(__tick, 0.1)
	--tcp:send(package)
end

return Login