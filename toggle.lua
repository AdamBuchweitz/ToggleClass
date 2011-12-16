
        --[[ ########## Toggle Class ########## ]--

    Version 1.0

    Written and supported by Adam Buchweitz and Crawl Space Games

    http://crawlspacegames.com
    http://twitter.com/crawlspacegames


    For inquiries about Crawl Space, email us at
        heyyou@crawlspacegames.com

    For support with this class, email me at
        adam@crawlspacegames.com


    Copyright (C) 2011 Crawl Space Games - All Rights Reserved



    :: FEATURES ::

    This toggle is a simple toggle switch. It is capable of switching
    between two images, with or without dynamic resolution, and can also
    switch between two strings.

    To toggle images, the only parameters needed are on and off images.
    To use dynamic resolution images, simply supply additional parameters
    for width and height.

    To toggle strings, you have the option of supplying a font, a text
    size, and a text color.

    The toggle switches via touch, but you can also set the state manually,
    and retrieve its state at any time.

    Declare a default value with a 'state' parameter, and the method to
    fire with a 'callback' parameter.


    :: USAGE ::

        ToggleClass.new( params )



    :: EXAPMLE - Switch between two images ::

        local toggle = require "toggle"

        local myToggle = toggle.new( { on = "path/to/imageOn.png", off = "path/to/imageOff.png", callback = myFunction } )


    :: EXAPMLE - Switch between two images with dynamic resolution, and default the state to off ::

        local toggle = require "toggle"

        local params = {
            on        = "path/to/imageOn.png",
            onWidth   = 100,
            onHeight  = 50,
            off       = "path/to/imageOff.png",
            offWidth  = 100,
            offHeight = 50,
            state     = false,
            callback  = myFunction
        }
        local myToggle = toggle.new( params )

    :: EXAPMLE - Switch between two strings with a custom font, size, and color ::

        local toggle = require "toggle"

        local params = {
            onText       = "On",
            offText      = "Off",
            font         = "Helvetica",
            textSize     = "24",
            textColorOn  = { 255, 0, 0 }
            textColorOff = { 0, 255, 0 }
            callback     = myFunction
        }
        local myToggle = toggle.new( params )

    :: EXAPMLE - Change the VISUAL state manually, this does NOT fire the attached callback ::

        myToggle.setState(true)

    :: EXAPMLE - Change the state manually and fire its attached callback ::

        myToggle.setState(true, true)

]]

local ToggleClass = {}

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
        onImg:setReferencePoint(params.referencePoint or display.TopLeftReferencePoint)
    elseif params.onText then
        params.textColorOn = params.textColorOn or {255,255,255}
        onImg = display.newText(params.onText, 0, 0, params.font, params.textSize)
        onImg:setReferencePoint(params.referencePoint or display.TopLeftReferencePoint)
        onImg:setTextColor(params.textColorOn[1],params.textColorOn[2],params.textColorOn[3])
    else
        onImg = display.newImage(params.on)
        onImg:setReferencePoint(params.referencePoint or display.TopLeftReferencePoint)
    end
    onImg.x, onImg.y = 0, 0

    local offImg
    if params.offWidth and params.offHeight then
        offImg = display.newImageRect(params.off, params.offWidth, params.offHeight)
        offImg:setReferencePoint(params.referencePoint or display.TopLeftReferencePoint)
    elseif params.offText then
        params.textColorOff = params.textColorOff or params.textColorOn
        offImg = display.newText(params.offText, 0, 0, params.font, params.textSize)
        offImg:setReferencePoint(params.referencePoint or display.TopLeftReferencePoint)
        offImg:setTextColor(params.textColorOff[1],params.textColorOff[2],params.textColorOff[3])
    else
        offImg = display.newImage(params.off)
        offImg:setReferencePoint(params.referencePoint or display.TopLeftReferencePoint)
    end
    offImg.x, offImg.y = 0, 0

    if not toggle.state then
        onImg.isVisible  = false
    else
        offImg.isVisible = false
    end

    toggle:insert(onImg)
    toggle:insert(offImg)

    toggle.touch = function(self, event)
        if event.phase == "began" then
            if toggle.state == true then
                toggle.state     = false
                onImg.isVisible  = false
                offImg.isVisible = true
            else
                toggle.state     = true
                onImg.isVisible  = true
                offImg.isVisible = false
            end
            if params.callback then params.callback( toggle ) end
        end
        return false
    end

    if onImg.text then
        local onImgRect = display.newRect(0, 0, onImg.contentWidth*1.25, onImg.contentHeight * 0.6)
        onImgRect:setReferencePoint(params.referencePoint or display.TopLeftReferencePoint)
        onImgRect.x, onImgRect.y = onImg.x, onImg.y
        onImgRect:setFillColor(0,0,0,0)
        local offImgRect = display.newRect(0, 0, offImg.contentWidth*1.25, offImg.contentHeight * 0.6)
        offImgRect:setReferencePoint(params.referencePoint or display.TopLeftReferencePoint)
        offImgRect.x, offImgRect.y = offImg.x, offImg.y
        offImgRect:setFillColor(0,0,0,0)
        local rectGroup = display.newGroup(onImgRect, offImgRect)
        rectGroup:setReferencePoint(params.referencePoint or display.TopLeftReferencePoint)
        rectGroup.y = rectGroup.y + rectGroup.contentHeight * 0.2
        rectGroup:addEventListener("touch", toggle)
        toggle:insert(rectGroup)
        onImgRect, offImgRect, rectGroup = nil, nil, nil
    else
        toggle:addEventListener("touch", toggle)
    end

    toggle.setState = function( bool, fireCallback )
        toggle.state = tostring(bool) ~= "false"
        if toggle.state then
            onImg.isVisible  = true
            offImg.isVisible = false
        else
            onImg.isVisible  = false
            offImg.isVisible = true
        end
        if fireCallback and params.callback then params.callback( toggle ) end
    end

    return toggle
end

return ToggleClass
