-- Inferno river maze 1F

water_delay = 500 -- delay between each water step
current_pool_index = 0
camera_timer = ""

-- TODO B1: 4 and 2 initially filled
pools = {
  { initially_filled = false, trigger = "switch", x = 104, y = 464 },
  { initially_filled = false, trigger = "switch", x = 208, y = 88  },
  { initially_filled = false, trigger = "block",  x = 104, y = 192 },
  { initially_filled = false, trigger = "switch", x = 208, y = 304 },
  { initially_filled = true,  trigger = "block",  x = 360, y = 552 },
  { initially_filled = false, trigger = "switch", x = 728, y = 552 },
  { initially_filled = true,  trigger = "block",  x = 800, y = 280 },
  { initially_filled = false, trigger = "switch", x = 632, y = 368 },
  { initially_filled = false, trigger = "switch", x = 672, y = 88  }
}
savegame_variable = 160

function event_map_started(destination_point_name)

  -- some pools should be filled
  for i = 1,#pools do
    if pools[i].initially_filled ~= sol.game.savegame_get_boolean(savegame_variable + i) then
      sol.map.tile_set_enabled("water_"..i.."_full", true)
      if pools[i].trigger == "block" then
        sol.map.block_set_enabled("water_"..i.."_on_block", false)
      else
        sol.map.switch_set_activated("water_"..i.."_on_switch", true)
      end
    elseif pools[i].trigger == "block" then
      sol.map.block_set_enabled("water_"..i.."_off_block", false)
    end
  end
end

function event_switch_activated(switch_name)

  if string.match(switch_name, "^water_[1-9]_on_switch$") then
    index = tonumber(string.sub(switch_name, 7, 7))
    fill_water(index)
  end
end

function fill_water(index)
  current_pool_index = index
  camera_timer = "fill_water_step_1"
  sol.map.camera_move(pools[index].x, pools[index].y, 250)
end

function drain_water(index)
  current_pool_index = index
  camera_timer = "drain_water_step_1"
  sol.map.camera_move(pools[index].x, pools[index].y, 250)
end

function event_camera_reached_target()
  sol.main.timer_start(1000, camera_timer, false)
end

function fill_water_step_1()
  sol.main.play_sound("water_fill_begin")
  sol.main.play_sound("water_fill")
  sol.map.tile_set_enabled("water_"..current_pool_index.."_less_3", true)
  sol.main.timer_start(water_delay, "fill_water_step_2", false)
end

function fill_water_step_2()
  sol.map.tile_set_enabled("water_"..current_pool_index.."_less_3", false)
  sol.map.tile_set_enabled("water_"..current_pool_index.."_less_2", true)
  sol.main.timer_start(water_delay, "fill_water_step_3", false)
end

function fill_water_step_3()
  sol.map.tile_set_enabled("water_"..current_pool_index.."_less_2", false)
  sol.map.tile_set_enabled("water_"..current_pool_index.."_less_1", true)
  sol.main.timer_start(water_delay, "fill_water_step_4", false)
end

function fill_water_step_4()
  sol.map.tile_set_enabled("water_"..current_pool_index.."_less_1", false)
  sol.map.tile_set_enabled("water_"..current_pool_index.."_full", true)
  sol.main.timer_start(1000, "sol.map.camera_restore", false)
  sol.game.savegame_set_boolean(savegame_variable + current_pool_index,
    not pools[current_pool_index].initially_filled)
end

function drain_water_step_1()
  sol.main.play_sound("water_drain_begin")
  sol.main.play_sound("water_drain")
  sol.map.tile_set_enabled("water_"..current_pool_index.."_full", false)
  sol.map.tile_set_enabled("water_"..current_pool_index.."_less_1", true)
  sol.main.timer_start(water_delay, "drain_water_step_2", false)
end

function drain_water_step_2()
  sol.map.tile_set_enabled("water_"..current_pool_index.."_less_1", false)
  sol.map.tile_set_enabled("water_"..current_pool_index.."_less_2", true)
  sol.main.timer_start(water_delay, "drain_water_step_3", false)
end

function drain_water_step_3()
  sol.map.tile_set_enabled("water_"..current_pool_index.."_less_2", false)
  sol.map.tile_set_enabled("water_"..current_pool_index.."_less_3", true)
  sol.main.timer_start(water_delay, "drain_water_step_4", false)
end

function drain_water_step_4()
  sol.map.tile_set_enabled("water_"..current_pool_index.."_less_3", false)
  sol.main.timer_start(1000, "sol.map.camera_restore", false)
  sol.game.savegame_set_boolean(savegame_variable + current_pool_index,
    pools[current_pool_index].initially_filled)
end

