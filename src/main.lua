local Set = require('lib/set')

-- Hides widget and build helper
unit.hideWidget()
system.showHelper(false)

-- Settings, those are accessible via Edit Lua Parameters
Initialization_Time = 6 --export: Ignore pings in the first X seconds
Notify_in_Safe_Zone = true --export: Notifies even in safe zone

-- This will allow us to notify or not
local notify = false

-- Stores a list of construct ids that were detected and which are matching transponder
local notified_constructs, matching_constructs = Set({}), Set({})

-- Allows scanning after X seconds
unit.setTimer('start', Initialization_Time)

-- Scans every 1 second
unit.setTimer('scan', 1)
unit:onEvent('onTimer', function(self, tag)
  -- Start-up
  if 'start' == tag then
    notify = true
    unit.stopTimer('start')
  end

  -- Scan
  if 'scan' == tag then
    for _, contact_id in pairs(radar.getConstructIds()) do
      -- Filters only dynamics
      if 5 == radar.getConstructKind(contact_id) then
        -- Avoid notifying twice
        if not notified_constructs.has(contact_id) then
          notified_constructs.add(contact_id)

          -- Checks transponder
          if radar.hasMatchingTransponder(contact_id) then
            matching_constructs.add(contact_id)
          end
          
          -- Only notify stuff after certain time has passed
          if notify and (Notify_in_Safe_Zone or construct.isInPvPZone()) then
            -- Logs the radar hit
            system.print('RADAR: ' .. radar.getConstructName(contact_id))

            -- Plays a ping
            if not system.isPlayingSound() then
              system.playSound('radar-ping.wav')
            end
          end
        end
      end
    end
  end
end)

-- Removes notified construct when something leaves radar range
radar:onEvent('onLeave', function(self, id)
  notified_constructs.remove(id)
  matching_constructs.remove(id)
end)

-- Renders UI
system:onEvent('onUpdate', function(self)
  local color = '#57ED9D'

  -- PVP text (Safe/PVP Space)
  local pvp = 'Currently in Safe Zone'
  if construct.isInPvPZone() then
    pvp = 'Currently in PVP Space'
  end

  -- Status text (Initializing/Active)
  local status = 'Initializing'
  if notify then
    status = 'Active'
  end
  
  -- Screen UI
  local template = [[
    <div style="position: absolute; top: 5em; left: 2.5em; color: {{color}}; font-family: Oxanium, sans-serif; font-size: 0.85em;">
      <div style="position: relative;">
        <svg viewBox="0 0 665 156" fill="none" xmlns="http://www.w3.org/2000/svg" style="width: 41.5625em; height: 9.75em; position: absolute; top: 0px; left: 0px;">
          <path d="M46.3311 153.5L2.88438 77.9998L46.3311 2.50006L618.669 2.5L662.116 78L618.669 153.5L46.3311 153.5Z" fill="black" fill-opacity="0.5" stroke="{{color}}" stroke-width="5"/>
          <g>
          <path d="M98 29.9999C71.5999 29.9999 50.0001 51.4398 50.0001 77.9998C50.0001 104.56 71.5999 126 98 126C124.4 126 146 104.4 146 77.9998C146 51.5998 124.4 29.9999 98 29.9999ZM98 122.8C73.36 122.8 53.2001 102.64 53.2001 78C53.2001 53.36 73.36 33.1999 98 33.1999C122.64 33.1999 142.8 53.3598 142.8 77.9998C142.8 102.64 122.64 122.8 98 122.8Z" fill="{{color}}"/>
          <path d="M98 45.9998C80.4 45.9998 66 60.3997 66 77.9998C66 79.7598 66.1599 81.5198 66.48 83.1198C66.48 83.9198 67.4399 84.5597 68.24 84.3998C69.0401 84.3998 69.68 83.4398 69.52 82.6398C69.3601 81.1998 69.2 79.5997 69.2 77.9998C69.2 62.1598 82.16 49.1998 98 49.1998C113.84 49.1998 126.8 62.1598 126.8 77.9998C126.8 93.8397 113.84 106.8 98 106.8C90.8428 106.8 84.103 104.297 78.8155 99.4241L87.8151 90.4245C90.6779 92.772 94.2161 93.9997 98 93.9997C106.8 93.9997 114 86.7998 114 77.9998C114 69.1998 106.8 61.9999 98 61.9999C89.2002 61.9999 82.0001 69.1999 82.0001 77.9998C82.0001 78.9597 82.0001 79.7598 82.3201 80.5599C82.3201 81.3599 83.2801 81.9998 84.0802 81.8399C84.8802 81.8399 85.5201 80.8799 85.3602 80.0799C85.2003 79.4399 85.2003 78.6399 85.2003 77.9998C85.2003 70.9598 90.9602 65.1997 98.0004 65.1997C105.041 65.1997 110.8 70.9596 110.8 77.9998C110.8 85.0397 105.041 90.7998 98.0004 90.7998C95.0346 90.7998 92.2982 89.8879 90.074 88.1664L94.7403 83.5001C95.6967 84.0706 96.8118 84.4 98.0004 84.4C101.52 84.4 104.4 81.52 104.4 77.9999C104.4 74.4799 101.52 71.5999 98.0004 71.5999C94.4803 71.5999 91.6003 74.4799 91.6003 77.9999C91.6003 79.1885 91.9297 80.3037 92.5003 81.26L86.6404 87.1198L75.4407 98.3196L69.6807 104.08C69.0408 104.719 69.0408 105.679 69.6807 106.32C70.0008 106.64 70.3207 106.8 70.8007 106.8C71.2807 106.8 71.6007 106.64 71.9206 106.32L76.5745 101.666C82.3802 107.046 90.0498 110 98.0005 110C115.601 110 130.001 95.7595 130.001 77.9996C130 60.3997 115.6 45.9998 98 45.9998ZM98 74.7997C99.76 74.7997 101.2 76.2397 101.2 77.9998C101.2 79.7598 99.76 81.1998 98 81.1998C97.2032 81.1998 96.4738 80.9026 95.9122 80.4163C95.8659 80.3555 95.8164 80.296 95.7601 80.2398C95.7039 80.1836 95.6444 80.134 95.5836 80.0877C95.0973 79.5259 94.8001 78.7966 94.8001 77.9999C94.8 76.2397 96.2399 74.7997 98 74.7997Z" fill="{{color}}"/>
          <path d="M67.6001 60.3997C67.6001 58.6397 66.1601 57.1997 64.4001 57.1997C62.64 57.1997 61.2 58.6397 61.2 60.3997C61.2 62.1598 62.64 63.5997 64.4001 63.5997C66.1601 63.5997 67.6001 62.1598 67.6001 60.3997Z" fill="{{color}}"/>
          <path d="M110.8 92.3997C110.8 94.1598 112.24 95.5997 114 95.5997C115.76 95.5997 117.2 94.1598 117.2 92.3997C117.2 90.6397 115.76 89.1997 114 89.1997C112.24 89.1997 110.8 90.6399 110.8 92.3997Z" fill="{{color}}"/>
          <path d="M118.8 50.7999C120.56 50.7999 122 49.36 122 47.5999C122 45.8399 120.56 44.3999 118.8 44.3999C117.04 44.3999 115.6 45.8399 115.6 47.5999C115.6 49.36 117.04 50.7999 118.8 50.7999Z" fill="{{color}}"/>
          </g>
          <defs>
          </defs>
        </svg>

        <div style="position: absolute; left: 10.5em; top: 1.75em; width: 30em;">
          <div style="font-size: 1.4em; font-weight: bold;">Wolfe Labs Asteroid Notification System</div>
          <div>
            <strong>STATUS:</strong>
            <span>{{status}}. {{pvp}}.</span>
          </div>
          <div>
            <strong>RADAR:</strong>
            <span>{{total}} radar pings, {{matched}} with matching transponder.</span>
          </div>
          <div>
            <strong>RANGE:</strong>
            <span>{{range}}m (out of 2000m) from ship.</span>
          </div>
        </div>
      </div>
    </div>
  ]]

  -- Renders screen
  system.showScreen(true)
  system.setScreen(
    template
      :gsub('%{%{color%}%}', color)
      :gsub('%{%{status%}%}', status)
      :gsub('%{%{pvp%}%}', pvp)
      :gsub('%{%{total%}%}', notified_constructs.size())
      :gsub('%{%{matched%}%}', matching_constructs.size())
      :gsub('%{%{range%}%}', ('%.1f'):format(2000 - (vec3(construct.getWorldPosition()) - vec3(player.getWorldPosition())):len()))
  )
end)