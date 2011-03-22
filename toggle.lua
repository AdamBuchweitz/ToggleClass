local ToggleClass = {}

ToggleClass.help = function()
    print("Syntax for a new Toggle::\n\n\tToggleClass.new()")
end

--[[

@params = table

Available params:

    -- Start with the state true or false
    state,

    -- On and Off images
    on,
    off,

    -- Use these if you are using dynamic resolution images
    onWidth,
    onHeight,
    offWidth
    offHeight,

    -- Use these if you want a pure text toggle
    -- To use these you may NOT include any of the image parameters
    onText,
    offText
    font,
    textSize,
    textColor,


]]
ToggleClass.new = function(params)
    local params = params
    if not params then
        error("You must supply parameters to make a new Toggle")
        return false
    end

    local toggle = display.newGroup()
    toggle.state = tostring(params.state) ~= "false"

    local onImg
    if params.onWidth and params.onHeight then
        onImg = display.newImageRect(params.on, params.onWidth, params.onHeight)
        onImg:setReferencePoint(display.TopLeftReferencePoint) 
    elseif params.onText then
        onImg = display.newText(params.onText, 0, 0, params.font, params.textSize)
        onImg:setReferencePoint(display.CenterLeftReferencePoint) 
        onImg:setTextColor(params.textColor[1],params.textColor[2],params.textColor[3])
    else
        onImg = display.newImage(params.on)
        onImg:setReferencePoint(display.TopLeftReferencePoint) 
    end
    onImg.x, onImg.y = 0, 0

    local offImg
    if params.offWidth and params.offHeight then
        offImg = display.newImageRect(params.off, params.offWidth, params.offHeight)
        offImg:setReferencePoint(display.TopLeftReferencePoint) 
    elseif params.offText then
        offImg = display.newText(params.offText, 0, 0, params.font, params.textSize)
        offImg:setReferencePoint(display.CenterLeftReferencePoint) 
        offImg:setTextColor(params.textColor[1],params.textColor[2],params.textColor[3])
    else
        offImg = display.newImage(params.off)
        offImg:setReferencePoint(display.TopLeftReferencePoint) 
    end
    offImg.x, offImg.y = 0, 0

    if not toggle.state then
        onImg.isVisible = false
    else
        offImg.isVisible = false
    end


    toggle:insert(onImg)
    toggle:insert(offImg)

    toggle.touch = function(self, event)
        if event.phase == "began" then
            if toggle.state == true then
                toggle.state = false
                onImg.isVisible = false
                offImg.isVisible = true
            else
                toggle.state = true
                onImg.isVisible = true
                offImg.isVisible = false
            end
            if params.callback then params.callback( toggle ) end
            return false
        end
    end
    if onImg.text then
        onImgRect = display.newRect(0, 0, onImg.contentWidth, onImg.contentHeight*.5)
        onImgRect:setReferencePoint(display.CenterLeftReferencePoint) 
        onImgRect:setFillColor(0,0,0,0)
        offImgRect = display.newRect(0, 0, offImg.contentWidth, offImg.contentHeight*.5)
        offImgRect:setReferencePoint(display.CenterLeftReferencePoint) 
        offImgRect:setFillColor(0,0,0,0)
        local rectGroup = display.newGroup(onImgRect, offImgRect)
        rectGroup:addEventListener("touch", toggle)
        toggle:insert(rectGroup)
    else
        toggle:addEventListener("touch", toggle)
    end

    toggle.setState = function( bool, fireCallback )
        toggle.state = tostring(bool) ~= "false"
        if toggle.state then
            onImg.isVisible = true
            offImg.isVisible = false
        else
            onImg.isVisible = false
            offImg.isVisible = true
        end
        if fireCallback and params.callback then params.callback(toggle) end
    end

    return toggle
end

return ToggleClass
