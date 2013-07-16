log = (txt) -> console.log 'levers: '+txt

utils = myTinker.utils
db = myTinker.customActivities

Template.customLevers.lang = (e) -> Session.get 'lang'

# When editing a pallet mass, ID of the pallet
Session.setDefault('editing_mass', null)
Session.setDefault('editing_pos', null)
Session.setDefault('editing_tangibleMass', null)
Session.setDefault('editing_tangibleAmount', null)

# CUSTOM LEVERS
Template.customLevers.loading = -> db.loading()

createLever = (number) ->
    lever = {
        number:number
        fixedPallets:[]
    }
    lever

Template.customLevers.levers = ->
    data = db.getData()
    if data?
        if not data.levers?
            levers = []
            for i in [0...3] then levers.push createLever(i)
            db.updateField 'levers', levers
        return data.levers
    else return {}

Template.customLevers.fixedPallets = ->
    # add an index to fixedPallets to simplify removal
    for p,index in this.fixedPallets
        p.index = index
    this.fixedPallets

Template.customLevers.description = -> db.getData()?.description

Template.customLevers.leverNumber = -> this.number + 1

Template.customLevers.tangiblePallets = ->
    data = db.getData()
    if data?
        if not data.tangiblePallets?
            pallets = []
            for i in [0...15] then pallets.push {number:i,mass:100}
            db.updateField 'tangiblePallets', pallets
        return data.tangiblePallets
    else return {}
            
Template.customLevers.amountTangiblePallets = ->
    db.getData()?.tangiblePallets?.length or 0

Template.customLevers.events {
    'click .addRow': (e, template) ->
        e.preventDefault()
        data = db.getData()
        if data?
            palletData = {
                id: myTinker.utils.generateUUID()
                lever: this.number
                distance: 1000
                mass: 250
                side: -1
            }
            fieldName = 'levers.'+this.number+'.fixedPallets'
            db.push fieldName, palletData
    'click .generatePDF': (e) ->
        e.preventDefault()
        generatePDF()
    'blur #leversDescriptionInput': (e) ->
        e.preventDefault()
        db.updateField 'description', e.currentTarget.value
}

generatePDF = ->
    data = db.getData()
    return if not data?

    txt = 'act="levers";'
    txt += 'f=('
    n=0
    for lever in data.levers
        for p in lever.fixedPallets
            if n isnt 0 then txt += ','
            txt += '['+p.lever+','+p.mass+','+p.distance+','+p.side+']'
            n++
    txt += ');'
    txt += 't=['
    for p,i in data.tangiblePallets
        if i isnt 0 then txt += ','
        txt += p.mass
    txt += '];'

    pdf = myTinker.pdfCreator()
    pdf.generate {
        dmText: txt
        title: 'Levers - '+data.name
        description:data.description
        username: Meteor.user()?.username
        filename: 'levers'
    }

# FIXED PALLET ROW
Template.fixedPalletRow.isLeft = -> this.side < 0

Template.fixedPalletRow.editingMass = ->
    return if Session.equals('editing_mass', this.index) then true else false

Template.fixedPalletRow.editingPos = ->
    return if Session.equals('editing_pos', this.index) then true else false

updateFixedPalletField = (row, field, value) ->
    fieldName = 'levers.'+row.lever+'.fixedPallets.'+row.index+'.'+field
    db.updateField fieldName, value

Template.fixedPalletRow.events {
    'click .removeRow': (e) ->
        e.preventDefault()
        fieldName = 'levers.'+this.lever+'.fixedPallets'
        db.pull fieldName, {id:this.id}
    'click .editable_mass': (e, tmpl) ->
        e.preventDefault()
        Session.set 'editing_mass', this.index
        Deps.flush()
        utils.activateInput(tmpl.find("#mass-input"))
    'click .editable_pos': (e, tmpl) ->
        e.preventDefault()
        Session.set 'editing_pos', this.index
        Deps.flush()
        utils.activateInput(tmpl.find("#pos-input"))
    'click td.side': (e) ->
        e.preventDefault()
        value = if this.side < 0 then 1 else -1
        updateFixedPalletField this, 'side', value
}

Template.fixedPalletRow.events utils.okCancelEvents('#mass-input', {
    ok: (value) ->
        updateFixedPalletField this, 'mass', value
        Session.set 'editing_mass', null
    cancel: ->
        Session.set 'editing_mass', null
})

Template.fixedPalletRow.events utils.okCancelEvents('#pos-input', {
    ok: (value) ->
        updateFixedPalletField this, 'distance', value
        Session.set 'editing_pos', null
    cancel: ->
        Session.set 'editing_pos', null
})

# TABGIBLE PALLET ROW
Template.tangiblePalletRow.editingMass = ->
    return if Session.equals('editing_tangibleMass', this.number) then true else false

Template.tangiblePalletRow.events {
    'click .editable_mass': (e, tmpl) ->
        e.preventDefault()
        Session.set 'editing_tangibleMass', this.number
        Deps.flush()
        utils.activateInput(tmpl.find("#mass-input"))
}

Template.tangiblePalletRow.events utils.okCancelEvents('#mass-input', {
    ok: (value) ->
        data = db.getData()
        if data?
            fieldName = 'tangiblePallets.'+this.number+'.mass'
            db.updateField fieldName, value
        Session.set 'editing_tangibleMass', null
    cancel: ->
        Session.set 'editing_tangibleMass', null
})
