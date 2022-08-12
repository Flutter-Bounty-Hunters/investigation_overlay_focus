# Overlay Focus Investigation

This investigation is based on issues we've run into with popover toolbars in `super_editor`.

Consider a document editor. When the user selects some text, a toolbar pops up. That toolbar should
only appear when the user has selected some text, which also implies that the document editor has
focus.

The problem is that it's not clear how a developer is supposed to handle shared focus in this
situation. There are a few configurations that one might use to display such a toolbar. Each
situation creates different issues.

## Toolbar over the content
First, one might try to display the popover toolbar in a `Stack` on top of the document editor. This
widget position may, or may not be ideal, based on the overall layout of the app.

To share focus between the document editor and the toolbar, developers must intervene with a 
`FocusScope` above a common ancestor for both the toolbar and the document editor. This
intervention is tedious from a `super_editor` documentation standpoint, but it should be achievable.
Given that the developer added a `Stack` to hold the document editor and the toolbar, the developer
can add the `FocusScope` widget directly above the `Stack` widget. At this point, the user can tap
toolbar buttons without stealing focus from the document editor.

However, it's unclear how to deal with dropdown menus in the toolbar. Dropdown menus appear in their
own route, which seems to always steal focus. How can we open dropdown menus without taking focus
away from the document editor?

Lastly, this approach to toolbar positioning is not ideal because the bounds of the document editor
may not be the bounds that a developer wants for the toolbar. Popovers typically appear in new
routes or overlays so that the popover has complete control over screen placement.

## Toolbar in the global Overlay
Placing the toolbar in the global `Overlay` is probably the default approach that a developer would
take for a popover toolbar.

Placing the toolbar in the global `Overlay` allows the user to tap toolbar buttons without losing
focus.

However, when the user taps a dropdown menu, the dropdown menu route steals focus, closing the
toolbar.

Furthermore, even if we're able to open the dropdown menus, the menus appear in a new route, which
sits beneath the global `Overlay`. As a result, the toolbar appears on top of the dropdown menus.

## Toolbar in a custom Overlay
To deal with the problem of the global `Overlay` sitting on top of dropdown menus, we can use our
own `Overlay` widget, instead.

Asking developers to add their own `Overlay` widget on top of their `Scaffold` is an unfortunate
request. Developers aren't used to doing this, and using the global `Overlay` seems like it should
be a supported use-case. Nonetheless, it's technically possible to add our own `Overlay`, which
sits beneath the `Navigator`, and therefore displays dropdown menus on top of the popover toolbar.

However, we're still stuck with the problem that dropdown menu routes steal focus.