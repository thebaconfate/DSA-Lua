local luaunit = require("luaunit")
local LinkedList = require("src.linked_list")

TestLinkedList = {}

function TestLinkedList:testPrepend()
    local list = LinkedList.new()
    list = list:prepend(30):prepend(20):prepend(10)

    luaunit.assertEquals(list:head(), 10)
end

os.exit(luaunit.LuaUnit.run())
