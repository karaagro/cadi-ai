# CADI AI - Cashew Disease Identification with Artificial Intelligence

This is the main repository for CADI AI - a desktop application for identifying disease, abiotic stress and pest infestations in cashew plants.

## Table of Contents
* [Introduction](#introduction)
* [Problem Statement](#problem-statement)
* [Project Description](#project-description)
  * [Data Collection](#data-collection)
  * [Image Pre-processing](#image-pre-processing)
  * [Annotation](#annotation)
  * [Model Training](#model-training)
  * [Software Development](#software-development)
  * [Software Release and Deployment](#software-release-and-deployment)
* [Contributing](#contributing)
  * [Technologies & Tools](#technologies-&-tools)
  * [Workflow & Branch Rules](#workflow-&-branch-rules)
  * [Issues](#issues)
  * [Pull Requests](#pull-requests)
  * [Support](#support)
* [Downloading CADI AI](#download-cadi-ai)
* [Building a Custom CADI AI](#build-cadi-ai)
  * [Building for Windows](#building-for-windows)
  * [Building for MacOs X](#building-for-macos-x)
  * [Building for Linux](#building-for-linux)
* [Advantages and Use Cases](#advantages-and-use-cases)
* [Resources and Links](#resources-and-links)
* [Conclusion](#conclusion)


## Introduction

CADI AI - *Cashew Disease Identification with Artificial Intelligence* - is a demo-application that uses the technology Artificial Intelligence (AI). It looks at drone images of cashew trees and informs the user whether the Cashew tree suffers from:
 - pest infection - insect/pest stress factors represent the damage to crops by insects or pests
 - disease - diseased factors represent attacks on crops by microorganisms
 - abiotic stress - abiotic stress factors represent stress factors caused by non-living factors, e.g. environmental factors like weather or soil conditions or the lack of mineral nutrients to the crop. 

[KaraAgro AI](https://www.karaagro.com/) developed CADI AI for the initiatives “Market-Oriented Value Chains for Jobs & Growth in the ECOWAS Region (MOVE/Comcashew)” and [FAIR Forward - Artificial Intelligence for All](https://toolkit-digitalisierung.de/en/fair-forward/). Both initiatives are implemented by the Deutsche Gesellschaft für Internationale Zusammenarbeit (GIZ) on behalf of the German Federal Ministry for Economic Cooperation and Development (BMZ). 
    
CADI AI shall support farmers as an early warning system to quickly identify problems in their cashew farms and to keep their crops healthier and more yielding.
Please note that the application will not tell you which particular disease or pest a cashew tree suffers from or how to treat it. 

As with any application that uses AI: 
Please treat the results with caution because this system can produce wrong results. It is recommended to verify the diagnoses, for example, by seeking advice from a trained agronomist or extension officer before acting upon the diagnoses of the application. 

## Problem Statement
The threat of pests and diseases to the agricultural sector in Ghana is a constant concern, with climate change contributing to the potential for new and more damaging types of outbreaks (Yeboah et al., 2023). Based on multi-stakeholder engagements conducted by KaraAgro AI, also with women smallholder cashew farmers, stakeholders have identified pest and disease detection and yield estimation as critical concerns.

However, the existing methods of identifying agricultural pest and disease outbreaks, such as land surveys and on-site observations by individuals, are limited in their effectiveness and efficiency. Thus, there is a need for more innovative and efficient solutions to improve the monitoring and management of crop health. This highlights a gap in the existing tools and resources, which can be addressed through the use of advanced technologies such as machine learning and image analysis.

The creation of an open and accessible cashew dataset with well-labeled, curated, and prepared imagery and an artificial intelligence model and application software that exposes the model to users can be a valuable resource for data scientists, researchers, and social entrepreneurs to develop innovative solutions towards infield pest and disease detection and yield estimation, and through the use of the software, help farmers quickly identify problems in their cashew farms.


## Project Description
* ### Data Collection
  The data collection process was conducted at cashew farms in the Bono Region of Ghana. Two separate trips were made to the farms to accommodate seasonal variations for the diversity of the data. 

  The collection process spanned six days in total. While more continuous data collection across various regions during the cashew blooming cycle could have been beneficial, we still consider the dataset to be sufficiently diverse. This is due to the inclusion of different maturity stages, camera angles, time of capture, and various types of stress morphology in the data collected. 

  Dataset images were captured with the P4 multispectral drone at image resolution of 1600 x 1300 pixels. The images consist of close up shots and distant shots of the cashew plant abnormalities. The total number of images collected were 4,736.
* ### Image Pre-processing
  Preprocessing of the data involved removing crop images in which human figures or faces were accidentally captured. Also blurry images were deleted.
* ### Annotation
  The collected dataset annotation consisted of drawing bounding boxes on the collected images using MakeSense dataset annotation tool. The three classes that were annotated in the process include: 
  - Disease
  - Abiotic stress
  - Pest infection

* ### Model Training
  YOLO v5X architecture was employed to construct the model. To enhance the image quality and facilitate efficient processing, the resolution of the images was adjusted to 640 pixels, while maintaining a batch size of 56. The resulting model achieved an mAP of 0.648 and a size of 173.1 MB.

  ![](https://minohealth-storage.fra1.cdn.digitaloceanspaces.com/karaagro-giz/build-guide-images/val_batch2_pred.jpg)


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

  > **Note**: Due to the  size of the trained cashew model as described in the `Model Training` section above, the total size of the project files exceeded the Github repository  file size limit.

  As a result, the model was not included in the repository. The model is rather available publicly on Hugging face. The link to the Hugging face repository can be found below in the `Resources & Links` section.

  It is required that the model file be downloaded and added to the project on your local device before tests scan be run. If you run `flutter run` without the model file available in the project directory, you will not be able to run scans.

  > **Note**: CADI AI only runs scans on images that are having GPS coordinates in their Exif metadata (Exchangeable Image Format). 

    The Exif specifications define a pair of file types, mainly intended for recording technical details associated with digital photography [exif-format](https://www.loc.gov/preservation/digital/formats/fdd/fdd000146.shtml)

    Exif is a metadata standard that defines formats for sharing metadata related to images, sound, and ancillary tags used by digital cameras, scanners and other systems that handle image recorded by digital cameras. 

    In this case, it is required that images selected for scan in CADI AI must have metadata following the Exif standard, and must have GPS coordinates in their metadata before they can be scanned.

    This is because the application shows location pins on a satellite map that enables farmers to locate the region of the farm where a disease, abiotic stress or pest is found present. Without GPS coordinates this would not be possible.


* ### Software Release and Deployment
  CADI AI builds and releases are available on the repository.

  The application is built into a Windows msi package and uploaded with a tag to the repository. Builds for MacOs are also available. There is currently no support for Linux Systems and no future plans to support them.

  At the right side panel on the CADI AI repository, releases with tags can be found and can be downloaded and installed on users' devices.

  Semantic versioning ([Semver](https://semver.org/)) is used to name each build. Latest builds are better and more robust and should be preferred over older builds.

## Contributing
CADI AI was started as a private project with the goal of becoming open sourced. Now that it has been made available to the public, contributions are invited to fix issues and improve the application.

There are some rules, though, that we believe must be observed in contributing to the application. Find more information on these rules and related ones below.

* ### Technologies & Tools
  CADI AI is a flutter-based local desktop application. The following technologies and tools are used in the development of the application. These technologies are also pre-requisite in order to contribute to the improvement of the application.
  1. Flutter<=3.3.0
  2. Dart
  3. Isar Database
  4. GetX Controller
  3. Python 3.0 and later
  4. Python Libraries(
    Flask=>2.3.2,
    Flask-cors=>3.0.10,
    ultralytics=>8.0.106,
    torchvision=>0.15.2,
    torch=>2.0.1,
    opencv-python=>4.7.0.72,
    pandas=>2.0.1,
    psutil=>5.9.5,
    pyyaml=>6.0,
    tqdm=>4.65.0,
    matplotlib=>3.7.1,
    seaborn=>0.12.2
  )
  5. Visual Studio Code (Recommended IDE)
  6. Xcode (Required only for MacOs X)
* ### Workflow & Branch Rules
  [Semantic branch names](https://gist.github.com/seunggabi/87f8c722d35cd07deb3f649d45a31082) and [semantic commit messages](https://www.conventionalcommits.org/en/v1.0.0/)  are the format to be used for branches and commits to this repository.
  Anything else deviated from these standards would be rejected.

  *The branching workflow also follows the rules below:*

  - **master/main**:
  The master branch should always have stable code that can be picked for release at any time. Pull requests (PR) to the master branch only come from the QA branch.

  - **QA/test/staging (Quality Assurance)**:
  The QA branch is where code that has gone through  review from contributors can be tested. Then merged to main after testing.

  - **Dev**:
  The dev branch accepts pull requests (PR) for contributions. Code reviews are done against PR’s to the Dev branch

* ### Issues
  Before you submit an issue, please search the [issue tab](https://github.com/karaagro/cadi-ai/issues). An issue for your problem might already exist and reviewing the related discussions could provide valuable insights and solutions.

  If you want to add improvements or suggest new features, you should first [create an issue](https://github.com/karaagro/cadi-ai/issues/new/choose). This will let us discuss and agree on the proposed changes before you start working on them. After the proposal is accepted, the [`accepted`](https://github.com/karaagro/cadi-ai/labels/accepted) label will be added to the issue and implementation can begin.

  If you just want to fix a bug or typo, you can directly create a pull request with a clear description of the bug or typo you are fixing.

* ### Pull Requests
  To contribute to the project, follow the steps below:

  1. Fork [karaagro/cadi-ai](https://github.com/karaagro/cadi-ai). Uncheck the `Copy the main branch only` option to ensure you get the `dev` branch.
  1. Create a new branch from the `dev` branch in your forked repository.
      ```bash
      git checkout -b <branch-name> dev
      ```

  1. Add your changes and commit them with a descriptive commit message.
  1. Push your changes to github.
  1. Create a pull request to the [`dev`](https://github.com/karaagro/cadi-ai/tree/dev) branch of [karaagro/cadi-ai](https://github.com/karaagro/cadi-ai) and request a review from [@atamino](https://github.com/atamino)

* ### Support
  The team at KaraAgro AI will keep supporting the software indefinitely. We will be fixing issues,  making improvements and adding new features as and when they are needed.

## Download CADI AI
Newer and older releases of CADI AI can be downloaed at the [releases](https://github.com/karaagro/cadi-ai/releases) section of the repository.

## Build CADI AI
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

## Advantages and Use Cases
Some of the advantages and use cases of this project's dataset and the CADI AI software are listed below:

  - This dataset can be extended by other Data Scientists to create powerful solutions for farmers
  - The collected dataset was also utilized for an object detection task, where a model was trained to recognize areas affected by abiotic factors, diseases, and insect infestations of cashew fields. 
  - CADI AI, the software, can be used by farmers to early detect disease, abiotic stress and pests in their farms

## Resources and Links

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