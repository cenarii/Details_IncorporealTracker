local addon, Engine = ...
local IncorporealTracker = LibStub('AceAddon-3.0'):NewAddon(addon)

Engine.Core = IncorporealTracker
_G[addon] = Engine

local _G = _G
local Details = _G.Details

local CustomDisplay = {
    name = "Incorporeal Tracker",
    icon = 236298,
    source = false,
    attribute = false,
    spellid = false,
    target = false,
    author = "Cenarii",
    desc = "Show how many Incorporeal Beings players have used cc on",
    script_version = 1,
    script = [[
        local combat, instance_container, instance = ...
        local total, top, amount = 0, 0, 0
        local misc_actors = combat:GetActorList (DETAILS_ATTRIBUTE_MISC)
        local dam_actors = combat:GetActorList (DETAILS_ATTRIBUTE_DAMAGE)

        for index, character in ipairs (misc_actors) do
            if (character:IsPlayer()) then
                local cc_done = 0
                if(character.cc_done and character.cc_done_targets['Incorporeal Being']) then
                    cc_done = floor (character.cc_done_targets['Incorporeal Being'])
                end
                if(character.interrupt and character.interrupt_targets['Incorporeal Being']) then
                    cc_done = cc_done + floor (character.interrupt_targets['Incorporeal Being'])
                end
                instance_container:AddValue (character, cc_done)
                total = total + cc_done
                if (cc_done > top) then
                    top = cc_done
                end
                amount = amount + 1
            end
        end

        return total, top, amount
    ]],
    tooltip = [[
        local actor, combat, instance = ...

        local spells = {}
        local spells_to_parse = {}

        local OverallCombat = Details:GetCombat(-1)
        local player = OverallCombat [1]:GetActor(actor.nome)
        if (player) then
            local playerSpells = player:GetSpellList()
            
            for spellid, spell in pairs(playerSpells) do
                if(spell.targets['Incorporeal Being'] and tonumber(spell.targets['Incorporeal Being'] > 1)) then
                    tinsert (spells, {spellid, spell.targets['Incorporeal Being']})
                end
            end
        end

        if (actor.cc_done) then
            for spellid, spell in pairs (actor.cc_done_spells._ActorTable) do
                if(spell.targets['Incorporeal Being']) then
                    tinsert (spells, {spellid, spell.targets['Incorporeal Being']})
                end
            end
        end

        if (actor.interrupt) then
            for spellid, spell in pairs (actor.interrupt_spells._ActorTable) do
                if(spell.targets['Incorporeal Being']) then
                    tinsert (spells, {spellid, spell.targets['Incorporeal Being']})
                end
            end
        end

        table.sort (spells, _detalhes.Sort2)

        for index, spell in ipairs (spells) do
            local name, _, icon = GetSpellInfo (spell [1])
            GameCooltip:AddLine (name, spell [2])
            _detalhes:AddTooltipBackgroundStatusbar()
            GameCooltip:AddIcon (icon, 1, 1, _detalhes.tooltip.line_height, _detalhes.tooltip.line_height)
        end
    ]],
    total_script = [[
        local value, top, total, combat, instance = ...
        return floor (value)
    ]],
    percent_script = [[
        local value, top, total, combat, instance = ...
        return string.format("%.1f", value/total*100)
    ]]
}

Details:InstallCustomObject(CustomDisplay)