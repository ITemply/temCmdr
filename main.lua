local mainChat = game:GetService('CoreGui'):WaitForChild('ExperienceChat')
local RCTChat = mainChat:WaitForChild('appLayout').chatWindow.scrollingView.bottomLockedScrollView.RCTScrollView
local mainMessages = RCTChat:WaitForChild('RCTScrollContentView')

local players = game:GetService('Players')
local replicatedStorage = game:GetService('ReplicatedStorage')

local client = players.LocalPlayer
local NPCS = workspace:WaitForChild('NPC')

local toolEvent = replicatedStorage:WaitForChild('Events'):WaitForChild('ToolEvent')
local damageEvent = replicatedStorage:WaitForChild('jdskhfsIIIllliiIIIdchgdIiIIIlIlIli')

local authorized = {'525570442'}
local commandArray = {}

local activeStatus = true
local needAuthorization = true
local canTeleport = false

local currentExecutor = ''

local getArgs = function(commandString)
    local usernameSep = commandString:split(';')[2]
    if string.match(usernameSep, ' ') then
	local args = usernameSep:split(' ')
  
    	return args
    else
	return {usernameSep}
    end
end
  
local warnError = function(warnReason)
    if client.Backpack:FindFirstChild('Sign') then
        local tool = client.Backpack:WaitForChild('Sign')
        local humanoid = client.Character.Humanoid
        humanoid:EquipTool(tool)
    
        local warnArgs = {[1] = warnReason}

        client.PlayerGui.ToolsGUI.Frame.btnFrame.enterBtn:WaitForChild('Event'):FireServer(unpack(warnArgs))
    elseif client.Character:FindFirstChild('Sign') then
        local warnArgs = {[1] = warnReason}

        client.PlayerGui.ToolsGUI.Frame.btnFrame.enterBtn:WaitForChild('Event'):FireServer(unpack(warnArgs))
    else
        local toolArgs = {[1] = 'Sign', [2] = 'sign'}

        toolEvent:FireServer(unpack(toolArgs))
        local tool = client.Backpack:WaitForChild('Sign')
        local humanoid = client.Character.Humanoid
        humanoid:EquipTool(tool)

        local warnArgs = {[1] = warnReason}
        client.PlayerGui.ToolsGUI.Frame.btnFrame.enterBtn:WaitForChild('Event'):FireServer(unpack(warnArgs))
    end
  
    client.Character.HumanoidRootPart.CFrame = getExePlayer(currentExecutor).Character.HumanoidRootPart.CFrame
  
    task.wait(7)
  
    local humanoid = client.Character.Humanoid
    humanoid:UnequipTools()
end

local hideError = function()
    local humanoid = client.Character.Humanoid
    humanoid:UnequipTools()
end

local addCommand = function(commandName, commandFunction)
    commandArray[commandName] = commandFunction
end

local getShortenCommand = function(args)
    local command = args[1]
	
    if args[1] == 'st' then
	command = 'setStatus'
    elseif args[1] == 'b' then
	command = 'bringClient'
    elseif args[1] == 'ss' then
	command = 'signSay'
    elseif args[1] == 'hs' then
	command = 'hideSign'
    elseif args[1] == 't' then
	command = 'teleportClient'
    elseif args[1] == 'm' then
	command = 'message'
    elseif args[1] == 'l' then
	command = 'leave'
    elseif args[1] == 'lt' then
	command = 'loopTeleport'
    elseif args[1] == 'ylt' then
	command = 'unloopTeleport'
    elseif args[1] == 'kill' then
	command = 'k'
    elseif args[1] == 'kb' then
	command = 'killBoss'
    elseif args[1] == 'r' then
	command = 'reset'
    end

    return command
end

local commandCheck = function(args, command)
    if getShortenCommand(args) == command then
        return true
    end
	
    warnError('COMMAND ERROR: Command Type Not Same')
    return
end

local matchPlayer = function(playerName)
    for id, player in ipairs(players:GetPlayers()) do
	if string.lower(player.Name):match(string.lower(playerName)) then
            return player, player.Name
        end
    end

    warnError('COMMAND ERROR: Invalid Player')
    return
end

local getExePlayer = function(playerIdString)
    for id, player in ipairs(players:GetPlayers()) do
        if player.UserId == tonumber(playerIdString) then
            return player
        end
    end

    warnError('COMMAND ERROR: Invalid Player')
    return
end

local checkUser = function(username, authList)
    for id, auth in ipairs(authList) do
        if string.match(username, auth) then
            return true  
        end
    end
  
    return false
end

local getWorkingUser = function(username, authList)
    for id, auth in ipairs(authList) do
        if string.match(username, auth) then
            return auth
        end
    end
  
    return auth
end

local isValidCommand = function(dict, command)
    return dict[command] ~= nil
end
  
addCommand('setStatus', function(args)
    if commandCheck(args, 'setStatus') then
        if args[2] == 'true' then
            activeStatus = true
        elseif args[2] == 'false' then
            activeStatus = false
        else
            warnError('COMMAND ERROR: Invalid Argument Type | "'..args[2]..'" is not a valid argument type.')
        end
    end
end)
  
addCommand('bringClient', function(args)
    if commandCheck(args, 'bringClient') then
        client.Character.HumanoidRootPart.CFrame = getExePlayer(currentExecutor).Character.HumanoidRootPart.CFrame
    end
end)

addCommand('signSay', function(args)
    if commandCheck(args, 'signSay') then
        local signText = ''

	args[1] = ''
        for id, arg in ipairs(args) do
	    if arg ~= '' then 
            	signText = signText..arg..' '
	    end
        end

        if client.Backpack:FindFirstChild('Sign') then
            local tool = client.Backpack:WaitForChild('Sign')
            local humanoid = client.Character.Humanoid
            humanoid:EquipTool(tool)
    
            local warnArgs = {[1] = signText}

            client.PlayerGui.ToolsGUI.Frame.btnFrame.enterBtn:WaitForChild('Event'):FireServer(unpack(warnArgs))
        elseif client.Character:FindFirstChild('Sign') then
            local warnArgs = {[1] = signText}

            client.PlayerGui.ToolsGUI.Frame.btnFrame.enterBtn:WaitForChild('Event'):FireServer(unpack(warnArgs))
        else
            local toolArgs = {[1] = 'Sign', [2] = 'sign'}

            toolEvent:FireServer(unpack(toolArgs))
            local tool = client.Backpack:WaitForChild('Sign')
            local humanoid = client.Character.Humanoid
            humanoid:EquipTool(tool)

            local warnArgs = {[1] = signText}
            client.PlayerGui.ToolsGUI.Frame.btnFrame.enterBtn:WaitForChild('Event'):FireServer(unpack(warnArgs))
        end
  
        client.Character.HumanoidRootPart.CFrame = getExePlayer(currentExecutor).Character.HumanoidRootPart.CFrame
    end
end)

addCommand('hideSign', function(args)
    if commandCheck(args, 'hideSign') then
        hideError()
    end
end)

addCommand('teleportClient', function(args)
    if commandCheck(args, 'teleportClient') then
        local player, playerName = matchPlayer(args[2])
            
        client.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
    end
end)

addCommand('message', function(args)
    if commandCheck(args, 'message') then
        local signText = ''
	local player, playerName = matchPlayer(args[2])
			
	args[1] = ''
	args[2] = ''
        for id, arg in ipairs(args) do
            if arg ~= '' then 
            	signText = signText..arg..' '
	    end
        end

        if client.Backpack:FindFirstChild('Sign') then
            local tool = client.Backpack:WaitForChild('Sign')
            local humanoid = client.Character.Humanoid
            humanoid:EquipTool(tool)
    
            local warnArgs = {[1] = signText}

            client.PlayerGui.ToolsGUI.Frame.btnFrame.enterBtn:WaitForChild('Event'):FireServer(unpack(warnArgs))
        elseif client.Character:FindFirstChild('Sign') then
            local warnArgs = {[1] = signText}

            client.PlayerGui.ToolsGUI.Frame.btnFrame.enterBtn:WaitForChild('Event'):FireServer(unpack(warnArgs))
        else
            local toolArgs = {[1] = 'Sign', [2] = 'sign'}

            toolEvent:FireServer(unpack(toolArgs))
            local tool = client.Backpack:WaitForChild('Sign')
            local humanoid = client.Character.Humanoid
            humanoid:EquipTool(tool)

            local warnArgs = {[1] = signText}
            client.PlayerGui.ToolsGUI.Frame.btnFrame.enterBtn:WaitForChild('Event'):FireServer(unpack(warnArgs))
        end
            
        client.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
    end
end)

addCommand('leave', function(args)
    if commandCheck(args, 'leave') then
        client:Kick('COMMAND EXECUTED: ;leave')
    end
end)

addCommand('loopTeleport', function(args)
    if commandCheck(args, 'loopTeleport') then
        local player, playerName = matchPlayer(args[2])
	canTeleport = false
	canTeleport = true

	while canTeleport do
	    client.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
	    task.wait()
	end
    end
end)

addCommand('unloopTeleport', function(args)
    if commandCheck(args, 'unloopTeleport') then
	canTeleport = false
    end
end)

addCommand('kill', function(args)
    if commandCheck(args, 'kill') then
	local player, playerName = matchPlayer(args[2])

	local damageArgs = {
    	    [1] = player.Character.Humanoid,
    	    [2] = 1
	}

	repeat
	    damageEvent:FireServer(unpack(damageArgs))
	    client.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 10, -5)
	    task.wait()
	until player.Character.Humanoid.Health <= 0 or client.Character.Humanoid.Health <= 0 

	client.Character.HumanoidRootPart.Anchored = true

	client.Character.HumanoidRootPart.CFrame = getExePlayer(currentExecutor).Character.HumanoidRootPart.CFrame

	client.Character.HumanoidRootPart.Anchored = false
    end
end)

addCommand('reset', function(args)
    if commandCheck(args, 'reset') then
	client.Character.Humanoid.Health = 0
    end
end)

addCommand('killBoss', function(args)
    if commandCheck(args, 'killBoss') then
	local hitBoss = workspace
			
	if args[2] == 'cen' then
	    hitBoss = NPCS:WaitForChild('CENTAUR'):WaitForChild('Humanoid')
	elseif args[2] == 'cra' then
	    hitBoss = NPCS:WaitForChild('CRABBOSS'):WaitForChild('Humanoid')
	elseif args[2] == 'dra' then
	    hitBoss = NPCS:WaitForChild('DragonGiraffe'):WaitForChild('Humanoid')
	elseif args[2] == 'gri' then
	    hitBoss = NPCS:WaitForChild('Griffin'):WaitForChild('Humanoid')	
	elseif args[2] == 'lav' then
	    hitBoss = NPCS:WaitForChild('LavaGorilla'):WaitForChild('Humanoid')
	end

	local damageArgs = {
    	    [1] = hitBoss,
    	    [2] = 1
	}

	client.Character.HumanoidRootPart.CFrame = getExePlayer(currentExecutor).Character.HumanoidRootPart.CFrame

	repeat
	    damageEvent:FireServer(unpack(damageArgs))
	    task.wait()
	until hitBoss.Health <= 0 or client.Character.Humanoid.Health <= 0 

	client.Character.HumanoidRootPart.Anchored = true

	client.Character.HumanoidRootPart.CFrame = getExePlayer(currentExecutor).Character.HumanoidRootPart.CFrame

	client.Character.HumanoidRootPart.Anchored = false
    end
end)
  
mainMessages.ChildAdded:Connect(function(chatMessage)
    local authString = chatMessage.Name
    local commandString = chatMessage:WaitForChild('TextLabel'):WaitForChild('TextMessage').ContentText
    
    if string.match(commandString, ';') and activeStatus then
        hideError()
        currentExecutor = getWorkingUser(authString, authorized)
        if checkUser(authString, authorized) then
            local args = getArgs(commandString)		
	    local command = getShortenCommand(args)
        
            local s, e = pcall(function()
		if isValidCommand(commandArray, command) then
                    commandArray[command](args)
		else
		    warnError('COMMAND ERROR: Invalid Command | "'..command..'" is not a vaild command.')
		end
            end)
        
            if e then
		print(e)
                warnError('COMMAND ERROR: Command Failed | Check console for more details on command error.')
            end
        end
    end
end)

print('LOADED TEM CMDR\n\nTem Cmdr has been loaded and is now ready for use via clients.\nIf you wish to change the authorized users, please use the update command while the script is running or rerun the script with a new userid.')
