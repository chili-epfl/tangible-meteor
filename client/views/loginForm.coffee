Template.loginForm.events = {
    'click #logoutLink': (event) ->
        event.preventDefault()
        if Meteor.userId()? then Meteor.logout()
    'click #loginButton': (event) ->
        event.preventDefault()
        usr = $('#username').val()
        password = $('#password').val()
        Meteor.loginWithPassword usr, password
}
