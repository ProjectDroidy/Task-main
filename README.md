# README #

This README would normally document whatever steps are necessary to get your application up and running.

### What is this repository for? ###

* Project Ajenda
    • Code base uses package concept to reuse the code for sister projects or completely for new work flow.
    • MVVM architecture with SwiftUI and Swift is used.
    • Core data has been used for local db.
    • Screens
        - Splash (Intro page)
        - Home (loading lists from online or offline)
        - Detail (detail view with animations)
    
* Quick summary
    An iOS Task project which makes uses of moviedb free api's and displays the
    movie list and details, with offline support with each page you load storing
    in Core Data. [**Usage of third party library is avoided to have more controll
    over the project and code**]
* Version: 1.0
* Sample Outputs
    • Demo video has been atached
    • Output screen shots has been attached

### How do I get set up? ###

* Open Folder
* Open FlipTree Project and run 
* Dependencies: 
    • APIKEY for moviedb
    • All three reusable packages (FlipTreeFoundation, FlipTreeModel, FlipTreeDataHandlers)
* Database configuration
    • Core Data DB shoule be located in base project, not on packages
    • CoreData Entity should be named as following [ModelName]Entity and Object should have name [ModelName]Model. (eg: FTMovieEntity & FTMovieModel)
* How to run tests
* Deployment instructions
    • Select Base Project on run scheme and Run the project


### Who do I talk to? ###

* Author: Abishek Robin R S (abishekrobin96@gmail.com)
