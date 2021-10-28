# riverpod_todo_change_notifier

A simple ChangeNotifier based app skeleton using riverpod.

Architecture
The architecture is divided into three high level layers:
 - Controllers - Hold local state of the app and expose actions to manipulate it.
 - Services - Fetch and send data outside the app, usually used by Controllers
 - Views - Widgets that bind to Controllers and rebuild whenever they change

Features
In addition to implementing basic To-do functionality, this app simulate various real-world scenarios to add architectural complexity.
* Settings - Persistent settings data, cleared on logout.
* SplashScreen - Splash view while app is initializing, cleared when app is fully initialized.
* LoginPage - login/logout functionality with a mock AuthService
* Demonstrate a service with userToken dependency
* AppController - Creates a top level app controller, which can capture global business logic.