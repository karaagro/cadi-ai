# CADI AI - Cashew Disease Identification with Artificial Intelligence

This is the main repository for CADI AI - a desktop application for identifying disease, abiotic stress and pest infestations in cashew plants.

## Table of Contents
---
    1. Introduction
    2. Problem Statement
    3. Project Description
        a) Data Collection
        b) Image Pre-processing
        c) Annotation
        d) Model Training
        e) Software Development 
    4. Contributing
        a) Technologies & Tools
        b) Workflow & Branch Rules
        c) Issues
        d) Support
    5. Building the Software
        a) Building for Windows
        b) Building for MacOs X
        c) Building for Linux
    6. Assumptions?
    7. Advantages and Use Cases 
    8. Resources and Links
    9. Conclusion


## Introduction
---

CADI AI - *Cashew Disease Identification with Artificial Intelligence* - is a demo-application that uses the technology Artificial Intelligence (AI). It looks at drone images of cashew trees and informs the user whether the Cashew tree suffers from:
 - pest infection, 
 - disease or 
 - abiotic stress. 

[KaraAgro AI](https://www.karaagro.com/) developed CADI AI for the initiatives “Market-Oriented Value Chains for Jobs & Growth in the ECOWAS Region (MOVE/Comcashew)” and [FAIR Forward - Artificial Intelligence for All](https://toolkit-digitalisierung.de/en/fair-forward/). Both initiatives are implemented by the Deutsche Gesellschaft für Internationale Zusammenarbeit (GIZ) on behalf of the German Federal Ministry for Economic Cooperation and Development (BMZ). 
    
CADI AI shall support farmers as an early warning system to quickly identify problems in their cashew farms and to keep their crops healthier and more yielding.
Please note that the application will not tell you which particular disease or pest a cashew tree suffers from or how to treat it. 

As with any application that uses AI: 
Please treat the results with caution because this system can produce wrong results. It is recommended to verify the diagnoses, for example, by seeking advice from a trained agronomist or extension officer before acting upon the diagnoses of the application. 

## Problem Statement
---
[insert problem statement]

## Project Description
---
* ### Data Collection
[insert data collection @]
* ### Image Pre-processing
* ### Annotation
* ### Model Training
* ### Software Development
  `CADI AI` is a local flutter desktop application. It may require internet connection intermittently to refresh cached data. Otherwise, it is mostly local.

  To keep it local, the application spins up a local python server using the `Flask` framework through which scans are then made by making local `http` requests.

  The python server code can be found in the `app.py` file. The server accepts POST requests with a file path as parameter. The `file_path` tells where selected images for scans are located on the user's device, and passes the same to the model for inferencing.

  It is our understanding that not every user of the application would have python installed on their device; especially for Windows users, the Operating System does not come bundled with python. 

  For this reason, the application features a **Setup** page where all required missing software is installed before the application starts.

      The Setup stage can sometimes take a good long amount of time. We implore all users to be patient while that step is in progress.

  We are constantly looking into ways to improve this process in the application or to remove it entirely. Once we find a better solution that works, we will swap it out.

  The folder structure for the project is as below:

    ```
      ├── assets
      ├── lib
      │   ├── adapters
      |   ├── controllers
      |   ├── entities
      |   ├── generated
      |   ├── layouts
      |   ├── pages
      |   ├── services
      |   ├── themes
      |   ├── utils
      |   ├── widgets
      ├── macos
      ├── test
      ├── windows
      ├── app.py
      ├── pubspec.yaml
    ```

  - The `asset` directory contains images and icons that are used in the application. The application icon is also located in this directory.

  - The `lib` directory contains most of the code written in the `dart` language.
  
  - The `lib/pages` directory contains dart files that define the widget look-and-feel of each of the pages in the application.

  - The `lib/layouts` directory contains dart files that define the structure of the major widgets of the application. For example, the `HomeLayoutState.dart` files defines the various sections i.e `Side Panel` and an `expanded area` for content widgets.

  - `lib/services` holds service files that define API for communicating with the trained model, for instance, and saving scan results and images to `Isar` database

  - `lib/utils` contains helper functions that are re-used across several other widgets. All extractable functions that can be separated so as to be re-used or simplified can be found in this directory

  - `lib/widgets` is where custom and re-usable widgets are defined.

  - `app.py` file is the python script that spins up the local python flask server.

  - `macos` and `windows` directories contain configuration files for MacOs and Windows respectively. Configurations like application icon and build targets when changed in Xcode are written directly to the `Podfile` in the `macos` directory.

  **NB**:It is important to note that due to the  size of the trained cashew model as described in the `Model Training` section above, the total size of the project files exceeded the Github repository  file size limit.

  As a result, the model was not included in the repository. The model is rather available publicly on Hugging face. The link to the Hugging face repository can be found below in the `Resources & Links` section.

    It is required that the model file be downloaded and added to the project on your local device before tests scan be run. If you run `flutter run` without the model file available in the project directory, you will not be able to run scans.

* ### Software Release and Deployment
  CADI AI builds and releases are available on the repository.

  The application is built into a Windows msi package and uploaded with a tag to the repository. Builds for MacOs are also available. There is currently no support Linux devices and no future plans to support them.

  At the right side panel on the CADI AI repository, releases with tags can be found and can be downloaded and installed on users' devices.

  Semantic version ([Semver](https://semver.org/)) is used to name each build. Latest builds are better and more robust and should be preferred over older builds.

## Contributing
---
CADI AI was started as a private project with the goal of becoming open sourced. Now that it has been made available to the public, contributions are invited to fix issues and improve the application.

There are some rules, though, that we believe must be observed in contributing to the application. Find more information on these rules and related ones below.

* ### Technologies & Tools
  CADI AI is a flutter-based local desktop application. The following technologies and tools are used in the development of the applicatioin. These technologies are also pre-requisite in order to contribute to the improvement of the application.
  1. Flutter
  2. Dart
  3. Isar Database
  4. GetX Controller
  3. Python 3.0 and later
  4. Python Libraries(
    Flask,
    ultralytics,
    etc...
  )
  5. Visual Studio Code (Recommended IDE)
  6. Xcode (Required only for MacOs X)
* ### Workflow & Branch Rules
  Semantic branch names and semantic commit messages are the format to be used for branches and commits to this repository.
  Anything else deviated from these standards would be rejected.

  *The branching workflow also follows the rules below:*

  - **master/main**:
  The master branch should always have stable code that can be picked for release at any time. Pull requests (PR) to the master branch only come from the QA branch.

  - **QA/test/staging (Quality Assurance)**:
  The QA branch is where code that has gone through  review from contributors can be tested. Then merged to main after testing.

  - **Dev**:
  The dev branch accepts pull requests (PR) for contributions. Code reviews are done against PR’s to the Dev branch

* ### Issues
  [insert issues standards @fuachie]

* ### Support
  The team at KaraAgro AI will keep supporting the software indefinitely. We will be fixing issues,  making improvements and adding new features as and when they are needed.

## Building the Software
---
Currently, CADI AI build process for *Windows* has been tried and tested. The process for *MacOs* also works but has some suspicious behaviour that we are investigating for now due to the use of python and the setup process not designed for *MacOs*.

Below are the steps to build for Windows, MacOs or Linux:

* ### Building for Windows
  This is a general outline on how to package the app into a single msi package. We will be using [Advanced installer](https://www.advancedinstaller.com/) to generate the msi build.

  First, make sure the app has been built with flutter

  ```bash
  flutter build windows
  ```

  Select generic **installer project** in Advanced Installer and click on **Create new project**. You will need the professional version or above of the app to do this :(
  
  ![Step 1](https://minohealth-storage.fra1.cdn.digitaloceanspaces.com/karaagro-giz/build-guide-images/step-1.png)

  On the **Product details** tab, Enter the name, version and publisher of the application. Scroll down and select an icon to be shown on the control panel.

  ![Step 2](https://minohealth-storage.fra1.cdn.digitaloceanspaces.com/karaagro-giz/build-guide-images/step-2.png)

  Click on the **Files and Folders** tab. Here we are going to provide the files that will actually be packaged. Click on Add Files and navigate to the directory with the flutter project. Here select `app.py`, `python-installer.exe` and `yolov5_exp11_best.pt`

  ![Step 3](https://minohealth-storage.fra1.cdn.digitaloceanspaces.com/karaagro-giz/build-guide-images/step-3.png)

  Click on **Add Files** again and (Assuming you are in the project root directory) navigate to */build/windows/runner/Release*. Select all the files.

  Now click on **Add Folder** and (Again assuming you are in the project root directory) navigate to */build/windows/runner/Release*. Select the data folder.

  Click on the **application folder** in the target machine to see all the added files.

  ![Step 4](https://minohealth-storage.fra1.cdn.digitaloceanspaces.com/karaagro-giz/build-guide-images/step-4.png)

  Right click on the cadi executable and select **New shortcut To - Installed file**. Enter a custom name and for the shortcut folder, we will select Desktop. Select an icon for the shortcut and click OK.

  ![Step 5](https://minohealth-storage.fra1.cdn.digitaloceanspaces.com/karaagro-giz/build-guide-images/step-5.png)

  You can create multiple shortcuts with the same process and just changing the shortcut folder.

  Click on the `Install Parameters` tab. Here we are going to set the application folder to `[ProgramFilesFolder][ProductName]`. Set the packet type to `64-bit package for x64 processors (AMD64, EM64T)`. Also, check `Run as administrator`

  ![Step 6](https://minohealth-storage.fra1.cdn.digitaloceanspaces.com/karaagro-giz/build-guide-images/step-6.png)

  Click on the `Builds` tab. Here we will select the `Single MSI (resources inside)` option. Select a folder where the package will be placed after build and enter a name for the msi.

  ![Step 7](https://minohealth-storage.fra1.cdn.digitaloceanspaces.com/karaagro-giz/build-guide-images/step-7.png)

  Finally go to the **Dialogs** tab. Here we will customise the installation dialogs. Click the Exit dialog and at the bottom, scroll till you find the Launch Application section. Check the `Launch application at the end of installation` checkbox and select the executable(Not the python executable). Also check the `Run as administrator` and `Option checked by default` options.

  ![Step 8](https://minohealth-storage.fra1.cdn.digitaloceanspaces.com/karaagro-giz/build-guide-images/step-8.png)

  On the title bar, click the build icon to build the msi package.

  ![Step 9](https://minohealth-storage.fra1.cdn.digitaloceanspaces.com/karaagro-giz/build-guide-images/step-9.png)

  This is just a simple build without proper certificates and all that. For more information about building packages with Advanced installer, checkout their guide [here](https://www.advancedinstaller.com/user-guide/introduction.html)

* ### Building for MacOs X
  MaxOs X build process not perfected yet. Coming soon.

* ### Building for Linux
  Linux devices are not supported

## Assumptions
---
[insert assumptions @harriet]

## Advantages and Use Cases
---
[insert advantages and use cases @harrient]

## Resources and Links
---

This project generated a lot of resources that are important for anyone looking to work with/on this project to take a look at.

Below are links to these resources:

- [DataSet on Hugging Face](https://huggingface.co/datasets/KaraAgroAI/CADI-AI)
- [DataSet on Kaggle](https://www.kaggle.com/datasets/karaagroaiprojects/cadi-ai)
- [DataSheet](https://docs.google.com/document/d/1ox23J2ti8-jVsQODw3SqEAVj2sszHSswS3bmcdwW7Y8/edit?usp=sharing)
- [Cashew Model](https://huggingface.co/KaraAgroAI/CADI-AI)

## Conclusion
In conclusion, CADI AI (Cashew Disease Identification with Artificial Intelligence) is a desktop application developed by KaraAgro AI. It utilizes artificial intelligence technology to identify disease, abiotic stress, and pest infestations in cashew plants based on drone images. The application aims to serve as an early warning system for farmers, helping them quickly detect issues in their cashew farms and improve crop health and yield.

While CADI AI provides valuable assistance, it should be noted that it does not provide specific disease or pest identification or treatment recommendations. Users are advised to exercise caution and verify the diagnoses by consulting trained agronomists or extension officers before taking any action based on the application's results.

The project involved various stages, including data collection, image pre-processing, annotation, model training, and software development. The software is built as a local Flutter desktop application and utilizes a Flask server for local inference. It also includes a setup process to ensure the required software dependencies are installed.

Contributions to the project are welcome following the `Contributing Guides`

Overall, CADI AI offers a promising solution for cashew farmers, combining artificial intelligence and drone imagery to enhance disease and pest detection. With ongoing support and contributions, the application can continue to improve and contribute to the well-being and productivity of cashew farms.