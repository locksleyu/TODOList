
Mobile App Engineer Challenge: iOS Development

TODO List Application Challenge


1) Instructions on how to set up and run your application locally

Ths application is run much like any other iOS based app:
- Pull down the source from Github
- Install XCode, configure an Apple ID in Preferences->Accounts
- Open the TODOList.xcodeproj project in XCode (double click on it in Finder is sufficient)
- Choose either a simulator or physical target in the dropdown in the top center (to the right of the app name)
  - If physical device, plug in the device via USB cable (to any other configuration as needed such as adding the device to the account)
- Run the app via Product->Run (⌘ R)


2) A brief overview of the app architecture

The app is divided up into 4 views, with a file for each view:
- HomeView: The initial view that is shown ("home page") that contains information about the app. It has a Start button to jump to the main page
- MainView: The main view of the app that shows all of the TODO items and has a filter picker for showing all tasks, completed tasks, or active tasks. 
- EditView: The view used to edit an item. Trigged by the MainView via a left swpie and choosing the "edit" item
- AddView: The view used to add a new item. Triggered by the MainView via the "Add item" option.

There are also two other files of note:

- TodoList.swift: contains TodoItem, the struct that represents a single Todo Item, and TodoItemsLogic, a set of logic for acting upon the Todo items
- Configuration: contains the URL for which data is initially fetched. Other global constants could be added to this in the future.
 
3) Guidelines on how to run and validate tests

TODO

