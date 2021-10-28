# riverpod_todo_with_changenotifier

A todo app that uses `riverpod` for dependancy injection along with `ChangeNotifier` based state.

# Architecture
The architecture is divided into three high level layers:
 - `controllers` - Hold local state of the app and expose actions to manipulate it
 - `services` - Fetch and send data outside the app, usually used by Controllers
 - `views` - Widgets that bind to Controllers and rebuild whenever they change

# Features
In addition to implementing basic todo app functionality, this demo simulates various real-world scenarios to make things more interesting:
* Persistent settings data, loaded on app start, cleared on logout
* Splash view while app is initializing, replaced when app is fully initialized
* Login/logout functionality with a LoginPage and a mock AuthService
* Demonstrate common use case of a service/repository with user-token dependency
* Creates a high level appController, which can perform top-level tasks like app initialization
* Optimizes rebuilds using the `todoController.completed` and `todoController.active` filters.
