module(..., package.seeall)

new = function(...)
    local params, b = ...
    params = b or params

    local onURL, offURL, callback, state = params.on, params.off, params.callback or nil, params.state
    local onWidth, onHeight, offWidth, offHeight = params.onWidth, params.onHeight, params.offWidth, params.offHeight
    local togGroup = display.newGroup()
    if state == "false" then state = false end
    togGroup.state = state

    local onImg 
    if onWidth and onHeight then
        onImg = display.newImageRect(onURL, onWidth, onHeight)
    else
        onImg = display.newImage(onURL)
    end
    onImg:setReferencePoint(display.TopLeftReferencePoint)
    onImg.x, onImg.y = 0, 0

    local offImg 
    if offWidth and offHeight then
        offImg = display.newImageRect(offURL, offWidth, offHeight)
    else
        offImg = display.newImage(offURL)
    end
    offImg:setReferencePoint(display.TopLeftReferencePoint)
    offImg.x, offImg.y = 0, 0

    if not togGroup.state then
        onImg.isVisible = false
    else
        offImg.isVisible = false
    end

    togGroup:insert(onImg)
    togGroup:insert(offImg)

    togGroup.tap = function()
        if togGroup.state == true or togGroup.state == "true" then
            togGroup.state = false
            onImg.isVisible = false
            offImg.isVisible = true
        else
            togGroup.state = true
            onImg.isVisible = true
            offImg.isVisible = false
        end
        callback( togGroup )
    end
    togGroup:addEventListener("tap", togGroup)

    togGroup.setState = function( bool, fireCallback )
        local bool = bool; if bool == "false" then bool = false end
        togGroup.state = bool
        if togGroup.state == true or togGroup.state == "true" then
            onImg.isVisible = true
            offImg.isVisible = false
        else
            onImg.isVisible = false
            offImg.isVisible = true
        end
        if fireCallback then callback(togGroup) end
    end

    return togGroup
end
