local init_file_snippets = {}

local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local f = ls.function_node
local utils = require("java.rename.utils")

local function getShiftWidth()
    return vim.api.nvim_buf_get_option(0, "shiftwidth")
end

local function getPackageName()
    local folder = vim.fn.expand("%:h")

    local splitted = utils.split(folder, "main/java/")

    -- if main/java could not be found, try test/java
    if #splitted <= 1 then
        splitted = utils.split(folder, "test/java/")
    end

    if #splitted <= 1 then
        return ""
    end

    local packageName = splitted[2]:gsub("/", ".")

    return "package " .. packageName .. ";"
end

local function getClassName()
    return vim.fn.expand("%:t:r")
end


local function generateString(type)
    return {
        getPackageName(),
        "",
        "public " .. type .. " " .. getClassName() .. " {",
        string.rep(" ", getShiftWidth())
    }
end

--- setup snippets that can be used for creating a default class
function init_file_snippets.setup()
    ls.add_snippets(
        "java",
        {
            ls.s(
                "class",
                fmt("{}{}\n}}", { f(function() return generateString("class") end), i(1) })
            ),


            ls.s(
                "aclass",
                fmt("{}{}\n}}", { f(function() return generateString("abstract class") end), i(1) })
            ),

            ls.s(
                "interface",
                fmt("{}{}\n}}", { f(function() return generateString("interface") end), i(1) })
            ),

            ls.s(
                "enum",
                fmt("{}{}\n}}", { f(function() return generateString("enum") end), i(1) })
            )
        }
    )
end

return init_file_snippets
