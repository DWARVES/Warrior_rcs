
charas = Character()
gfx = Graphics()
st = Stage()

obsts = {
    {-50,0, 1, 99, "left_wall"},
    { 50,-25, 1, 49, "right_wall"},
    {0,-10, 20,20, "center"},
}
plats = {
    {0,-50, 101,1,  "ground"},
    {-25,-25, 5,1,  "spawn1"},
    {-25, 25, 5,1,  "spawn2"},
    { 25, 25, 5,1,  "spawn3"},
    { 25,-25, 5,1,  "spawn4"},
    -- From ground to spawn1
    {-20,-45, 4,.5, "up1"},
    {-20,-40, 4,.5, "up2"},
    {-20,-35, 4,.5, "up3"},
    {-20,-30, 4,.5, "up4"},
    -- From spawn1 to spawn2
    {-20,-20, 4,.5, "up5"},
    {-20,-15, 4,.5, "up6"},
    {-20,-10, 4,.5, "up7"},
    {-20,-5,  4,.5, "up8"},
    {-20, 0,  4,.5, "up9"},
    {-20, 5,  4,.5, "up10"},
    {-20, 10, 4,.5, "up11"},
    {-20, 15, 4,.5, "up12"},
    {-20, 20, 4,.5, "up13"},
    -- From spawn2 to center
    -- From center to spawn3
    { 16,  5, 4,.5, "up14"},
    { 18, 10, 4,.5, "up15"},
    { 20, 15, 4,.5, "up16"},
    { 25, 20, 4,.5, "up17"},
}
traps = {
    {20, -25, 5, .5, "trap1"},
}

init = function(path)
    print("Initialising the stage with path : " .. path)

    -- Initialising the map
    st.worldCenter(0, 0)
    st.maxSize(200, 200)
    st.deathRect(120,120)
    st.minSize(10,10)
    st.appearPos(0,-5.6,1)
    st.appearPos(1,-1.9,1)
    st.appearPos(2,1.9,1)
    st.appearPos(3,5.6,1)

    -- Loading the textures
    newpath = path .. "/rcs/"
    ret = true
    ret = ret and gfx.loadTexture("stone", newpath .. "stone.png")
    ret = ret and gfx.loadTexture("grass", newpath .. "grass.png")
    ret = ret and gfx.loadTexture("bgimg", newpath .. "bgimg.png")
    ret = ret and gfx.loadTexture("bgstc", newpath .. "bgstc.png")
    ret = ret and gfx.loadTexture("ctrfg", newpath .. "ctrfg.png")
    ret = ret and gfx.loadTexture("grsfg", newpath .. "grsfg.png")
    if not ret then
        return false
    end

    -- Setting up the physic
    ret = true
    for k,v in ipairs(obsts) do
        ret = ret and st.obstacle(v[5], v[1], v[2], v[3], v[4])
    end
    for k,v in ipairs(plats) do
        ret = ret and st.platform(v[5], v[1], v[2] + v[4]/2 - 0.05, v[3], 0.1, 0.1)
    end
    if not ret then
        print("Stage couldn't create the physics obstacle and platforms !")
        return false
    end

    -- Adding traps callbacks
    for k,v in ipairs(traps) do
        ret = ret and st.sensor(v[5], v[1], v[2], v[3], v[4])
        ret = ret and st.watch(v[5], "trap_in", "trap_out", "")
    end
    if not ret then
        print("Stage couldn't set the traps up.")
        return false
    end

    -- Adding callbacks for sensor
    if not st.sensor("sensor", -45, -25, 10, 50) then
        return false
    end
    if not st.watch("sensor", "touched", "left", "inct") then
        return false
    end

    return true
end

drawBG = function()
    -- Drawing the background
    gfx.push()
    gfx.move(-50,-50)
    gfx.drawRect("bgimg", 100, 100)
    gfx.pop()

    -- Drawing the obstacles
    for k,v in ipairs(obsts) do
        gfx.push()
        gfx.move(v[1] - v[3]/2, v[2] - v[4]/2)
        repeatX = v[3] / 2.0
        repeatY = v[4] / 2.0
        gfx.drawRect("stone", v[3], v[4], repeatX, repeatY)
        gfx.pop()
    end

    -- Drawing the platforms
    for k,v in ipairs(plats) do
        gfx.push()
        gfx.move(v[1] - v[3]/2, v[2] - v[4]/2)
        repeatX = v[3] / 1.0
        repeatY = v[4] / 1.0
        gfx.drawRect("grass", v[3], v[4], repeatX, repeatY)
        gfx.pop()
    end
end

drawFG = function()
    for k,v in ipairs(plats) do
        gfx.push()
        gfx.move(v[1] - v[3]/2, v[2] + v[4]/2)
        gfx.drawRect("grsfg", v[3], v[4], v[3], 1)
        gfx.pop()
    end
end

drawStaticBG = function()
    gfx.drawRect("bgstc", st.width(), st.height())
end

drawStaticFG = function ()
    gfx.drawRect("ctrfg", st.width(), st.height())
end

touched = function (id)
    charas.current(id)
    charas.impulse(0, 30)
    charas.damage(20)
    charas.requireMana(10)
    print("Character " .. id .. " entered the lift.")
end

left = function (id)
    charas.current(id)
    charas.stun(3000)
    charas.impact(0, 50)
    print("Character " .. id .. " left the lift.")
end

inct = function (id)
    charas.current(id)
    charas.force(0,50)
end

trap_in = function (id)
    charas.current(id)
    charas.damage(100)
    print("Does that hurt " .. id .. " ?")
end

trap_out = function (id)
    charas.current(id)
    charas.stun(5000)
    print("Trapped, " .. id)
end

