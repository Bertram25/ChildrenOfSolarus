---------------------------------------
-- Sahasrahla's cave icy room script --
---------------------------------------

-- Function call when the map starts
function event_map_started(destination_point_name)

   if sol.game.savegame_get_boolean(35) then
      -- remove the frozen door
      sol.map.interactive_entity_remove("frozen_door")
      sol.map.interactive_entity_remove("frozen_door_opposite")
   else
      -- initialize the direction of the frozen door sprites
      sol.map.interactive_entity_set_direction("frozen_door", 3)
      sol.map.interactive_entity_set_direction("frozen_door_opposite", 1)
   end
end

-- Function called when the player presses the action key on the frozen door
function event_hero_interaction(entity_name)

   if entity_name == "frozen_door" then
      sol.map.dialog_start("sahasrahla_house.frozen_door")
      sol.game.savegame_set_boolean(34, true)
   end
end

-- Function called when the player uses an item on the frozen door
function event_hero_interaction_item(entity_name, item_name, variant)

   if entity_name == "frozen_door" and
      string.match(item_name, "^bottle") and variant == 2 then

      -- using water on the frozen door
      sol.map.hero_freeze()
      sol.map.interactive_entity_set_animation("frozen_door", "disappearing")
      sol.map.interactive_entity_set_animation("frozen_door_opposite", "disappearing")
      sol.main.timer_start(800, "timer_frozen_door", false)
      return true
   end

   return false
end

-- Function called when the door is unfreezed
function timer_frozen_door()
   sol.main.play_sound("secret")
   sol.game.savegame_set_boolean(35, true)
   sol.map.interactive_entity_remove("frozen_door")
   sol.map.interactive_entity_remove("frozen_door_opposite")
   sol.map.hero_unfreeze()
end
