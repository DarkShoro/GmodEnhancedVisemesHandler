-- Then font named "Font" compacted on one line.
if SERVER then return end
local ss = ScreenScale

for i = 1, 30 do
	surface.CreateFont("Instructions_" .. i, {
		font = "Arial",
		extended = true,
		size = ss(i)
	})
end

local function CloseMenu()
	if FlexMenu then
		FlexMenu:Remove()
	end
end
local edited_flexes = {}
CloseMenu()
local faded_black = Color(27, 27, 27)
FlexMenu = vgui.Create("DFrame")
timer.Create("FlexMenu.Close", 60 * 5, 1, CloseMenu)
FlexMenu:SetSize(ss(300), ss(175))
FlexMenu:Center()
FlexMenu:SetTitle("")
FlexMenu:SetDraggable(false)
FlexMenu:MakePopup()

FlexMenu.Paint = function(self, w, h)
	draw.RoundedBox(5, 0, 0, w, h, faded_black)
end

-- draw.SimpleText("Derma Frame", "Font", 250, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
local panel = vgui.Create("DPanel", FlexMenu)
panel:DockMargin(10,0,5,10)
panel:Dock(FILL)
panel:InvalidateParent(true)
local wide = panel:GetWide()
panel:SetWide(wide * .5)
panel:Dock(LEFT)

panel.Paint = function(self, w, h)
	draw.RoundedBox(10, 0, 0, w, h, Color(63, 63, 63))
end

-- draw.SimpleText("Derma Frame", "Font", 250, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
local poss = {"pose_standing_02", "pose_standing_04", "pose_standing_01", "idle_all_01"}

local parsed = markup.Parse([[<font=Instructions_7>Move Camera: </font><colour=194,248,255><font=Instructions_6>W A S D</font></colour>
<font=Instructions_7>Rotate Camera: </font><colour=194,248,255><font=Instructions_6>Left-Click + Drag</font></colour>
<font=Instructions_7>Speed Up: </font><colour=194,248,255><font=Instructions_6>Shift</font></colour>
<font=Instructions_7>Slow Down: </font><colour=194,248,255><font=Instructions_6>Alt</font></colour>
<font=Instructions_7>Switch Pos: </font><colour=194,248,255><font=Instructions_6>Right-Click</font></colour>
<font=Instructions_7>Reset: </font><colour=194,248,255><font=Instructions_6>R</font></colour>]])
local text = vgui.Create("DPanel", panel)
text:SetSize(panel:GetWide(), panel:GetTall())
text:Dock(BOTTOM)
text:MoveToBack()
text.Paint = function(self, w, h)
	-- draw.RoundedBox(2, 0, 0, w, h, Color(0, 2, 107))
	-- if modelPanel.CamPos and modelPanel.CamAngle then
	-- 	local c, a = modelPanel.CamPos, modelPanel.CamAngle
	-- 	draw.SimpleText(("Vector(%s,%s,%s) Angle(%s,%s,%s)"):format(r(c.x),r(c.y),r(c.z),r(a[1]),r(a[2]),r(a[3])), "Default", ss(100), ss(4), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	-- end
	parsed:Draw(ss(2), ss(1), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end


local modelPanel = vgui.Create("DModelPanel", text)
modelPanel:Dock(FILL)
modelPanel:InvalidateParent(true)
modelPanel:SetModel(LocalPlayer():GetModel())
print(modelPanel:GetModel())
modelPanel:SetAnimated(true)
modelPanel.PosIndex = 1
modelPanel:SetDirectionalLight(BOX_RIGHT, Color(255, 160, 80, 255))
modelPanel:SetDirectionalLight(BOX_LEFT, Color(80, 160, 255, 255))
modelPanel:SetAmbientLight(Vector(-64, -64, -64))
--modelPanel.Paint = function(s,w,h)
--end
local r = math.Round

-- modelPanel:SetLookAt(Vector(-100, 0, 0))
function modelPanel:DefaultPos()
	self.CamAngle = Angle(0, 180, 0)
	self.CamPos = Vector(30, 0, 64)
	self:SetLookAng(self.CamAngle)
	self:SetCamPos(self.CamPos)
end

modelPanel:DefaultPos()
local stance = modelPanel:GetEntity():LookupSequence(poss[modelPanel.PosIndex])

if stance then
	modelPanel:GetEntity():SetSequence(stance)
end

function modelPanel:LayoutEntity(Entity)
	return
end

function modelPanel.Entity:GetPlayerColor()
	return Vector(1, 0, 0)
end

-- function modelPanel:OnMouseWheeled(de)
-- 	if self:IsHovered() then
-- 		local forw = self:GetLookAng():Forward()
-- 		local campos = self:GetCamPos()
-- 		self:SetCamPos(campos + (forw * (d * 2)))
-- 	end
-- 	-- print("test")
-- end
-- function modelPanel:DragMousePress(button)
-- 	self.PressX, self.PressY = gui.MousePos()
-- 	self.Pressed = button
-- end
-- function modelPanel:OnMouseWheeled(delta)
-- 	self.WheelD = delta * -10
-- 	self.Wheeled = true
-- end
-- function modelPanel:DragMouseRelease()
-- 	self.Pressed = false
-- end
function modelPanel:FreeCamThink()
	local Speed = 1

	if input.IsKeyDown(KEY_LSHIFT) or input.IsKeyDown(KEY_RSHIFT) then
		Speed = Speed * 3
	end

	if input.IsKeyDown(KEY_LALT) or input.IsKeyDown(KEY_RALT) then
		Speed = Speed * .05
	end

	local camAngle = self.CamAngle

	if input.IsKeyDown(KEY_W) then
		self.CamPos = self.CamPos + camAngle:Forward() * Speed
	end

	if input.IsKeyDown(KEY_S) then
		self.CamPos = self.CamPos - camAngle:Forward() * Speed
	end

	if input.IsKeyDown(KEY_A) then
		self.CamPos = self.CamPos - camAngle:Right() * Speed
	end

	if input.IsKeyDown(KEY_D) then
		self.CamPos = self.CamPos + camAngle:Right() * Speed
	end

	if input.IsKeyDown(KEY_SPACE) then
		self.CamPos = self.CamPos + camAngle:Up() * Speed
	end

	if input.IsMouseDown(MOUSE_LEFT) then
		if not self.LM then
			self.LM = true
			local MX, MY = gui.MousePos()
			self.LastMousePos_X = MX
			self.LastMousePos_Y = MY
		else
			local CX, CY = gui.MousePos()
			local DX, DY = self.LastMousePos_X - CX, self.LastMousePos_Y - CY
			self.CamAngle.p = self.CamAngle.p - DY / 3

			if self.CamAngle.p > 90 then
				self.CamAngle.p = 90
			end

			if self.CamAngle.p < -90 then
				self.CamAngle.p = -90
			end

			self.CamAngle.y = self.CamAngle.y + DX / 6
			self.LastMousePos_X = CX
			self.LastMousePos_Y = CY
		end
	else
		if self.LM then
			self.LM = false
		end
	end

	self:SetLookAng(self.CamAngle)
	self:SetCamPos(self.CamPos)
end

local clicked = false

function modelPanel:Think()
	if not self:IsHovered() then return end
	self:GetEntity():SetEyeTarget(self.CamPos)

	if not clicked and input.IsMouseDown(MOUSE_RIGHT) then
		self.PosIndex = self.PosIndex + 1

		if self.PosIndex > #poss then
			self.PosIndex = 1
		end

		stance = modelPanel:GetEntity():LookupSequence(poss[modelPanel.PosIndex])

		if stance then
			modelPanel:GetEntity():SetSequence(stance)
		end

		clicked = true
	elseif clicked and not input.IsMouseDown(MOUSE_RIGHT) then
		clicked = false
	end

	if input.IsKeyDown(KEY_R) then
		self:DefaultPos()
	else
		self:FreeCamThink()
	end
	-- print("test")
end

-- modelPanel:DefaultPos()
-- modelPanel.Paint = function(self, w, h)
-- 	-- draw.RoundedBox(2, 0, 0, w, h, Color(255, 255, 255))
-- end
local flPanel = vgui.Create("DPanel", FlexMenu)
flPanel:DockMargin(10,0,10,10)
-- flexlist:SetWide(wide * .5)
flPanel:Dock(FILL)
-- panel:InvalidateParent(true)
flPanel:InvalidateParent(true)

flPanel.Paint = function(self, w, h)
	draw.RoundedBox(10, 0, 0, w, h, Color(63, 63, 63))
	-- draw.RoundedBox(10, 10, 10, w - 20, h - 20, Color(63, 63, 63))
end

local flexList = vgui.Create("DScrollPanel", flPanel)
flexList:DockMargin(10,10,10,10)
flexList:SetTall(flPanel:GetTall() * .75)
flexList:Dock(TOP)


-- local pong = math.cos( CurTime() * 3 ) + 1
-- local zero = false
-- zero = pong < 0 or zero
-- print(zero,pong > 1, pong < 0, pong)
-- if flexList.SelectedFlex then
-- 	local gw, gt = self:GetWide(), self:GetTall()
-- 	local pw,ph = self:GetWide() * .9, self:GetTall() * .035
-- 	local px,py = 0,0
-- 	local scale = 20
-- 	draw.RoundedBox(2, px,gt - ph, pw,ph, Color(0, 2, 107))
-- 	draw.RoundedBox(2, px + pong,py, ss(3), ss(3), Color(107, 0, 32))
-- end

local lp = LocalPlayer()
for i = 0, lp:GetFlexNum() do
	local fButton = flexList:Add( "DButton" )
	fButton:SetText( "" )
	fButton:Dock( TOP )
	fButton:SetTall(ss(8))
	fButton.FlexNumber = i
	fButton:DockMargin( 0, 0, 0, 5 )
	function fButton:DoClick()
		flexList.SelectedFlex = self.FlexNumber
		if flexList.Slider then
			flexList.Slider:SetVisible(true)
		end
		if flexList.ApplyButton then
			flexList.ApplyButton:SetVisible(true)
		end
	end
	function fButton:Think()
		modelPanel:GetEntity()
	end
	fButton.Paint = function(self, w, h)
		draw.RoundedBox(3, 0, 0, w, h, flexList.SelectedFlex == i and Color(25, 121, 37) or Color(42, 42, 42))
		draw.SimpleTextOutlined(lp:GetFlexName( i ),"Instructions_7", w * .5, h * .5, color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,3,color_black)
		-- draw.RoundedBox(10, 10, 10, w - 20, h - 20, Color(63, 63, 63))
	end
end
local flexEdit = vgui.Create("DPanel", flPanel)
flexEdit:DockMargin(10,10,10,10)
surface.SetFont("Instructions_7")
local _, pad = surface.GetTextSize("Select a Flex to start editing")
flexEdit:DockPadding(ss(3),pad + 5,ss(3),0)
-- flexEdit:SetTall(flPanel:GetTall() * .75)
flexEdit:Dock(FILL)
flexEdit.Paint = function(self, w, h)
	draw.RoundedBox(10, 0, 0, w, h, Color(41, 41, 41))
	if flexList.SelectedFlex then
		surface.SetFont("Instructions_7")
		local tw, _ = surface.GetTextSize("Editing Flex: ")
		draw.SimpleText("Editing Flex: ","Instructions_7",ss(1),ss(1),Color(217,255,252),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		draw.SimpleText(lp:GetFlexName( flexList.SelectedFlex ),"Instructions_7",tw + ss(1),ss(1),color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		-- draw.SimpleTextOutlined("Editing Flex: " .. lp:GetFlexName( flexList.SelectedFlex ),"Instructions_7", ss(1), ss(1), color_white, TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,3,color_black)
	else
		draw.SimpleText("Select a Flex to start editing","Instructions_7",ss(1),ss(1),Color(217,255,252),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
	end
	-- draw.RoundedBox(10, 10, 10, w - 20, h - 20, Color(63, 63, 63))
end

local nSlider = vgui.Create( "DNumSlider", flexEdit )
flexList.Slider = nSlider
nSlider:SetVisible(false)
nSlider:Dock(TOP)
surface.SetFont("Instructions_7")
local _, tall = surface.GetTextSize("Maximum Flex: ")
nSlider:SetTall( tall + ss(5) )
nSlider:SetText( "" )
nSlider:SetMin( 0 )
nSlider:SetMax( 10 )
nSlider:SetDecimals( 3 )
nSlider.Paint = function(self, w, h)
	draw.RoundedBox(10, 0, h * .5 - (tall * .5), w, tall, Color(66, 66, 66))
	draw.SimpleText("Maximum Flex","Instructions_5",ss(3), h * .5,Color(230,230,230),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
end
nSlider.OnValueChanged = function( self, value )
	edited_flexes[flexList.SelectedFlex] = value
	print(flexList.SelectedFlex, " : ", value)
	--timer.Remove("FlexMenu.UpdatePlayerModelMouth")
	--timer.Create("FlexMenu.UpdatePlayerModelMouth", 0.1, 0, function() 
		modelPanel.Entity:SetFlexWeight(flexList.SelectedFlex, value)
	--end)
	-- flexList.SelectedFlex
end

local tb = vgui.Create("DButton", flexEdit)
flexList.ApplyButton = tb
tb:SetVisible(false)
tb:SetTall(ss(5))
tb:Dock(TOP)
tb:DockMargin(ss(30),ss(4),ss(30),0)
function tb:DoClick()
	print(edited_flexes[flexList.SelectedFlex])
end
tb:SetText("")
tb.Paint = function(self, w, h)
	draw.RoundedBox(3, 0, 0, w, h, Color(25, 121, 37) )
	draw.SimpleText("Apply Changes","Instructions_4", w * .5, h * .5,Color(230,230,230),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end