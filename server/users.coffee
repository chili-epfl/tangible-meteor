Meteor.startup ->
    removeAllUsers = -> Meteor.users.remove {}
    #removeAllUsers()
    
    if Meteor.users.find({username:'abc'}).count() is 0
        Accounts.createUser {
            username: 'abc'
            email: 'abc@abc.com'
            password: 'hello'
        }

    if Meteor.users.find({username:'guillaume'}).count() is 0
        Accounts.createUser {
            username: 'guillaume'
            email: 'guillaume.zufferey@epfl.ch'
            password: 'zufferey'
        }
    
    Meteor.users.update({username: 'guillaume'}, {$set: {admin: true}})
