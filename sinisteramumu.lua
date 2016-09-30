if GetObjectName(myHero) ~= "Amumu" then return end

require('OpenPredict')

print("Sinister Amumu Loaded")

local AmumuMenu = Menu("JaxNation", "JaxNation")

AmumuMenu:Menu("Combo", "Combo")
AmumuMenu.Combo:Boolean("useQ", "Use Q", true)
AmumuMenu.Combo:Boolean("useW", "Use W", true)
AmumuMenu.Combo:Boolean("useE", "Use E", true)
AmumuMenu.Combo:Boolean("useR", "Use R", true)

AmumuMenu:SubMenu("a", "AutoLvl")
AmumuMenu.a:Boolean("aL", "Use AutoLvl", true)
AmumuMenu.a:DropDown("aLS", "AutoLvL", 1, {"Q-W-E","Q-E-W"})
AmumuMenu.a:Slider("sL", "Start AutoLvl with LvL x", 1, 1, 18, 1)
VMenu.a:Boolean("hL", "Humanize LvLUP", true

--Spells
local AmumuQ = { range = 1100}
local AmumuW = { range = 300}
local AmumuE = { range = 350}
local AmumuR = { range = 550}

--Start
OnTick(function(myHero)
    if not IsDead(myHero) then
        local target = GetCurrentTarget()

        --Combo
        if IOW:Mode() == "Combo" then
            --Q
            if AmumuMenu.Combo.useQ:Value() and Ready(_Q) and ValidTarget(target, GetRange(myHero) + GetHitBox(target)) then
                CastSkillShot(_Q)
            end
            --W
            if AmumuMenu.Combo.useW:Value() and Ready(_W) and ValidTarget(target, AmumuW.range) then
                CastTargetSpell(target,_W)
            end
            --E
            if AmumuMenu.Combo.useW:Value() and Ready(_E) and ValidTarget(target, GetRange(myHero)) then
                CastSpell(_E)
            end
            --R
            if AmumuMenu.Combo.useR:Value() and Ready(_R) and EnemiesAround(myHero, 600) >= 1 then
                CastSpell(_R)
            end
        end
    end
end)

function lvlUp()
	if VMenu.a.aL:Value() and GetLevelPoints(myHero) >= 1 and GetLevel(myHero) >= VMenu.a.sL:Value() then
		if VMenu.a.hL:Value() then
			DelayAction(function() LevelSpell(lTable[VMenu.a.aLS:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1]) end, math.random(0.500,0.750))
		else
			LevelSpell(lTable[VMenu.a.aLS:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1])
		end
	end
end


AmumuMenu:SubMenu("s", "Skin Changer")
  skinMeta = {["Amumu"] = {"Classic", "Emumu", "Almost-Prom King", "Pharaoh", "Surprise Party", "Re-Gifted", "Vancouver", "Sad Robot", "Little Knight""}}
  AmumuMenu.s:DropDown('skin', myHero.charName.. " Skins", 1, skinMeta[myHero.charName],function(model)
        HeroSkinChanger(myHero, model - 1) print(skinMeta[myHero.charName][model] .." ".. myHero.charName .. " Loaded!") 
    end,
true)
