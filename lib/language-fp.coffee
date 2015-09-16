{CompositeDisposable} = require 'atom'

module.exports =
    subscriptions: null

    activate: ->
        @subscriptions = new CompositeDisposable
        @subscriptions.add atom.commands.add "atom-workspace", "language-fp:escape": => @transfromSel @escape
        @subscriptions.add atom.commands.add "atom-workspace", "language-fp:unescape": => @transfromSel @unescape

    deactivate: ->
        @subscriptions.dispose()

    transfromSel: (t) ->
        # This assumes the active pane item is an editor
        editor = atom.workspace.getActiveTextEditor()
        if (editor?)
            selections = editor.getSelections()
            sel.insertText(t(sel.getText()), { "select": true}) for sel in selections

    escape: (text) ->
        text.replace(/</g, '\\074').replace(/>/g, '\\076').replace(/,/g, '\\054')

    unescape: (text) ->
        text.replace(/\\074/g, '<').replace(/\\076/g, '>').replace(/\\054/g, ',')
