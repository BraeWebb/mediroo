[![Build Status](https://jenkins.braewebb.com/job/mediroo/badge/icon)](https://jenkins.braewebb.com/job/mediroo/)
# MediRoo

MediRoo is a digital pillbox and medication reminder application designed to simplify the process of remembering when and how to take medication for patients. Team tilde has found that around 50% of the time, medication is not being taken as prescribed. They aim to combat this by creating a platform where users receive notifications and information specifically tailored to their situation and medical needs, without disrupting their daily routines.

### Tilde ~

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

####**Install Intellij IDEA**

- [Intellij IDEA Community](https://www.jetbrains.com/idea/download), 2017 version or later
- [Intellij IDEA Ultimate](https://www.jetbrains.com/idea/download), 2017 version or later

Alternatively, you can use Android Studio:

- [Android Studio](https://developer.android.com/studio/), version 3.0+


####**Install the Flutter and Dart Plugins**
- The `Flutter` plugin powers the Flutter developer workflow (running, debugging, hot reload, etc.)
- The `Dart` plugin is for code analysis (code compilation, validation) 

To install the plugins:

1. Start IntelliJ IDEA.
2. Open plugin preferences (`Preferences > Plugins` on macOS, `File > Settings > Plugins` on Windows & Linux).
3. Select `Browse repositories…`, select the Flutter plug-in and click `install`.
4. Click `Yes` when prompted to install the Dart plugin.
5. Click `Restart` when prompted.

The same steps can be followed for **Android Studio**.

### Creating project from existing source code

Once IntelliJ is downloaded and installed, the project can be cloned using this command:
`git clone https://source.eait.uq.edu.au/git/deco3801-tilde`

To create a new Flutter project which existing Flutter source code files:

1. In the IDE, click **`Create New Project`** from the 'Welcome' window or **`File > New > Project...`** from the main IDE window.
    - **NOTE**: Do *not* use the **`New > Project from existing sources..`** option for Flutter projects.
2.  Select **`Flutter`** in the menu, and click **`Next`**.
3. Under **`Project location`** enter, or browse to, the directory under which the project is cloned
4. Click **`Finish`**.


## Running the tests

To run the tests the following command can be used:

`flutter test`,

Run the command inside the project direction


## Deployment

To deploy to Android, the following command can be used in the project directory

`flutter build apk`

The resulting `.apk` can then be deployed to the Google Play Store.


To deploy to iOS, the following command can be used 

`flutter build ios`

The result `.app` can then be deployed to the Apple Store.

## Built With

* [Flutter](https://flutter.io/) - Mobile development SDK
* [Jenkins](https://jenkins.io/) - Continous Integration
 

## Authors

###tilde ~

* **Brae Webb**
* **Henry O'Brien**
* **Emily Bennet**
* **Abhishek Jagtap**
* **Lius Woodrow**
* **Nick Garner**
* **Andrew Chan**

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* 
