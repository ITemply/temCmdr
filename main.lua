local mainChat = game:GetService('CoreGui'):WaitForChild('ExperienceChat')
local RCTChat = mainChat:WaitForChild('appLayout').chatWindow.scrollingView.bottomLockedScrollView.RCTScrollView
local mainMessages = RCTChat:WaitForChild('RCTScrollContentView')

local players = game:GetService('Players')
local replicatedStorage = game:GetService('ReplicatedStorage')

local client = players.LocalPlayer

local toolEvent = replicatedStorage:WaitForChild('Events'):WaitForChild('ToolEvent')
local signEvent = client.PlayerGui.ToolsGUI.Frame.btnFrame.enterBtn:WaitForChild('Event')

local authorized = {'525570442'}
local commandArray = {}

local activeStatus = truelocal needAuthorization = true
local currentExecutor = ''

local getArgs = function(commandString) 
    local usernameSep = commandString:split(';')[2] 
    local args = usernameSep:split(' ')
  
    return args
end

local addCommand = function(commandName, commandFunction)
    commandArray[commandName] = commandFunction
end

local commandCheck = function(args, command) 
    if args[1] == command then
        return true
    end
  
    return false
end

local getExePlayer = function(playerIdString) 
    for id, player in ipairs(players:GetPlayers()) do
        if player.UserId == tonumber(playerIdString) then 
            return player
        end 
    end

    return false
end
  
local warnError = function(warnReason) 
    if client.Backpack:FindFirstChild('Sign') then
        local tool = client.Backpack:WaitForChild('Sign')
        local humanoid = client.Character.Humanoid
        humanoid:EquipTool(tool)
    
        local warnArgs = {[1] = warnReason}

        signEvent:FireServer(unpack(warnArgs)) 
    elseif client.Character:FindFirstChild('Sign') then
        local warnArgs = {[1] = warnReason}

        signEvent:FireServer(unpack(warnArgs)) 
    else
        local toolArgs = {[1] = 'Sign', [2] = 'sign'}

        toolEvent:FireServer(unpack(toolArgs))
        local tool = client.Backpack:WaitForChild('Sign')
        local humanoid = client.Character.Humanoid
        humanoid:EquipTool(tool)
    
        local warnArgs = {[1] = warnReason}
        signEvent:FireServer(unpack(warnArgs)) 
    end
  
    client.Character.HumanoidRootPart.CFrame = getExePlayer(currentExecutor).Character.HumanoidRootPart.CFrame
  
    task.wait(7)
  
    local humanoid = client.Character.Humanoid humanoid:UnequipTools()
end

local hideError = function() 
    local humanoid = client.Character.Humanoid 
    humanoid:UnequipTools()
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
    if checkCommand(args, 'bringClient') then
        client.Character.HumanoidRootPart.CFrame = getExePlayer(currentExecutor).Character.HumanoidRootPart.CFrame 
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
            local command = args[1]
        
            local s, e = pcall(function()
                commandArray[command](args) 
            end)
        
            if e then
                print(e)
                warnError('COMMAND ERROR: Invalid Command')
            end
        end 
    end
end)

print('LOADED TEM CMDR\n\nTem Cmdr has been loaded and is now ready for use via clients.\nIf you wish to change the authorized users, please use the update command while the script is running or rerun the script with a new userid.')
