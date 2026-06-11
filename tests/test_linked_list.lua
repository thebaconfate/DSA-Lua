require("luarocks.loader")
local luaunit = require("luaunit")
---@type LinkedList
local LinkedList = require("src.linked_list")


TestLinkedList = {}

-- 1. Test Constructor & Empty State (:new and :isEmpty)
function TestLinkedList:testConstructorAndEmptyState()
    local list = LinkedList.new()

    luaunit.assertTrue(list:isEmpty())
    luaunit.assertEquals(list:length(), 0)
    luaunit.assertNil(list:head())
end

-- 2. Test Prepend & Fluency (:prepend)
function TestLinkedList:testPrependChaining()
    local list = LinkedList.new()

    -- Testing that it updates correctly and allows chaining
    local returnedList = list:prepend(30):prepend(20):prepend(10)

    luaunit.assertTrue(list:isEmpty())
    luaunit.assertEquals(returnedList:length(), 3)
    luaunit.assertEquals(returnedList:head(), 10)
    -- Verify that it returned 'self' for chaining
    luaunit.assertNotEquals(returnedList, list)
end

-- 3. Test Append & Fluency (:append)
function TestLinkedList:testAppendChaining()
    local list = LinkedList.new()

    -- Append on empty list, then subsequent appends
    local returnedList = list:append("A"):append("B"):append("C")

    luaunit.assertEquals(returnedList:length(), 3)
    luaunit.assertEquals(returnedList:head(), "A")
    luaunit.assertEquals(returnedList:nth(3), "C")
    luaunit.assertNotEquals(returnedList, list)
end

-- 4. Test Tail Slicing (:tail)
function TestLinkedList:testTail()
    local list = LinkedList.fromTable({ 10, 20, 30 })

    local tail1 = list:tail()
    luaunit.assertEquals(tail1:head(), 20)
    luaunit.assertEquals(tail1:length(), 2)
    luaunit.assertNotEquals(list, tail1)

    local tail2 = tail1:tail()
    luaunit.assertEquals(tail2:head(), 30)
    luaunit.assertEquals(tail2:length(), 1)
    luaunit.assertNotEquals(list, tail2)

    -- Tail of a single element list should be an empty list
    local tail3 = tail2:tail()
    luaunit.assertTrue(tail3:isEmpty())
    luaunit.assertEquals(tail3:length(), 0)
    luaunit.assertNotEquals(list, tail2)

    luaunit.assertError(function()
        tail3:tail()
    end)
end

-- 5. Test Static Factory (.fromTable)
function TestLinkedList:testFromTable()
    local list = LinkedList.fromTable({ "apple", "banana", "cherry" })

    luaunit.assertEquals(list:length(), 3)
    luaunit.assertEquals(list:head(), "apple")
    luaunit.assertEquals(list:nth(2), "banana")
    luaunit.assertEquals(list:nth(3), "cherry")
end

-- 6. Test Element Access & Errors (:nth)
function TestLinkedList:testNthElementAccess()
    local list = LinkedList.fromTable({ 100, 200, 300 })

    luaunit.assertEquals(list:nth(1), 100)
    luaunit.assertEquals(list:nth(2), 200)
    luaunit.assertEquals(list:nth(3), 300)
end

-- 7. Test Boundary / Edge Cases for Errors
function TestLinkedList:testNthErrors()
    local list = LinkedList.fromTable({ 1, 2 })

    -- Test lower boundary (index < 1)
    luaunit.assertErrorMsgContains(
        "Index must be at least 1",
        function() list:nth(0) end
    )
    luaunit.assertErrorMsgContains(
        "Index must be at least 1",
        function() list:nth(-5) end
    )

    -- Test upper boundary (index out of bounds)
    luaunit.assertErrorMsgContains(
        "Index exceeds length of linked list",
        function() list:nth(3) end
    )
end

function TestLinkedList.testMap()
    local list = LinkedList.fromTable({ 1, 2, 3, 4, 5, 6 })
    local mappedList = list:map(function(value)
        return value * 2
    end)
    luaunit.assertEquals(mappedList:head(), 2)
    luaunit.assertEquals(mappedList:tail():head(), 4)
end

os.exit(luaunit.LuaUnit.run())
