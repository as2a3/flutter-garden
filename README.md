# garden

A new Garden Flutter project.

## Getting Started

This project save information about Garden(Info about garden's plants)

## Used libs
    - Bloc for statement widgets
    - Floor for database

## Running code
    - Because we are using floor and free zed libs we need to generate
    requirement files so, we will run this command line 
    => flutter packages pub run build_runner build

    if we wanted any edit in floor file and by extension in generated file run this command
    => flutter packages pub run build_runner build --delete-conflicting-outputs