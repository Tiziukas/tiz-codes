AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
        return
    else
        lib.registerContext({
            id = 'IDMenu',
            title = Config.Language.contexttitle,
            onExit = toggleMenu(),
            options = {
                {
                    title = Config.Language.usecode,
                    description = Config.Language.usecodedesc,
                    icon = 'code',
                    onSelect = function()
                        DoApplication()
                    end,
                }
            }
        }) 
    end
end)
function toggleMenu()
    if menuOpen then
        menuOpen = false
    else
        menuOpen = true
    end
end
RegisterCommand(Config.Command, function(source)
    lib.showContext('IDMenu')  
end, false)
function DoApplication()
    local input = lib.inputDialog(Config.Language.idmenu, {
        {type = 'input', label = Config.Language.code, description = Config.Language.namedesc, required = true, min = 4, max = 16}
    })
    if not input then return end
    local playerID = source
    TriggerServerEvent("tizcodes:givecode", playerID, input)
end