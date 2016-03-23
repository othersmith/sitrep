
function formatOutput(header, warning, armor, weapon) 
    local outp = ""

    outp = outp .. header

    if (zo_strlen(warning) > 0) then
        outp = outp .. warning
    end
    outp = outp .. "\n"
    --d(armor:NumItems())
    --d(weapon:NumItems())    
    if (armor:NumItems() > 0) then
        outp = outp .. EsoStrings[SR_ARMOR_ATTENTION]
        local armor_table = armor:GetItems()
        for index, value in pairs(armor_table) do
            outp = outp .. value .. "\n"
        end 
    end

    if (armor:NumItems() > 0) and (weapon:NumItems() > 0) then
        outp = outp .. "\n"
    end
    if (weapon:NumItems() > 0) then
        outp = outp .. zo_strformat(EsoStrings[SR_WEAPON_ATTENTION], weapon:NumItems())    
        local weapon_table =  weapon:GetItems()    
        for index, value in pairs(weapon_table) do
            outp = outp .. value .. "\n"
        end 
    end

    return outp

end

function comma_value(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end


function generate_sitrep (savedVariables) 
        local outp_header   = ""
        local outp_warning  = ""

        local weapon_list   = SitRepItemList:New()
        local armor_list    = SitRepItemList:New()

        local place = GetMapName()
        outp_header = outp_header .. string.format(EsoStrings[SR_SITUATION_TITLE], place) ..  "\n"

        -- Current Financial Situation
 		outp_header = outp_header .. string.format(EsoStrings[SR_GOLD_IN_POCKET], comma_value(GetCurrentMoney()))

        local bank_money = GetBankedMoney()
 		if (bank_money > 0) then
 			outp_header = outp_header .. string.format(EsoStrings[SR_GOLD_IN_BANK], comma_value(bank_money))
 		end
        -- End Current Financial Situation


        -- BAG WARNING Check
        should_warn = CheckInventorySpaceAndWarn(10)
		if (should_warn) then

		else
			outp_warning = outp_warning .. EsoStrings[SR_INVENTORY_WARNING]
		end
        -- End BAG WARNING Check

        -- attributes & CP
        local unspent_attributes = GetAttributeUnspentPoints()
        if (unspent_attributes >= savedVariables.attributesThreshold) then
            outp_header = outp_header .. zo_strformat(EsoStrings[SR_UNSPENT_ATTRIBUTES_WARNING], unspent_attributes)
        end

        local unspentCP = GetNumUnspentChampionPoints(1) + GetNumUnspentChampionPoints(2) + GetNumUnspentChampionPoints(3)
        if (unspentCP > 0) then
            outp_header = outp_header .. zo_strformat(EsoStrings[SR_UNSPENT_CP_WARNING], unspentCP)
        end

        -- end attributes

        -- weapon and armor check
        local bagid = 0

        local bag_size = GetBagSize(0)
        local slotid = 0
        while slotid < bag_size do

            local item_name = GetItemName(0, slotid)

            if (zo_strlen(item_name) > 0) then
 		        local item_link = GetItemLink(0, slotid, 0)
                local item_type = GetItemLinkItemType(item_link)

                -- check condition of armor slots
                if (item_type == 2) then
                    local condition = GetItemCondition(0, slotid)
                    if (DoesItemHaveDurability(0,slotid)) then
                        if (condition < savedVariables.armorThreshold) then
                            armor_list:Add(item_name, item_link)
                        end
                    end
                end
                -- End check condition of armor slots

                -- check enchantment charge of weapon slots
                if (item_type == 1) then
                    local condition = GetItemLinkNumEnchantCharges(item_link)
                    local max_condition = GetItemLinkMaxEnchantCharges(item_link)
                    local condition_percent = (condition / max_condition) * 100
                    local hasEnchant, enchantHeader, enchantDescription = GetItemLinkEnchantInfo(item_link)

                    if (hasEnchant) then
                        if (condition_percent < savedVariables.weaponThreshold) then
                            weapon_list:Add(item_name, item_link)
                        end
                    end
                end
                -- end check enchantment charge of weapon slots
            end
            slotid = slotid + 1
        end

		SitRepMessage:SetText(formatOutput(outp_header, outp_warning, armor_list, weapon_list))
        
        zo_callLater(sitRepClose, savedVariables.timeToDisplay)



end
