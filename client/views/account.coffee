Template.account.lang = (e) -> Session.get 'lang'

subscription = Meteor.subscribe 'userData'

Session.set 'changePassword:alert', null
Template.account.changePasswordAlert = ->
    data = Session.get 'changePassword:alert'

Template.account.isAdmin = ->
    Meteor.user()?.admin

Template.account.events {
    'click #changePasswordButton': (e) ->
        e.preventDefault()
        current = $('#oldPassword').val()
        newPassword = $('#newPassword').val()
        Accounts.changePassword current, newPassword, (err) ->
            if err?
                Session.set 'changePassword:alert', {
                    type: 'error'
                    msg: ''+err
                }
            else
                Session.set 'changePassword:alert', {
                    type: 'success'
                    msg: 'Password changed successfully.'
                }

}
