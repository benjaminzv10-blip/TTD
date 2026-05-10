if not game:IsLoaded() then
    game.Loaded:Wait()
end
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local PLACE_A = 13775256536
local PLACE_B = 93712201161812
local PLACE_C = 131703399727686

local function runPlaceA()
	while true do
		if game.PlaceId ~= PLACE_A then break end

		if game.PlaceId ~= PLACE_B then
			TeleportService:Teleport(PLACE_B, LocalPlayer)
		end

		task.wait(5)
	end
end

local function runPlaceB()
	local VirtualInputManager = game:GetService("VirtualInputManager")
	local RunService = game:GetService("RunService")

	local localPlayer = Players.LocalPlayer
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")

	local tpList = {
		workspace.Lifts:GetChildren()[15].Base,
		workspace.Lifts:GetChildren()[12].Base,
		workspace.Lifts.ToiletHQ.Base,
		workspace.Lifts:GetChildren()[16].Base,
	}

	local playerGui = localPlayer:WaitForChild("PlayerGui")
	
	task.spawn(function()
		local mainFrames = playerGui:WaitForChild("MainFrames", 10)
		if mainFrames then
			local notificationFrame = mainFrames:WaitForChild("NotificationFrame", 10)
			if notificationFrame then
				RunService.RenderStepped:Connect(function()
					if notificationFrame.Visible ~= false then
						notificationFrame.Visible = false
					end
				end)
			end
		end
	end)

	local lobby = playerGui:WaitForChild("Lobby")
	local queueFrame = lobby:WaitForChild("QueueFrame")
	local startButton = queueFrame:WaitForChild("Start")

	task.spawn(function()
		while true do
			local randomBase = tpList[math.random(1, #tpList)]
			hrp.CFrame = randomBase.CFrame + Vector3.new(0, 13, 0)
			task.wait(2)
		end
	end)

	task.spawn(function()
		while true do
			if startButton and startButton:IsA("GuiButton") and startButton.Visible and startButton.Parent.Visible then
				local x = startButton.AbsolutePosition.X + (startButton.AbsoluteSize.X / 2)
				local y = startButton.AbsolutePosition.Y + (startButton.AbsoluteSize.Y / 2)
				local clickY = y + 36 

				VirtualInputManager:SendMouseButtonEvent(x, clickY, 0, true, game, 1)
				task.wait()
				VirtualInputManager:SendMouseButtonEvent(x, clickY, 0, false, game, 1)
			end
			task.wait()
		end
	end)
end

local function runPlaceC()
	local GuiService = game:GetService("GuiService")
	local VirtualInputManager = game:GetService("VirtualInputManager")

	local function pressEnter()
		VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
		task.wait()
		VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
	end

	local function autoFlow()
		local gui = LocalPlayer:WaitForChild("PlayerGui")
		local match = gui:WaitForChild("Match")
		local topFrame = match:WaitForChild("TopFrame")

		local skipWave = topFrame:WaitForChild("SkipWave")
		local autoSkipBtn = topFrame:WaitForChild("AutoSkip"):WaitForChild("OnAndOff")

		while true do
			if skipWave.Visible then
				GuiService.SelectedObject = skipWave
				task.wait(0.2)
				pressEnter()
				task.wait(0.2)
				GuiService.SelectedObject = nil
			end

			local currentColor = autoSkipBtn.BackgroundColor3

			if currentColor == Color3.fromRGB(255, 0, 0) then
				GuiService.SelectedObject = autoSkipBtn
				task.wait(0.2)
				pressEnter()
				task.wait(0.2)
				GuiService.SelectedObject = nil
			end

			task.wait(0.5)
		end
	end

	task.spawn(autoFlow)
end

if game.PlaceId == PLACE_A then
	runPlaceA()

elseif game.PlaceId == PLACE_B then
	task.wait(2)
	runPlaceB()

elseif game.PlaceId == PLACE_C then
	runPlaceC()
end
