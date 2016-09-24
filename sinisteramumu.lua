if GetObjectName(GetMyHero()) ~= "Amumu" then return end	

require("OpenPredict")

local AmumuMenu = Menu("Amumu", "Amumu")						
AmumuMenu:SubMenu("Combo", "Combo")							
AmumuMenu.Combo:Boolean("Q", "Use Q", true)						
AmumuMenu.Combo:Boolean("W", "Use W", true)						
AmumuMenu.Combo:Boolean("R", "Use R", true)						
AmumuMenu.Combo:Boolean("KSQ", "Killsteal with Q", true)		
AmumuMenu.Combo:Boolean("UOP", "Use OpenPredict for R", true)
Amumu.c:Slider("RE", "Enemies around for R", 3, 1, 5, 2)

AmumuMenu:SubMenu("ks", "Killsteal")
AmumuMenu.ks:Boolean("KSS","Smart Killsteal", true)
AmumuMenu.ks:Boolean("KSQ","Killsteal with Q", true)
AmumuMenu.ks:Boolean("KSE","Killsteal with E", true)

AmumuMenu:SubMenu("p", "Prediction")
AmumuMenu.p:Slider("hQ", "HitChance Q", 20, 60, 100, 80)

AmumuMenu:SubMenu("d", "Draw Damage")
AmumuMenu.d:Boolean("dD","Draw Damage", true)
AmumuMenu.d:Boolean("dQ","Draw Q", true)
AmumuMenu.d:Boolean("dW","Draw W", true)
AmumuMenu.d:Boolean("dE","Draw E", true)
AmumuMenu.d:Boolean("dR","Draw R", true)

OnTick(function()									--The code inside the Function runs every tick
	
	local target = GetCurrentTarget()					--Saves the "best" enemy champ to the target variable
		
	if IOW:Mode() == "Combo" then						--Check if we are in Combo mode (holding space)
			
		
				if AmumuMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 550) then		
			if not AmumuMenu.Combo.UOP:Value() then			
				local QPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target), math.huge, 10, 1100, 10, true, true)
				if QPred.HitChance == 1 then		
					CastSkillShot(_Q,QPred.PredPos)			
				end		
				local QPred = GetCircularAOEPrediction(target,AmumuQ)	
				if RPred.hitChance > 0.2 then							
					CastSkillShot(_Q,QPred.castPos)						
				end
			end
	
		if AmumuMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 300) then
			local targetPos = GetOrigin(target)		--saves the XYZ coordinates of the target to the variable
			CastSpell(_W)			--Since the W is a skillshot (select area), we have to cast it at a point on the ground (targetPos)
		end		--Ends the W logic
	
			if AmumuMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 350) then
			local targetPos = GetOrigin(target)		
			CastSpell(_E)			
		end		
		
		if AmumuMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 550) then		
			if not AmumuMenu.Combo.UOP:Value() then			
				local RPred = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target), math.huge, 2,  550,  550, false, true)
				if RPred.HitChance == 1 then		
					CastSkillShot(_R,RPred.PredPos)			
				end		
			else		
				local RPred = GetCircularAOEPrediction(target,AnnieR)	
				if RPred.hitChance > 0.2 then							
					CastSkillShot(_R,RPred.castPos)						
				end
			end
		end	
	end		
	
	--KillSteal
	for _, enemy in pairs(GetEnemyHeroes()) do
		if AmumuMenu.KillSteal.KSQ:Value() and Ready(_Q) and ValidTarget(enemy, 1100) then
			if QDmg(enemy) >= GetCurrentHP(enemy) then
				CastTargetSpell(enemy, _Q)
			end
		end

		if AmumuMenu.KillSteal.KSE:Value() and Ready(_E) and ValidTarget(enemy, 350) then
			if EDmg(enemy) >= GetCurrentHP(enemy) then
				CastSpell(_E)
			end
		end

	--AutoR
	for _, enemy in pairs(GetEnemyHeroes()) do
		if AmumuMenu.Misc.AR:Value() and Ready(_R) and ValidTarget(enemy, 550) and EnemiesAround(enemy, 300) >= MalphiteMenu.Misc.ARC:Value() then
			local RPred = GetCircularAOEPrediction(target,RStats)
			if RPred.hitChance >= 0.3 then 
				CastSkillShot(_R,RPred.castPos)
			end	
		end
	end
end

print("Thank You For Using Sinister Amumu")
