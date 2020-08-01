---
toc: ~admin~ Managing the Game
summary: Managing Visions.
---
# Managing Visions

> **Permission Required:** These commands require the Admin role.

## Viewing Visions

Admin can view the visions of other characters.

`visions <char name>` - View someone's vision list. For subsequent pages, use `visions2 <char name>`, etc.
`visions/view <char name>=<vision id number>` - View a specific vision. You can get the id number by viewing their `visions` list.

## Sending, Updating, and Deleting Visions Individually

If you have the appropriate permissions, you can send, update, and delete visions individually.

`visions/send <character name>=<vision title>/<vision text>` -  Send a vision to someone.
`visions/update <character name>=<vision id number>/<vision desc>` - Update a vision. You can get the id number by viewing their `visions` list.
`visions/rm <character name>=<vision id number>` - Remove a vision. You can get the id number by viewing their `visions` list.

There is an edge case where a player may not be able to clear a vision notification, if you delete the vision before they can read it.
In this instance, have the player go to the website and clear the notification from there.

## Sending Visions to a Category

You can also send visions to a group of people who share a category. The vision will be sent to all characters with that specific category set.

`visions/setcat <name>=<vision category name>` - Set a category on someone (e.g. `visions/setcat Ariel=princesses`)
`visions/sendcat <vision category name>=<vision title>/<vision text>` - Send a vision to the category.