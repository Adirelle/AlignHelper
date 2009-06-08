
local grid
local gridSize = 64
local dirty
local heap = {}
local textures = {}

local lineWidth = 1

local function SetupTexture(width, height, point, x, y, r, g, b)
	local tex = tremove(heap) or grid:CreateTexture(nil, 'BACKGROUND') 
	textures[tex] = true
	tex:SetTexture(r, g, b, 0.5) 
	tex:SetWidth(width)
	tex:SetHeight(height)
	tex:SetPoint(point, grid, point, x, y)
	return tex
end

local RED = { 1, 0, 0 }
local BLACK = { 0, 0, 0 }

local function UpdateGridLayout()
	if not dirty then return end
	dirty = nil
	
	for tex in pairs(textures) do
		tex:Hide()
		heap[tex] = true
	end
	wipe(textures)
	
	local width, height = math.floor(GetScreenWidth()), math.floor(GetScreenHeight())
	for x = (width%(gridSize*2))/2, width, gridSize do
		local color = (math.abs(x*2 - width) < gridSize) and RED or BLACK
		SetupTexture(lineWidth, height, 'LEFT', x - lineWidth / 2, 0, unpack(color))
	end
	for y = (height%(gridSize*2))/2, height, gridSize do
		local color = (math.abs(y*2 - height) < gridSize) and RED or BLACK
		SetupTexture(width, lineWidth, 'BOTTOM', 0, y + lineWidth / 2, unpack(color))
	end
end

local function CreateGrid()
	grid = CreateFrame("Frame", nil, UIParent)
	grid:Hide()
	grid:SetAllPoints(UIParent)
	grid:SetScript('OnShow', UpdateGridLayout)
	dirty = true
end

SLASH_ALIGNHELPER1 = "/align"
function SlashCmdList.ALIGNHELPER(arg)
	local newSize = tonumber(arg)
	if newSize ~= nil then
		if newSize ~= gridSize then
			gridSize = newSize
			if grid then
				dirty = true
				if grid:IsShown() then
					UpdateGridLayout()
				end
			end
		end
		return
	end
	if not grid then
		CreateGrid()
	end
	if grid:IsShown() then
		grid:Hide()
	else
		grid:Show()
	end
end

