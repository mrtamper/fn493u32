repeat wait() until game:IsLoaded()
task.wait(8)
local keyAuth: any, ricePacksAmount
-- safezone related
if workspace:FindFirstChild("SafeZone") then
    workspace.Safezone:Destroy()
end
local Console = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/STX"))() -- ui
-- autofarm related
local safezone = Instance.new("Part")
local players = game:GetService("Players")
local player = players.LocalPlayer
local rice_buy = workspace.GUNS.RiceBag.Over.Sign -- BuyPrompt
local rice_sell = workspace.Sell -- ProximityPrompt
local laundrymat = workspace.Washerr
local cooking_station = workspace["No-Steal Pots"]:GetChildren() -- All pots in the cooking station
local studio_money_folder = workspace.StudioPay.Money
local inside_studio = workspace.StudioPay.Alarm
local dirty_sell = workspace.SellDirtyMoney
local c4buy = workspace.GUNS.C4
local duffelbag = workspace.dufflebagequip
local houses_robbery = workspace.HouseRobb
-- server hop related
local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local HttpService = cloneref(game:GetService("HttpService"))
local queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
local TeleportService = game:GetService("TeleportService")
local function serverHop()
    if httprequest then
        local servers = {}
        local req =
            httprequest(
            {
                Url = string.format(
                    "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true",
                    game.PlaceId
                )
            }
        )
        local body = HttpService:JSONDecode(req.Body)

        if body and body.data then
            for i, v in next, body.data do
                if
                    type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and
                        v.id ~= JobId
                 then
                    table.insert(servers, 1, v.id)
                end
            end
        end

        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(
                game.PlaceId,
                servers[math.random(1, #servers)],
                game.Players.LocalPlayer
            )
        else
            return print("Serverhop", "Couldn't find a server.")
        end
    else
        print("Incompatible Exploit", "Your exploit does not support this command (missing request)")
    end
end

local TeleportCheck = false

game.Players.LocalPlayer.OnTeleport:Connect(function(State)
    -- Ensure teleport is not triggered multiple times
    if not TeleportCheck then
        TeleportCheck = true
        -- Queue the teleport script
        queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/mrtamper/fn493u32/refs/heads/main/main.lua'))()")
    end
end)



-- setting save
function getSetting(settingName)
    local parts = {}
    for part in settingName:gmatch("([^%.]+)") do
        table.insert(parts, part)
    end
    local value = loadfile("BronxFarmsFree.lua")()
    for _, part in ipairs(parts) do
        value = value and value[part]
    end
    return value
end

if getgenv then
    keyAuth = getgenv().BronxFarms and getgenv().BronxFarms.KeyAuth or getSetting('KeyAuth')
    ricePacksAmount = getgenv().BronxFarms and getgenv().BronxFarms.RicePacks or getSetting('RicePacks')
end

local content = string.format([[ 
    return {
        KeyAuth = '%s',
        RicePacks = %d,
    }
    ]], keyAuth, ricePacksAmount)
    writefile('BronxFarmsFree.lua', content)


-- Intro remover
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
workspace:FindFirstChild("Camera").CameraSubject = player.Character.Humanoid
workspace:FindFirstChild("Camera").CameraType = "Follow"
player.PlayerGui.BronxLoadscreen.Enabled = false
player.PlayerGui.MoneyGui.Enabled = true
player.PlayerGui.Hunger.Enabled = true
player.PlayerGui.HealthGui.Enabled = true
player.PlayerGui.SleepGui.Enabled = true
player.Character.Intro.Disabled = true

-- Setup SafeZone
safezone.Parent = workspace
safezone.Name = "Safezone"
safezone.CFrame = CFrame.new(0, 100000, 0)
safezone.Size = Vector3.new(8, 0.5, 8)
safezone.Anchored = true
player.Character.HumanoidRootPart.CFrame = safezone.CFrame + Vector3.new(0, 2, 0)
--startup related
local function waitForPlayer()
    repeat
        wait()
    until player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

-- menu related
local ConsoleLog =
    Console:Window(
    {
        Title = "The Bronx Autofarms | FREE | .gg/bronxfarms",
        Position = UDim2.new(0.75, 0, 0.5, 0),
        DragSpeed = 12
    }
)

--[[
    TypesWeHave = {
        "default",
        "success",
        "fail",
        "warning",
        "nofitication"
    },
]]

local TeleportCheck = false
player.OnTeleport:Connect(function(State)
	if not TeleportCheck then
		TeleportCheck = true
		queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/mrtamper/fn493u32/refs/heads/main/main.lua'))()")
	end
end)

    player.Character.Humanoid:GetPropertyChangedSignal("Health"):Connect(
        function()
            -- Ensure the character's humanoid health has reached 0
            if player.Character.Humanoid.Health == 0 then
                -- Prompt with the message when the player dies
                ConsoleLog:Prompt(
                    {
                        Title = "Player died.",
                        Type = "fail"
                    }
                )
                task.wait(1)
                
                serverHop()
            end
        end
    )

waitForPlayer() -- Ensure the player and character are loaded before proceeding

local riceBags = {}
local cashcount = 0
local potsAssigned

-- Rice farm related

function amtOfRiceLeft()
    local number = workspace.GUNS.RiceBag.Over.Sign.SurfaceGui.SIGN.Text:match("(%d+)")

    return tonumber(number) -- Convert the extracted string to a number
end

local function PurchaseRiceBags(amount)
    local riceBagsPurchased = 0
    while riceBagsPurchased < amount do
        if player.stored.Money.Value >= 3500 then -- Check if player has enough money
            player.Character.HumanoidRootPart.CFrame = rice_buy.CFrame
            task.wait(0.6)
            fireproximityprompt(rice_buy.BuyPrompt, 1)
            riceBagsPurchased = riceBagsPurchased + 1
            task.wait(0.02)
            player.Character.HumanoidRootPart.CFrame = safezone.CFrame + Vector3.new(0, 3, 0)
            task.wait(3.5)
        else
            ConsoleLog:Prompt(
                {
                    Title = "Not enough money",
                    Type = "warning"
                }
            )
            break
        end
    end
end
-- Add more logging to help track progress

local function CollectRice()
    ConsoleLog:Prompt(
        {
            Title = "Collecting rice.",
            Type = "default"
        }
    )

    if #riceBags == 0 then
        ConsoleLog:Prompt(
            {
                Title = "No rice bags found.",
                Type = "warning"
            }
        )
        return
    end

    local totalRiceBags = #riceBags -- Track the total number of rice bags
    local riceCollected = 0 -- Track the number of rice bags collected

    while #riceBags > 0 do
        for i, rice in ipairs(riceBags) do
            -- Ensure rice prompt is valid before interacting
            if rice and rice.prompt and rice.prompt.ObjectText == player.Name .. "'s Rice" then
                -- Move to the rice pot and collect rice
                player.Character.HumanoidRootPart.CFrame = rice.pot.CFrame + Vector3.new(0, 3, 0)
                task.wait(0.5)
                fireproximityprompt(rice.prompt, 1) -- Collect the rice
                table.remove(riceBags, i) -- Remove collected rice from the list
                riceCollected = riceCollected + 1 -- Increment the count of rice collected

                -- Log the progress (e.g., "1/5 rice picked up")
                ConsoleLog:Prompt(
                    {
                        Title = riceCollected .. "/" .. totalRiceBags .. " rice picked up.",
                        Type = "default"
                    }
                )

                task.wait(1) -- Wait to ensure actions are completed
                player.Character.HumanoidRootPart.CFrame = safezone.CFrame + Vector3.new(0, 3, 0) -- Return to safezone
            end
        end
        task.wait(0.5) -- Delay before checking the next rice bag
    end

    -- Log completion when all rice bags are collected
    ConsoleLog:Prompt(
        {
            Title = "Finished collecting rice.",
            Type = "success"
        }
    )
end

local function CookRice(amount)
    riceBags = {}
    potsAssigned = 0
    cooking = true

    player.Character.Humanoid:UnequipTools()
    -- Ensure player has a RiceBag in their backpack before proceeding
    for i, v in pairs(player.Backpack:GetChildren()) do
        if v.Name == "RiceBag" then
            v.Parent = player.Character
        end
    end
    -- Loop through each cooking station (pots)
    for _, pot in ipairs(cooking_station) do
        if potsAssigned < amount then
            -- Check if pot.Part and pot.Part.CookPart and pot.Part.CookPart.ProximityPrompt exist
            if pot and pot:FindFirstChild("Pront") and pot.Pront:FindFirstChild("CookPart") and pot.Pront.CookPart:FindFirstChild("ProximityPrompt") then
                local pot_part = pot.Pront.CookPart
                local prompt = pot_part.ProximityPrompt

                -- Move player to the pot and equip the rice bag
                player.Character.HumanoidRootPart.CFrame = pot_part.CFrame + Vector3.new(0, 1, 0)
                player.Character.HumanoidRootPart.Anchored = true

                task.wait(0.2) -- Small delay to ensure the tool is equipped
                fireproximityprompt(prompt, 1)
                task.wait(0.3)
                player.Character.HumanoidRootPart.Anchored = false
                player.Character.HumanoidRootPart.CFrame = safezone.CFrame + Vector3.new(0, 3, 0)

                -- Track the rice bag assignment
                table.insert(riceBags, {pot = pot_part, prompt = prompt})
                potsAssigned = potsAssigned + 1

                -- Check if we've assigned enough pots (amount in total)
                if potsAssigned >= amount then
                    break
                end
            else
            end
        end
    end

    -- Return the riceBags to be used in the collection function
    return riceBags
end

local function checkHouses()
    for _, door in pairs(houses_robbery:GetDescendants()) do
        if door:IsA("ProximityPrompt") and door.Enabled == true then
            if door.Parent.Name == "HardDoor" or door.Parent.Name == "Wooden Door" then
                return door.Parent.Parent.Parent
            else
                return false
            end
        end
    end
end

local function sellRice()
    ConsoleLog:Prompt(
        {
            Title = "Selling.",
            Type = "success"
        }
    )
    player.Character.Humanoid:UnequipTools()
    for i, v in pairs(player.Backpack:GetChildren()) do
        if v.Name == "LargeRice" or v.Name == "MediumRice" or v.Name == "SmallRice" then
            v.Parent = player.Character
            task.wait(0.2)
            player.Character.HumanoidRootPart.CFrame = rice_sell.CFrame
            task.wait(0.2)
            fireproximityprompt(rice_sell.ProximityPrompt)
            task.wait(0.2)
        end
    end
end

for _, child in pairs(player.Character:GetDescendants()) do
    if child:IsA("BasePart") and child.CanCollide == true then
        child.CanCollide = false
    end
end

repeat
    wait()
until game:IsLoaded()

ConsoleLog:Prompt(
    {
        Title = "Game loaded",
        Type = "default"
    }
)

spawn(
    function()
        wait(300)
        sellRice()
        ConsoleLog:Prompt(
            {
                Title = "Something went wrong.",
                Type = "warning"
            }
        )
        wait(3)
        serverHop()
    end
)

if amtOfRiceLeft() > 0 then
    if amtOfRiceLeft() < ricePacksAmount then
        ricePacksAmount = amtOfRiceLeft()
    end
end

if checkHouses() then
    -- A house is available, proceed with robbing
    house = checkHouses()
    if house ~= nil and house:FindFirstChild("Door") then
        ConsoleLog:Prompt(
            {
                Title = "Kicking door.",
                Type = "default"
            }
        )
        player.Character.HumanoidRootPart.CFrame = house.Door:FindFirstChild(house.Name).CFrame
        task.wait(0.01)
        repeat
            task.wait(0.1)
            fireproximityprompt(house.Door:FindFirstChild(house.Name).ProximityPrompt)
        until house.Door:FindFirstChild(house.Name).ProximityPrompt.Enabled == false

        ConsoleLog:Prompt(
            {
                Title = "Looting",
                Type = "success"
            }
        )
        for i, v in pairs(house:GetDescendants()) do
            if v:IsA("ProximityPrompt") and v.Parent.Name ~= "HardDoor" and v.Parent.Name ~= "WoodenDoor" then
                player.Character.HumanoidRootPart.CFrame = v.Parent.CFrame
                task.wait(0.1)
                fireproximityprompt(v)
                task.wait(0.14)
            end
        end
    else
        ConsoleLog:Prompt(
            {
                Title = "House found but no door.",
                Type = "warning"
            }
        )
    end
else
    -- No house found, print "No houses available."
    ConsoleLog:Prompt(
        {
            Title = "No houses available.",
            Type = "warning"
        }
    )
end

-- Cook rice
if amtOfRiceLeft() > ricePacksAmount or amtOfRiceLeft() == ricePacksAmount then
    ConsoleLog:Prompt(
        {
            Title = "Purchasing rice bags. [" .. ricePacksAmount .. "]",
            Type = "default"
        }
    )
    PurchaseRiceBags(ricePacksAmount)
    task.wait(2)
    ConsoleLog:Prompt(
        {
            Title = "Starting to cook.",
            Type = "default"
        }
    )
    CookRice(ricePacksAmount)
else
    ConsoleLog:Prompt(
        {
            Title = "No rice available.",
            Type = "warning"
        }
    )
end
-- Time for sum more
wait(3)
if workspace.vault.door.robPrompt.ProximityPrompt.Enabled == true then
    player.Character.Humanoid:UnequipTools()
    if not player.Backpack:FindFirstChild("C4") then
        ConsoleLog:Prompt(
            {
                Title = "Buying C4.",
                Type = "default"
            }
        )
        player.Character.HumanoidRootPart.CFrame = c4buy.Handle.CFrame
        repeat task.wait(0.4)
            fireproximityprompt(c4buy.Handle.BuyPrompt)
        until player.Backpack:FindFirstChild("C4")
        task.wait(0.6)
        player.Character.HumanoidRootPart.CFrame = safezone.CFrame + Vector3.new(0, 3, 0)
    end
    task.wait(0.3)
    ConsoleLog:Prompt(
        {
            Title = "Grabbing duffle bag..",
            Type = "default"
        }
    )
    player.Character.HumanoidRootPart.CFrame = duffelbag.CFrame
    task.wait(0.4)
    for i, v in pairs(duffelbag:GetChildren()) do
        if v:IsA("ProximityPrompt") then
            fireproximityprompt(v, 1)
        end
    end
    task.wait(1)
    player.Character.HumanoidRootPart.CFrame = safezone.CFrame + Vector3.new(0, 3, 0)
    task.wait(0.3)
    ConsoleLog:Prompt(
        {
            Title = "Starting robbery.",
            Type = "default"
        }
    )
    player.Character.HumanoidRootPart.CFrame = workspace.vault.door.metaldoor.CFrame
    player.Backpack:FindFirstChild("C4").Parent = player.Character
    task.wait(0.4)
    fireproximityprompt(workspace.vault.door.robPrompt.ProximityPrompt, 1)
    task.wait(1)
    ConsoleLog:Prompt(
        {
            Title = "Grabbing money.",
            Type = "default"
        }
    )
    for i, v in pairs(workspace:GetChildren()) do
        if
            v.Name == "Cash" and
                (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Model.Cash.Position).Magnitude < 85 and
                cashcount ~= 5
         then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Model.Cash.CFrame
            task.wait(0.5)
            for _, cash in pairs(v.Model:GetDescendants()) do
                if cash:IsA("ProximityPrompt") then
                    fireproximityprompt(cash, 1)
                    cashcount = cashcount + 1
                end
            end
            task.wait(0.5)
        end
    end
    task.wait(2)
    player.Character.HumanoidRootPart.CFrame = safezone.CFrame + Vector3.new(0, 2, 0)
    wait(3)
    ConsoleLog:Prompt(
        {
            Title = "Selling.",
            Type = "success"
        }
    )
    player.Character.HumanoidRootPart.CFrame = workspace.sellgold.CFrame
    wait(0.5)
    fireclickdetector(workspace.sellgold.ClickDetector, 1)
else
    ConsoleLog:Prompt(
        {
            Title = "Bank closed..",
            Type = "default"
        }
    )

    if cooking == false then
        serverHop()
    end
end

wait(3)

if cooking == false then
    serverHop()
end

-- Time to grab rice 😞😟
if cooking == true then
    CollectRice(riceBags)
end

wait(8)
sellRice()
wait(3)
serverHop()
