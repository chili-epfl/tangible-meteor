Meteor.startup ->

    #Activities.remove {}

    names = [
        'Levers'
        'TruckLoad'
        'LoadBearing'
        'OrderQuantity'
        'Palletizing'
    ]

    for name in names
        if Activities.find({name:name}).count() is 0
            Activities.insert {name: name}
