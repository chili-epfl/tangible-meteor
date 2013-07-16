@myTinker ?= {}
myTinker.utils ?= {}

# Returns an event map that handles the "escape" and "return" keys and
# "blur" events on a text input (given by selector) and interprets them
# as "ok" or "cancel".
myTinker.utils.okCancelEvents = (selector, callbacks) ->
    ok = callbacks.ok or -> null
    cancel = callbacks.cancel or -> null

    events = {}
    events['keyup '+selector+', keydown '+selector+', focusout '+selector] =
        (evt) ->
            if (evt.type is "keydown") and (evt.which is 27)
                # escape = cancel
                cancel.call(this, evt)
            else if (evt.type is "keyup") and
                (evt.which is 13) or (evt.type is "focusout")
                     # blur/return/enter = ok/submit if non-empty
                    value = String(evt.target.value || "")
                    if value then ok.call(this, value, evt)
                    else cancel.call(this, evt)
    return events

myTinker.utils.generateUUID = ->
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) ->
        r = Math.random()*16|0
        v = if c is 'x' then r else (r&0x3|0x8)
        return v.toString(16)
    )

myTinker.utils.activateInput = (input) ->
    input.focus()
    input.select()
