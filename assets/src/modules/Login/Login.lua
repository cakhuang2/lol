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

--重新更新协议
function Login:reloadProto()
	local proto = require("proto")
    local sproto = require("sproto")

    local host = sproto.new(proto.s2c):host "package"
    local request = host:attach(sproto.new(proto.c2s))
    SocketTCP.setHost(host,request)
end

-- 服务器链接状态
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

--点击注册
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
 
    while 1 do
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
end


--点击开始游戏
function Login:onStartClick()
    pack = getdata() 
    print("send1:"..pack)
	local size = #pack
--[[	local package = strchar(bit32.extract(0,8,4))
    package = package..strchar(bit32.extract(1000,12,2))
    package = package..strchar(bit32.extract(0,14,2))
    package = package..strchar(bit32.extract(1000,0,2))
    package = package..strchar(bit32.extract(0,2,2))
    package = package..strchar(bit32.extract(0,4,2))
    package = package..strchar(bit32.extract(size,6,2))]]
    local package = strchar(bit32.extract(0,0,4))
    package = package..strchar(bit32.extract(size,4,2))
    package = package..strchar(bit32.extract(0,6,2))
    package = package..strchar(bit32.extract(1000,8,2))
    package = package..strchar(bit32.extract(0,10,2))
    package = package..strchar(bit32.extract(0,12,2))
    package = package..strchar(bit32.extract(0,14,2))
    package = package
    print("send2:"..package)
    --util.changeUI(ui.GameRoomContr)
    -- client.lua
    local socket = require("socket")
 
    local host = GameServerIP
    local port = GameServerPort
    --local host = "127.0.0.1"
    --local port = 12345
    local sock = assert(socket.connect(host, port))
    sock:settimeout(0)
  
    print("Press enter after input something:")
    sock:send(package)
    sock:send(pack.."\n")

    local input, recvt, sendt, status
    while true do
        --input = getdata() --"msg..........."--io.read()
       -- if #input > 0 then
            --assert(sock:send("1000000000000000"))
            --assert(sock:send(input .. "\n"))
            --send(sock,input)
        --end
     
        recvt, sendt, status = socket.select({sock}, nil, 1)
        while #recvt > 0 do
            local response, receive_status = sock:receive()
            if receive_status ~= "closed" then
                if response then
                    print("rev:"..response)
                    recvt, sendt, status = socket.select({sock}, nil, 1)
                end
            else
                break
            end
        end
    end
	--tcp:send(package)
end

return Login