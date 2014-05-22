
charas = Character()
gfx = Graphics()
st = Stage()

scale = 1/60
obsts = {
    {0, 0, 1431, 0.1, "ground"},
}
plats = {
    {-591, 204, 461, 1, "plat1"},
    {  12, 576, 420, 1, "plat2"},
    { 393, 270, 507, 1, "plat3"},
}
size = {w = 1920, h = 1080}
center = {x = 960, y = 190}

init = function(path)
    print("Initialising the stage with path : " .. path)

    -- Initialising the map
    st.worldCenter(0, 350*scale)
    st.maxSize(size.w*scale, size.h*scale)
    st.deathRect(size.w*scale, size.h*scale)
    st.minSize(7,7)
    st.appearPos(0,-5.6,1)
    st.appearPos(1,-1.9,1)
    st.appearPos(2,1.9,1)
    st.appearPos(3,5.6,1)

    -- Loading the textures
    newpath = path .. "/rcs/"
    ret = true
    ret = ret and gfx.loadTexture("bg",    newpath .. "bg.png")
    ret = ret and gfx.loadTexture("plats", newpath .. "plats.png")
    if not ret then
        return false
    end

    -- Setting up the physic
    ret = true
    for k,v in ipairs(obsts) do
        ret = ret and st.obstacle(v[5], v[1]*scale, v[2]*scale, v[3]*scale, v[4]*scale)
    end
    for k,v in ipairs(plats) do
        ret = ret and st.platform(v[5], v[1]*scale, v[2]*scale + v[4]*scale/2 - 0.05, v[3]*scale, 0.1)
    end
    if not ret then
        print("Stage couldn't create the physics obstacle and platforms !")
        return false
    end

    return true
end

drawBG = function()
    -- Drawing the background
    gfx.push()
    gfx.move(-center.x*scale, -center.y*scale)
    gfx.drawRect("bg",    size.w*scale, size.h*scale)
    gfx.drawRect("plats", size.w*scale, size.h*scale)
    gfx.pop()

end
