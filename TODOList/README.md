
Mobile App Engineer Challenge: iOS Development
(TODO List Application Challenge)
by Jeffrey Wisgo


1) Instructions on how to set up and run your application locally

Ths application is run much like any other iOS based app:
- Pull down the source from Github
- Install XCode, configure an Apple ID in Preferences->Accounts
- Open the TODOList.xcodeproj project in XCode (double click on it in Finder is sufficient)
- Choose either a simulator or physical target in the dropdown in the top center (to the right of the app name)
  - If physical device, plug in the device via USB cable (to any other configuration as needed such as adding the device to the account)
- Run the app via Product->Run (⌘ R)

Intructions to run the app via TestFlight:
- Ask Jeff to add you to the internal testers whitelist (email to locksleyu@gmail.com)
- Download TestFlight app on your iOS device from the app store. 
- Login to TestFlight with the email you asked to be added.
- You should receive an email "Jeffrey Wisgo has invited you to test TODO List App!"
- Click on that email on your iOS device, it will direct you to the TestFlight app.
- You should now see the app in the TestFlight app, click on it to install, then run it as normal.

2) A brief overview of the app architecture

The app is divided up into 4 views, with a file for each view:
- HomeView: The initial view that is shown ("home page") that contains information about the app. It has a Start button to jump to the main page
- MainView: The main view of the app that shows all of the TODO items and has a filter picker for showing all tasks, completed tasks, or active tasks. 
- EditView: The view used to edit an item, triggered by a click to the text of the item (also available via left swipe)
- AddView: The view used to add a new item. Triggered by the MainView via the "Add task" option.

There are also two other files of note:

- TodoList.swift: contains TodoItem, the struct that represents a single Todo Item, and TodoItemsLogic, a set of logic for acting upon the Todo items
- Configuration: contains the URL for which data is initially fetched. Other global constants could be added to this in the future.

3) Guidelines on how to run and validate tests

- Select Product->Test (⌘ U) to run the entire suite of tests on the simulator
- To run a specific test, click on the diamond next to the test function name (all tests begin with test...())
  - unit tests: TODOListTests/TODOListTests.swift
  - UI tests: TODOListUITests/TODOListUITests.swift
- A list of test cases should appear in the top left (if it doesn't, you can open the Test Navigator by clicking the check-in-a-diamond icon in the top left)
- Passed tests are represented by a green check, and failed ones by a red X. A spinner will be shown for tests that are still processing.


4) Other notes:

This app is intended to demonstrate overall coding ability, and is missing some things that should be done before actually releasing on the App store. Here is a list of some of those things:

- Add persistence to the data so it doesn't go away when the app is restarted.
  (I considered adding basic persistence, but it was not obvious how to integrate the URL-fetched data with modified data)
- Internationalization of strings ("Add task" etc.) into common languages
- Link to the app's webpage.
- User assistance (in the form of text, screenshots, and short videos) could be added to show how to use the app initially.
- Some sound effects (like when deleting or adding an item) to improve usability.
- The UX design could be improved to be more pleasing (Also, a separate design should be considered for iPhone vs. iPad)
- Optional: Analytics to show how the users are using the app (could use something like Mixpanel). This should of course have a clear opt-out.

Note: as there are many existing TODO apps in the Apple app store, in order to make this app competitive there is a bunch of functionality that should be added, including creative functionality that other apps don't have.

