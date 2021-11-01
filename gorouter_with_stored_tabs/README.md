# gorouter_with_stored_tabs

An example of implementing the classic "Stateful Tabs" or "Nested Tabs" style navigation with GoRouter.
* Pages within each tab should remember their state
* When changing tabs, the tabs should remember what page they were showing last
* When pressing a selected tab, it should pop all routes and return to the root tab

Classically this is achieved by having multiple child `Navigator`s that internally hold their own state by being rendered offstage.

This takes a different approach:
* Uses the `PageStorage` API to allow each route to restore state and remember scroll positions etc.
* Uses the users location history to determine which view we should show when a tab is pressed.

Here is a video showing a basic walkthrough:
http://screens.gskinner.com/shawn/FwRQ3vssXk.mp4
