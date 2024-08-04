local items = {}

local function spawn_item(target)
    local item = target.selected_option
    item.name = item.name:gsub('%W', '')
    item.name = string.replace(item.name, " ", "")
    menu.trigger_commands("vehicle"..item.name)
end

function get_vehicle(root, mainroot, table)
    if table == nil then table = {} end
    for _, ref in pairs(menu.get_children(root)) do
        if mainroot then
            if _ < 5 then
                goto  end
            end
        end
        if menu.get_type(ref) == COMMAND_LIST then
            local name = menu.get_menu_name(ref)
            local newref = ref
            local folder_item = {
                name = name,
                help = "Browse "..name,
                items = get_vehicle(newref, false)
            }
            table.insert(table, folder_item) 
        else
            local name = menu.get_menu_name(ref)
            local item = {
                name = name,
                help = "Spawn "..name,
                applicable_to={"COORDS"},
                execute = spawn_item,
            }
            table.insert(table, item)
        end
        ::end::
    end
    return table
end


-- Avoid locking up GTA when reading files by running in os thread
get_vehicle(menu.ref_by_path("Vehicle>Garage"), true,items)

return {
    name="Garage",
    help="Spawn a vehicle from your Stand Garage",
    applicable_to={"COORDS"},
    items=items,
}
