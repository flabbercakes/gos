if GetObjectName(GetMyHero()) ~= "Garen" then return end


--MENU
 GarenMenu = Menu('Garen', 'Sinister Garen')

GarenMenu:SubMenu('Combo', 'Combo')
GarenMenu.Combo:DropDown('ComboMode', 'Combo mode', 1, {'EWQR', 'QWER'})
GarenMenu.Combo:Boolean('Q', 'Use Q', true)
GarenMenu.Combo:Boolean('W', 'Use W', true)
GarenMenu.Combo:Boolean('E', 'Use E', true)
GarenMenu.Combo:Boolean('R', 'Use R', true)

GarenMenu:SubMenu('Killsteal', 'Killsteal')
GarenMenu.Killsteal:Boolean('KQ', 'Killsteal with Q', true)
GarenMenu.Killsteal:Boolean('KE', 'Killsteal with E', true)
GarenMenu.Killsteal:Boolean('KR', 'Killsteal with R', true)

GarenMenu:SubMenu('Farm', 'Farm')
GarenMenu.Farm:Boolean('LH', 'Last hit minions AA', false)
GarenMenu.Farm:Boolean('LHQ', 'Last hit Q small minions', false)
GarenMenu.Farm:Boolean('LHBQ', 'Last hit Q big minions', false)
GarenMenu.Farm:Boolean('LHE', 'Last hit E small minions', false)
GarenMenu.Farm:Boolean('LHBE', 'Last hit E big minions', false)

GarenMenu:SubMenu('Misc', 'Misc')
GarenMenu.Misc:Boolean('Ignite', 'Ignite if killable', true)
GarenMenu.Misc:Boolean('Level', 'Auto level', true)
GarenMenu.Misc:Boolean('AQ', 'Auto Q on gap close', true)

GarenMenu:SubMenu('Drawings', 'Drawings')
GarenMenu.Drawings:Boolean('DQ', 'Draw Q range', true)
GarenMenu.Drawings:Boolean('DWE', 'Draw W&E range', true)
GarenMenu.Drawings:Boolean('DR', 'Draw R range', true)
GarenMenu.Drawings:Boolean('DDMG', 'Draw DMG on HP bar', true)
GarenMenu.Drawings:Boolean('DCM', 'Draw circle on minions', true)
GarenMenu.Drawings:Boolean('SF', 'Draw if slower or faster', true)
GarenMenu.Drawings:Boolean('CT', 'Draw circle on curent target', true)

--COMBO FUNCTIONS

	--SPELL FUNCTIONS
	function ComboQ()
		if GarenMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, QRange) then
			if QPredTarget.HitChance == 1 then
				CastActiveSpell(_Q, QPredTarget.PredPos)
			end
		end
	end

	function ComboW()
		if GarenMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, WRange) then
			CastActiveSpell(target, _W)
		end
	end

	function ComboE()
		if GarenMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, ERange) then
			CastActiveSpell(target, _E)
		end
	end
	
		function ComboR()
		if GarenMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, RRange) then
			CastTargetSpell(target, _R)
		end
	end
	
OnTick(function (myHero)

	--VARIABLES
	target = GetCurrentTarget()
	MaxMana = GetMaxMana(myHero)
	MaxHP = GetMaxHP(myHero)
	CurrentHP = GetCurrentHP(myHero)
	BaseAD = GetBaseDamage(myHero)
	BonusAD = GetBonusDmg(myHero)
	BonusAP = GetBonusAP(myHero)
	MeleeRange = 175	
	QRange = 300
	WRange = 20
	ERange = 325
	QDmg = 35 + 25 * GetCastLevel(myHero, _Q) + BonusAD * 1.40
	EDmg = 25 + 25 * GetCastLevel(myHero, _E) + BonusAD * 0.3 
	RDmg = 25 + 25 * GetCastLevel(myHero, _R)
	QPredTarget = GetPredictionForPlayer(myHeroPos(), target, GetMoveSpeed(target), 1700, 250, 900, 50, false, true)
	BigMinionBlue = 'SRU_OrderMinionSiege'
	BigMinionRed = 'SRU_ChaosMinionSiege'
	SuperMinionBlue = 'SRU_OrderMinionSuper'
	SuperMinionRed = 'SRU_ChaosMinionSuper'

--COMBO
	if IOW:Mode() == 'Combo' then

		--EWQR
		if GarenMenu.Combo.ComboMode:Value() == 1 then
			ComboE()
			ComboW()
			ComboQ()
			ComboR()
		end

		--QWER
		if GarenMenu.Combo.ComboMode:Value() == 2 then
			ComboQ()
			ComboW()
			ComboE()
			ComboR()
		end
		
		--RQWE
		if GarenMenu.Combo.ComboMode:Value() == 2 then
			ComboR()
			ComboQ()
			ComboW()
			ComboE()
		end

	else
	
			--LAST HIT BIG MINIONS Q
		if GarenMenu.Farm.LHBQ:Value() then
				if not UnderTurret(GetOrigin(myHero), enemyTurret) then
					if IsObjectAlive(myHero) then
						for _, minion in pairs(minionManager.objects) do
							if ValidTarget(minion, WRange) and GetCurrentHP(minion) < QDmg then

								if GetTeam(myHero) == 100 then

									if GetObjectName(minion) == SuperMinionRed then
										if Ready(_Q) then
											CastTargetSpell(minion, _Q)
										end
									end

									if GetObjectName(minion) == BigMinionRed then
										if Ready(_W) then
											CastTargetSpell(minion, _Q)
										end
									end

								end

								if GetTeam(myHero) == 200 then

									if GetObjectName(minion) == SuperMinionBlue then
										if Ready(_W) then
											CastTargetSpell(minion, _Q)
										end
									end

									if GetObjectName(minion) == BigMinionBlue then
										if Ready(_W) then
											CastTargetSpell(minion, _Q)
										end
									end

								end

							end
						end
					end
				end
			end
		end
		
			--LAST HIT BIG MINIONS E
		if GarenMenu.Farm.LHBE:Value() then
				if not UnderTurret(GetOrigin(myHero), enemyTurret) then
					if IsObjectAlive(myHero) then

						for _, minion in pairs(minionManager.objects) do

							if ValidTarget(minion, ERange) and GetCurrentHP(minion) < EDmg then
								if GetTeam(myHero) == 100 then

									if GetObjectName(minion) == SuperMinionRed then
										if Ready(_Q) then
											CastSkillShot(_E, minion)
										end
									end

									if GetObjectName(minion) == BigMinionRed then
										if Ready(_Q) then
											CastSkillShot(_E, minion)
										end
									end

								end

								if GetTeam(myHero) == 200 then

									if GetObjectName(minion) == SuperMinionBlue then
										if Ready(_Q) then
											CastSkillShot(_E, minion)
										end
									end

									if GetObjectName(minion) == BigMinionBlue then
										if Ready(_Q) then
											CastSkillShot(_E, minion)
										end
									end

								end

							end
						end

					end
				end
			end
		end
		
				--LAST HIT SMALL MINIONS Q
		if GarenMenu.Farm.LHQ:Value() then
				if not UnderTurret(GetOrigin(myHero), enemyTurret) then
					if IsObjectAlive(myHero) then
						for _, minion in pairs(minionManager.objects) do
							if GetObjectName(minion) ~= BigMinionBlue and GetObjectName(minion) ~= BigMinionRed and GetObjectName(minion) ~= SuperMinionBlue and GetObjectName(minion) ~= SuperMinionRed then
								if ValidTarget(minion, WRange) and GetCurrentHP(minion) < WDmg then
									if Ready(_W) then
										CastTargetSpell(minion, _W)
									end
								end
							end
						end
					end
				end
			end
		end
		
				--LAST HIT MINIONS AA
		if not UnderTurret(GetOrigin(myHero), enemyTurret) then
			if GarenMenu.Farm.LH:Value() then
				for _, minion in pairs(minionManager.objects) do
					if ValidTarget(minion, MeleeRange) and GetCurrentHP(minion) < BaseAD + BonusAD then
						AttackUnit(minion)
					end
				end
			end
		end

	end
	
		--LANE CLEAR / JUNGLE CLEAR
	x = 0
	closestJungle = ClosestMinion(myHero, 300)
	closestMinion = ClosestMinion(myHero, 300 - GetTeam(myHero))
	if IOW:Mode() == 'LaneClear' then
		for _, minion in pairs(minionManager.objects) do
			if GotBuff(minion, 'GarenQ') > 0 then
				IOW:ResetAA()
				buffData = GetBuffData(minion, 'GarenQ')
				if buffData.Count > 0 then
					x = x + 1
				end
				if Ready(_E) and ValidTarget(minion, ERange) then
					CastTargetSpell(minion, _E)
				end
				if GetCurrentHP(minion) < (QDmg + QDmg * 0.4) then
					if Ready(_Q) and ValidTarget(minion, QRange) then
						CastActiveSpell(_Q, minion)
					end

				if Ready(_E) and ValidTarget(minion, ERange) and GetCurrentHP(minion) <= EDmg then
					CastActiveSpell(minion, _E)
				elseif Ready(_E) and ValidTarget(closestMinion, ERange) then
					CastActiveSpell(closestMinion, _E)
				elseif Ready(_E) and ValidTarget(closestJungle, ERange) then
					CastActiveSpellclosestJungle, _E)
				end
			end
		end
	end
	
		--KILLSTEAL
	for _, enemy in pairs(GetEnemyHeroes()) do

		 QPredEnemy = GetPredictionForPlayer(myHeroPos(), enemy, GetMoveSpeed(enemy), 1700, 250, 900, 50, true, true)
		
		if GarenMenu.Killsteal.KQ:Value() and Ready(_Q) and ValidTarget(enemy, QRange) then
			if GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, QDmg) then
				if QPredEnemy.HitChance == 1 then
					CastSkillShot(_Q, QPredEnemy.PredPos)
				end
			end
		end

		if GarenMenu.Killsteal.KE:Value() and Ready(_E) and ValidTarget(enemy, ERange) then
			if GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, EDmg) then
				CastTargetSpell(enemy, _E)
			end
		end

	end

	--AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end
	
	--AUTO LEVEL
	if SionMenu.Misc.Level:Value() then
		spellorder = {_Q, _E, _W, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W}
		if GetLevelPoints(myHero) > 0 then
			LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
		end
	end
	
		--CURRENT TARGET CIRCLE
	if GarenMenu.Drawings.CT:Value() then
		if IsObjectAlive(myHero) then
			DrawCircle(GetOrigin(target), 100, 5, 8, ARGB(100, 255, 0, 255))
		end
	end
	
	--DRAW ON ENEMY
	for _, enemy in pairs(GetEnemyHeroes()) do

		if ValidTarget(enemy) then

			--DRAW IF KILLABLE
			 enemyPos = GetOrigin(enemy)
			 drawpos = WorldToScreen(1,enemyPos.x, enemyPos.y, enemyPos.z)

			if GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, QDmg) and Ready(_Q) then

				DrawText('Q', 13, drawpos.x-60, drawpos.y, GoS.Green)
			
			elseif GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, WDmg) and Ready(_W) then

				DrawText('W', 13, drawpos.x-60, drawpos.y, GoS.Green)

			elseif GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, EDmg) and Ready(_E) then

				DrawText('E', 13, drawpos.x-60, drawpos.y, GoS.Green)

			elseif GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, QDmg) + CalcDamage(myHero, enemy, 0, WDmg) and Ready(_Q) and Ready(_W) then

				DrawText('Q + W', 13, drawpos.x-60, drawpos.y, GoS.Green)

			elseif GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, QDmg) + CalcDamage(myHero, enemy, 0, EDmg) and Ready(_Q) and Ready(_E) then

				DrawText('Q + E', 13, drawpos.x-60, drawpos.y, GoS.Green)

			elseif GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, WDmg) + CalcDamage(myHero, enemy, 0, EDmg) and Ready(_W) and Ready(_E) then

				DrawText('W + E', 13, drawpos.x-60, drawpos.y, GoS.Green)

			elseif GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, QDmg) + CalcDamage(myHero, enemy, 0, WDmg) + CalcDamage(myHero, enemy, 0, EDmg) and Ready(_Q) and Ready(_W) and Ready(_E) then

				DrawText('Q + W + E', 13, drawpos.x-60, drawpos.y, GoS.Green)

			end

--DRAW DMG ON HP BAR
			if GarenMenu.Drawings.DDMG:Value() then
				if Ready(_Q) and Ready(_W) and Ready(_E) then

					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QDmg) + CalcDamage(myHero, enemy, 0, WDmg) + CalcDamage(myHero, enemy, 0, EDmg), GoS.Cyan)

				elseif Ready(_Q) and Ready(_W) then

					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QDmg) + CalcDamage(myHero, enemy, 0, WDmg), GoS.Cyan)

				elseif Ready(_Q) and Ready(_E) then

					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QDmg) + CalcDamage(myHero, enemy, 0, EDmg), GoS.Cyan)

				elseif Ready(_W) and Ready(_E) then

					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WDmg) + CalcDamage(myHero, enemy, 0, EDmg), GoS.Cyan)

				elseif Ready(_Q) then

					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QDmg), GoS.Cyan)

				elseif Ready(_W) then

					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WDmg), GoS.Cyan)

				elseif Ready(_E) then

					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, EDmg), GoS.Cyan)
				
				end
			end
			
		--DRAW IF FASTER OR SLOWER
			if GarenMenu.Drawings.SF:Value() then
				if IsObjectAlive(myHero) then
					if GetMoveSpeed(myHero) < GetMoveSpeed(enemy) then
						DrawText('Slower', 13, drawpos.x, drawpos.y, GoS.Red)
					else
						DrawText('Faster', 13, drawpos.x, drawpos.y, GoS.Green)
					end
				end
			end

		end

	end		

--DRAW CIRCLE ON MINIONS
	if GarenMenu.Drawings.DCM:Value() then
		if IsObjectAlive(myHero) then
			for _, minion in pairs(minionManager.objects) do
				if ValidTarget(minion, MeleeRange) then
					if GetCurrentHP(minion) < BaseAD + BonusAD + (BaseAD + BonusAD) * 0.20 and GetCurrentHP(minion) > BaseAD + BonusAD then
						DrawCircle(GetOrigin(minion), 50, 2, 8, ARGB(100, 255, 0, 0))
					elseif GetCurrentHP(minion) < BaseAD + BonusAD then
						DrawCircle(GetOrigin(minion), 50, 2, 8, ARGB(100, 0, 255, 0))
					end
				end
			end
		end
	end

end)	

print("Thanks Testing out my Script" ..myHero.name.. " :)")	
