# haskell-pointfree package

This extremely simple utility calls pointfree and pointful
with current selection and shows their output, allowing you to
preview, choose and then replace current selection with said
output (or not)

This package includes pointfree and pointful executables compiled to JavaScript with ghcjs compiler. These are used, when `pointfreePath` and `pointfulPath` are `pointfree.js` and `pointful.js` respectively (this is the default). If you want to use proper binaries, change package settings. If binaries are in `PATH` you may only need to remove `.js` extension.

Default shortcuts:

* ctrl+alt+shift+f: toggle preview panel

![Screenshot](https://raw.githubusercontent.com/lierdakil/atom-haskell-pointfree/master/screen.png)
