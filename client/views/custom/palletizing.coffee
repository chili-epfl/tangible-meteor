log = (txt) -> console.log 'palletizing: '+txt

utils = myTinker.utils
db = myTinker.customActivities

# default session values
Session.setDefault 'editing_height', null
Session.setDefault 'editing_boxWidth', null
Session.setDefault 'editing_boxHeight', null
Session.setDefault 'editing_boxMass', null

# palletizing
Template.customPalletizing.lang = -> Session.get 'lang'
Template.customPalletizing.loading = -> db.loading()

# palletizing height
Template.palletizingHeight.lang = -> Session.get 'lang'

Template.palletizingHeight.height = -> db.getOrAddField 'height', 800
Template.palletizingHeight.editingHeight = -> Session.get 'editing_height'

Template.palletizingHeight.events utils.okCancelEvents('#height-input', {
    ok: (value) ->
        db.updateField 'height', value
        Session.set 'editing_height', null
    cancel: -> Session.set 'editing_height', null
})

Template.palletizingHeight.events {
    'click .editableHeight': (e,tmpl) ->
        e.preventDefault()
        Session.set 'editing_height', true
        Deps.flush()
        utils.activateInput(tmpl.find('#height-input'))
}

# palletizing boxes
Template.palletizingBoxes.lang = -> Session.get 'lang'

Template.palletizingBoxes.boxes = ->
    boxes = db.getOrAddField 'boxes', []
    if boxes?
        b.index = index for b,index in boxes
    boxes

Template.palletizingBoxes.events {
    'click .addBox': (e,tmpl) ->
        e.preventDefault()
        box =
            id: myTinker.utils.generateUUID()
            width: 400
            height: 400
            mass: 10
        db.push 'boxes', box
}

# palletizing box
Template.palletizingBox.lang = -> Session.get 'lang'

Template.palletizingBox.editingBoxWidth = -> Session.get('editing_boxWidth') is this.index
Template.palletizingBox.editingBoxHeight = -> Session.get('editing_boxHeight') is this.index
Template.palletizingBox.editingBoxMass = -> Session.get('editing_boxMass') is this.index

Template.palletizingBox.events utils.okCancelEvents('#width-input', {
    ok: (value) ->
        db.updateField 'boxes.'+this.index+'.width', value
        Session.set 'editing_boxWidth', null
    cancel: -> Session.set 'editing_boxWidth', null
})

Template.palletizingBox.events utils.okCancelEvents('#height-input', {
    ok: (value) ->
        db.updateField 'boxes.'+this.index+'.height', value
        Session.set 'editing_boxHeight', null
    cancel: -> Session.set 'editing_boxHeight', null
})

Template.palletizingBox.events utils.okCancelEvents('#mass-input', {
    ok: (value) ->
        db.updateField 'boxes.'+this.index+'.mass', value
        Session.set 'editing_boxMass', null
    cancel: -> Session.set 'editing_boxMass', null
})

Template.palletizingBox.events {
    'click .removeBox': (e,tmpl) ->
        e.preventDefault()
        db.pull 'boxes', {id:this.id}
    'click .editableBoxWidth': (e,tmpl) ->
        e.preventDefault()
        Session.set 'editing_boxWidth', this.index
        Deps.flush()
        utils.activateInput(tmpl.find('#width-input'))
    'click .editableBoxHeight': (e,tmpl) ->
        e.preventDefault()
        Session.set 'editing_boxHeight', this.index
        Deps.flush()
        utils.activateInput(tmpl.find('#height-input'))
    'click .editableBoxMass': (e,tmpl) ->
        e.preventDefault()
        Session.set 'editing_boxMass', this.index
        Deps.flush()
        utils.activateInput(tmpl.find('#mass-input'))
}

Template.palletizingDone.lang = (e) -> Session.get 'lang'

Template.palletizingDone.events {
    'click .generatePDF': (e) ->
        e.preventDefault()
        generatePDF()
}

generatePDF = ->
    data = db.getData()
    return if not data?

    txt = 'act="palletizing";'
    txt += 'height='+data.height+';'
    txt += 'boxes=['
    for b,i in data.boxes
        if i isnt 0 then txt += ','
        txt += '['+b.width+','+b.height+','+b.mass+']'
    txt += '];'

    lang = Session.get 'lang'
    pdf = myTinker.pdfCreator()
    pdf.generate {
        dmText:txt
        title:lang['Palletizing']
        description:data.description
        username: Meteor.user()?.username
        filename:lang['Palletizing']
    }
