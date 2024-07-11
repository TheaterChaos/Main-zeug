local items = {}

local function spawn_item(target)
    local item = target.selected_option
    local i, j = string.find(item.help, "Spawn command:")
    local commandname = ""
    if i != nil then
        commandname = string.sub(item.help, i)
        commandname = string.replace(commandname, "Spawn command:", "")
    end
    menu.trigger_commands(commandname)
end

function get_vehicle(root, mainroot, table)
    if table == nil then table = {} end
    for _, ref in pairs(menu.get_children(root)) do
        if mainroot then
            if _ <= 4 then
                continue
            end
        end
        for _1, v1 in ref.command_names do
            local name = menu.get_menu_name(ref)
            local numberplate = menu.get_help_text(ref)
            local item = {
                name = name,
                help = "Spawn "..name.."   "..numberplate.."    Spawn command:"..v1.."request",
                applicable_to={"COORDS"},
                execute = spawn_item,
            }
            table.insert(table, item)
        end
    end
    return table
end


-- Avoid locking up GTA when reading files by running in os thread
get_vehicle(menu.ref_by_path("Vehicle>Personal Vehicles"), true,items)

return {
    name="GTA Garage",
    help="Spawn a vehicle from your GTA Garage",
    applicable_to={"COORDS"},
    items=items,
}
