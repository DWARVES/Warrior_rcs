
gfx = Graphics()
chara = Character()
colors = {"red", "blue", "green", "white", "black", "green"}
anims = { }
hotpoints = { }

load_hotpoints = function(path)
    if not io.input(path) then
        return false
    end

    line = io.read()
    while line do
        name,x,y = string.match(line, "^([^ i\t]+)[ \t]+([0-9]+)[ \t]+([0-9]+)")
        if name and x and y then
            hotpoints[name] = { x = x, y = y }
        end
        line = io.read()
    end

    return true
end

load_anim = function(name, path, fact)
    path_parser = Path()
    if not path_parser.list_contents(path) then
        return false
    end
    if not fact then
        fact = 1
    end

    ret = { maxms = 0 }
    while path_parser.has_content() do
        pth = path_parser.next_content()
        ms = string.match(pth, "^" .. name .. "_([0-9]*)%.png")
        if ms then
            if gfx.loadTexture(pth, path .. "/" .. pth) then
                nname = name .. "_" .. ms .. ".png";
                if hotpoints[nname] then
                    gfx.hotpoint(pth, hotpoints[nname].x, hotpoints[nname].y)
                else
                    gfx.hotpoint(pth, 336, 540)
                end
                ms = tonumber(ms) * fact
                id = 1
                while ret[id] and ret[id].ms < ms do
                    id = id + 1;
                end
                table.insert(ret, id, {ms = ms, name = pth})
            end
        end
    end
    ret.maxms = ret[#ret].ms
    anims[name] = ret
    return true
end

play_anim = function(name, ms, loop)
    if not anims[name] then
        return false
    end
    if ms > anims[name].maxms then
        if loop then
            ms = ms % anims[name].maxms
        else
            return false
        end
    end

    id = 1;
    while anims[name][id].ms < ms do
        id = id + 1
    end
    gfx.link("drawed", anims[name][id].name);
    return true
end

init = function(path, c)
    newpath = path .. "/" .. colors[c+1] .. "/"
    print("Init : " .. newpath)
    chara.current(characterID)
    chara.size(1,2)
    chara.weight(1.15)
    chara.mana(100)
    chara.manaRecov(0.01)
    chara.flip(true)

    if not load_hotpoints(newpath .. "hotpoints") then
        return false
    end

    ret = true
    ret = ret and load_anim("stand",      newpath, 50)
    ret = ret and load_anim("run",        newpath, 50)
    ret = ret and load_anim("stop",       newpath, 50)
    ret = ret and load_anim("land",       newpath, 20)
    ret = ret and load_anim("down",       newpath, 50)
    ret = ret and load_anim("jumpair",    newpath, 50)
    ret = ret and load_anim("attack",     newpath, 20)
    ret = ret and load_anim("attackup",   newpath, 20)
    ret = ret and load_anim("attackside", newpath, 20)
    ret = ret and load_anim("attackdown", newpath, 20)
    ret = ret and load_anim("attackair",  newpath, 40)
    ret = ret and load_anim("jump",       newpath, 50)
    ret = ret and gfx.loadTexture("attackairfront", newpath .. "attackairfront.png")
    gfx.hotpoint("attackairfront", 200, 400)
    ret = ret and gfx.loadTexture("attackairback",  newpath .. "attackairback.png")
    gfx.hotpoint("attackairback", 200, 400)
    ret = ret and gfx.loadTexture("attackairup",    newpath .. "attackairup.png")
    gfx.hotpoint("attackairup", 200, 400)
    ret = ret and gfx.loadTexture("attackairdown",  newpath .. "attackairdown.png")
    gfx.hotpoint("attackairdown", 200, 400)
    ret = ret and gfx.loadTexture("fastdown",       newpath .. "fastdown.png")
    gfx.hotpoint("fastdown", 200, 400)
    ret = ret and gfx.loadTexture("stunned",        newpath .. "stunned.png")
    gfx.hotpoint("stunned", 200, 400)
    ret = ret and gfx.loadTexture("spell",          newpath .. "spell.png")
    gfx.hotpoint("spell", 200, 400)
    ret = ret and gfx.loadTexture("spellside",      newpath .. "spellside.png")
    gfx.hotpoint("spellside", 200, 400)
    ret = ret and gfx.loadTexture("spellup",        newpath .. "spellup.png")
    gfx.hotpoint("spellup", 200, 400)
    ret = ret and gfx.loadTexture("spelldown",      newpath .. "spelldown.png")
    gfx.hotpoint("spelldown", 200, 400)
    ret = ret and gfx.loadTexture("smashside",      newpath .. "smashside.png")
    gfx.hotpoint("smashside", 200, 400)
    ret = ret and gfx.loadTexture("smashup",        newpath .. "smashup.png")
    gfx.hotpoint("smashup", 200, 400)
    ret = ret and gfx.loadTexture("smashdown",      newpath .. "smashdown.png")
    gfx.hotpoint("smashdown", 200, 400)
    ret = ret and gfx.loadTexture("staticdodge",    newpath .. "staticdodge.png")
    gfx.hotpoint("staticdodge", 200, 400)
    ret = ret and gfx.loadTexture("dashdodge",      newpath .. "dashdodge.png")
    gfx.hotpoint("dashdodge", 200, 400)
    ret = ret and gfx.loadTexture("catch",          newpath .. "catch.png")
    gfx.hotpoint("catch", 200, 400)
    ret = ret and gfx.loadTexture("lost",           newpath .. "lost.png")
    gfx.hotpoint("lost", 200, 400)
    ret = ret and gfx.loadTexture("won1",           newpath .. "won1.png")
    gfx.hotpoint("won1", 200, 400)
    ret = ret and gfx.loadTexture("won2",           newpath .. "won2.png")
    gfx.hotpoint("won2", 200, 400)
    ret = ret and gfx.loadTexture("up",             newpath .. "up.png")
    gfx.hotpoint("up", 200, 400)
    ret = ret and gfx.loadTexture("appear1",        newpath .. "appear1.png")
    gfx.hotpoint("appear1", 200, 370)
    ret = ret and gfx.loadTexture("appear2",        newpath .. "appear2.png")
    gfx.hotpoint("appear2", 200, 370)
    ret = ret and gfx.loadTexture("appear3",        newpath .. "appear3.png")
    gfx.hotpoint("appear3", 200, 370)
    ret = ret and gfx.loadTexture("appear4",        newpath .. "appear4.png")
    gfx.hotpoint("appear4", 200, 370)
    return ret
end

walk = function(ms)
    -- gfx.link("drawed", "walk")
    run(ms)
    return true
end

run = function(ms)
    play_anim("run", ms, true)
    return true
end

stop = function(ms)
    return play_anim("stop", ms, false)
end

jump = function(ms)
    play_anim("jump", ms, false)
    return true
end

jumpAir = function(ms)
    play_anim("jumpair", ms, false)
    return true
end

down = function(ms)
    play_anim("down", ms, true)
    return true
end

fastDown = function(ms)
    gfx.link("drawed", "fastdown")
    return true
end

land = function(ms)
    return play_anim("land", ms, false)
end

stand = function(ms)
    play_anim("stand", ms, false)
    return true -- Must stop on last picture, not loop anim
end

attack = function(ms)
    if ms == 0 then
        chara.current(characterID)
        chara.attack(0.5,0.5, true, "att_x", "att_y", "att_draw", "att_contact")
        print("Attacking !")
    end
    return play_anim("attack", ms, false)
end

att_x = function(ms)
    if ms == 0 then
        return 0.5
    else
        return 0
    end
end

att_y = function(ms)
    if ms == 0 then
        return 0.25
    else
        return 0
    end
end

att_draw = function(ms)
    if ms > 500 then
        print("End of attack : failure !")
        return false
    else
        return true
    end
end

att_contact = function(id)
    chara.current(id)
    chara.damage(5)
    print("End of attack : sucess !")
    return false
end

attackSide = function(ms)
    if ms == 0 then
        chara.current(characterID)
        chara.attack(0.5,0.5, true, "att_x", "att_y", "attside_draw", "attside_contact")
    end
    return play_anim("attackside", ms, false)
end

attside_draw = function(ms)
    if ms > 750 then
        return false
    else
        return true
    end
end

attside_contact = function(id)
    chara.current(id)
    chara.damage(50)
    return false
end

attackUp = function(ms)
    if ms == 0 then
        chara.current(characterID)
        if not chara.requireMana(50) then
            return false
        end
        chara.attack(0.5,0.75, true, "att_x", "att_y", "attup_draw", "attup_contact")
    end
    return play_anim("attackup", ms, false)
end

attup_draw = function(ms)
    if ms > 250 then
        return false
    else
        return true
    end
end

attup_contact = function(id)
    chara.current(id)
    chara.stun(10000)
    chara.impact(20,20, characterID)
end

attackDown = function(ms)
    return play_anim("attackdown", ms, false)
end

spell = function(ms)
    gfx.link("drawed", "spell")
    return true
end

spellSide = function(ms)
    gfx.link("drawed", "spellside")
    chara.current(characterID)
    return true
end

spellUp = function(ms)
    gfx.link("drawed", "spellup")
    return true
end

spellDown = function(ms)
    gfx.link("drawed", "spelldown")
    return true
end

smashSide = function(ms)
    gfx.link("drawed", "smashside")
    return true
end

smashUp = function(ms)
    gfx.link("drawed", "smashup")
    return true
end

smashDown = function(ms)
    gfx.link("drawed", "smashdown")
    return true
end

shield = function(ms)
    print("Shield !")
    return true
end

staticDodge = function(ms)
    gfx.link("drawed", "staticdodge")
    return true
end

flyingStaticDodge = function(ms)
    print("Static dodge on the air !")
    return true
end

dashDodge = function(ms)
    gfx.link("drawed", "dashdodge")
    return true
end

flyingDashDodge = function(ms)
    print("Dash dodge on the air !")
    return true
end

appear = function(pc)
    if(pc <= 25) then
        gfx.link("drawed", "appear1")
    elseif(pc <= 50) then
        gfx.link("drawed", "appear2")
    elseif(pc <= 75) then
        gfx.link("drawed", "appear3")
    else
        gfx.link("drawed", "appear4")
    end
    return true
end

won = function(ms)
    ms = math.floor(ms / 500);
    if(ms % 2 == 0) then
        gfx.link("drawed", "won1")
    else
        gfx.link("drawed", "won2")
    end
    return true
end

lost = function(ms)
    gfx.link("drawed", "lost")
    return true
end

sent = function(ms)
    print("Sent !")
    return true
end

catch = function(ms)
    gfx.link("drawed", "catch")
    return true
end

up = function(ms)
    gfx.link("drawed", "up")
    return true
end

stunned = function(ms)
    gfx.link("drawed", "stunned")
    return true
end

attackAir = function(ms)
    return play_anim("attackair", ms, false)
end

attackAirFront = function(ms)
    gfx.link("drawed", "attackairfront")
    return true
end

attackAirBack = function(ms)
    gfx.link("drawed", "attackairback")
    return true
end

attackAirUp = function(ms)
    gfx.link("drawed", "attackairup")
    return true
end

attackAirDown = function(ms)
    gfx.link("drawed", "attackairdown")
    return true
end



