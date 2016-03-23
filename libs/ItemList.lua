SitRepItemList = {}
SitRepItemList.__index = SitRepItemList
--SitRepItemList._items = {}
SitRepItemList._count = 0

function SitRepItemList:New()
    local o = { }
    setmetatable(o, self)
    o._items = {}
    return o
end

function SitRepItemList:Increment()

    self._count = self._count + 1

end

function SitRepItemList:NumItems() 

    return self._count

end

function SitRepItemList:Add(item, link)
    item = GetItemQualityColor(GetItemLinkQuality(link)):Colorize(zo_strformat(" - <<1>>", item))
    table.insert(self._items, item)
    --self._items[self:NumItems()] = item
    self:Increment()
    return self:NumItems()
end

function SitRepItemList:GetItems()

    return self._items

end
