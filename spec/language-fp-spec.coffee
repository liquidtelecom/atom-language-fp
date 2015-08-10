LangFp = require '../lib/language-fp'

# Use the command `window:run-package-specs` (ctrl-alt-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "language-fp", ->
    [activationPromise, editor] = []

    beforeEach ->
        atom.workspaceView = atom.views.getView(atom.workspace)

        waitsForPromise ->
            atom.workspace.open().then (ed) ->
                editor = ed

        activationPromise = atom.packages.activatePackage('language-fp')


    trigger = (t, cb) ->
        atom.commands.dispatch atom.workspaceView, t
        waitsForPromise -> activationPromise
        runs ->
            cb()

    describe "language-fp:escape", ->
        it "still works even if the editor is not set", ->
            atom.workspace.destroyActivePaneItem()
            trigger 'language-fp:escape', ->
                expect(atom.views.getView(atom.workspace.getActiveTextEditor())).not.toBeDefined()

        it "does nothing when nothing is selected", ->
            editor.setText "text with spaces\nanother line with special chars%=!+"
            trigger 'language-fp:escape', ->
                expect(editor.getText()).
                    toBe "text with spaces\nanother line with special chars%=!+"

        it "encodes the selected text", ->
            editor.setText "<request><so>service order number"
            editor.setSelectedBufferRange([[0,0], [0,10]])
            trigger "language-fp:escape", ->
                expect(editor.getText()).
                    toBe "\\074request\\076\\074so>service order number"

    describe "language-fp:unescape", ->
        it "still works even if the editor is not set", ->
            atom.workspace.destroyActivePaneItem()
            trigger 'language-fp:unescape', ->
                expect(atom.views.getView(atom.workspace.getActiveTextEditor())).not.toBeDefined()

        it "does nothing when nothing is selected", ->
            editor.setText "text with spaces\nanother line with special chars%=!+"
            trigger 'language-fp:unescape', ->
                expect(editor.getText()).
                    toBe "text with spaces\nanother line with special chars%=!+"

        it "encodes the selected text", ->
            editor.setText "\\074request\\076\\074so>service order number"
            editor.setSelectedBufferRange([[0,0], [0,23]])
            trigger "language-fp:unescape", ->
                expect(editor.getText()).
                    toBe "<request><so>service order number"
