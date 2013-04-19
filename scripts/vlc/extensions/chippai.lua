-- "chippai.lua" -- VLC Extension --
function descriptor()
    return {title = "Chippai";
        capabilities = { "input-listener" }
    }
end

-- Returns current movie's title (removes some tags)
 function get_current_title()
     local item = vlc.input.item()
     local name = item and item:name()
     if name ~= nil then
     -- look for meta-data
         local metas = item:metas()
             if metas["title"] then
                 return metas["title"]
             end
     end
     return name
end

function input_changed()
    vlc.msg.dbg("input_changed!!!!!!")
end

function meta_changed()
    vlc.msg.dbg("meta_changed!!!!!!")
end

function update_title()
    vlc.msg.dbg("update_title")
    local url = "http://localhost:3939/update?title=hogehoge2"
    local s = vlc.stream(url)
end

function activate()

--    update_title()
    local input=vlc.object.input();
    
    if input then
        vlc.msg.dbg("input!!!")
        vlc.var.add_callback(input, "intf-event", input_event_handler, "Hello world!")
    end

--     local url = "http://api.themoviedb.org/2.1/Movie.search/en/xml/"..APIKEY.."/"..title
--    local data = s:read(65535)

--    local d = vlc.dialog("Chippai" )
--    d:add_label("begin",1,1,1,1)
--    update_title(d)
    vlc.msg.dbg("hoge")
--    d:add_label(get_current_title(),1,1,1,1)
end

function deactivate()
end

function input_event_handler(var, old, new, data)
  vlc.msg.dbg("input_event_handler")
end
