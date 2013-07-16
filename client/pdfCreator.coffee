log = (txt) -> console.log 'pdfCreator: '+txt
pdfCreator = ->
    that = {}

    doc = null

    generateDm = (text) ->
        def = $.Deferred()
        dmOptions = {
            data: text
            path: 'tags/'
        }
        Meteor.call 'generateDm', dmOptions, (error, res) ->
            if error? then def.rejectWith error
            else
                if res.success then def.resolve res.path
                else def.rejectWith 'Failed to create tag.'
        def.promise()

    loadImage = (path) ->
        def = $.Deferred()
        img = new Image()
        img.src = path
        img.onload = -> def.resolve(img)
        def.promise()

    imgToDataURL = (img) ->
        canvas = document.createElement 'canvas'
        canvas.width = img.width
        canvas.height = img.height
        ctx = canvas.getContext '2d'
        ctx.drawImage img,0,0
        imgData = canvas.toDataURL('image/jpeg')
        imgData

    addDm = (text) ->
        def = $.Deferred()
        dm = generateDm(text)
            .then((dmPath) -> loadImage(dmPath))
            .then((img) ->
                data = imgToDataURL img
                doc.addImage(data, 'JPEG', 130, 30, 150, 150)
            )
        dm.done -> def.resolve()

        def.promise()

    addTag = (tagPath) ->
        def = $.Deferred()
        tag = loadImage(tagPath)
            .then((img) ->
                data = imgToDataURL img
                doc.addImage(data, 'JPEG', 220, 20, 54, 9)
            )
        tag.done -> def.resolve()
        def.promise()

    addTitle = (title) ->
        doc.setFont "helvetica"
        doc.setFontType "bold"
        doc.setFontSize 24
        doc.text 20, 25, title
        null

    addDescription = (description) ->
        doc.setFont "helvetica"
        doc.setFontType "normal"
        doc.setFontSize 12
        lines = doc.splitTextToSize description, 100
        doc.text 20, 40, lines
        null

    # options:
    # - dmText (string)
    # - title (string)
    # - username (string)
    # - description (string)
    generate = (options) ->
        dmText = options.dmText
        title = options.title ? 'No title'
        username = options.username ? 'No username'
        description = options.description ? 'No description'
        filename = options.filename ? 'myTinker'

        if not dmText?
            log 'No text given for datamatrix.'
            return

        doc = new jsPDF('landscape')
        doc.setProperties {
            title: title
            author: username+' @ myTinker'
        }

        addTitle title
        addDescription description

        dm = addDm options.dmText
        tag = addTag 'tag/tag_0449.jpg'

        $.when(dm, tag)
            .then(->
                doc.save filename+'.pdf'
            )

    that.generate = generate

    that

@myTinker ?= {}
myTinker.pdfCreator = pdfCreator
