# Swift6Concurrency
Core Components of the App Design

## Supported Platforms
Only iOS is supported platform 

## Min requirements
As the sample is to show the Swift6 concurrency in user.

## App Architecture
I will using MVVM to demo the Enterprise app development. It is a well known architecture in the dev community and it suits the SwiftUI needs. 
 
### Dependency Injection
Using the Factory package to manage the project dependencies. You can find the package details here https://github.com/hmlongco/Factory
 
 ### House keeping
 Use Swift lint to force styling and conventions in your code. you can read more on https://swiftpackageindex.com/realm/SwiftLint about this package. I have left some of the warnings as it is for swift lint to demo that swift lint is working :) 
 
 ### Previews
 Previews are integral part of development and making sure that previews are working during development is important. The file SampleData contains the code to setup the data for the previews and then it uses the preview traits to pass that data and setup the container to use mock network client so that your previews does not make network call. 
 
 ## Unit Testing
 Using the Swift tesitng to test the code.There is only one example I have added and I think that one shows how to test the viewmodel and use AsyncChannel to signal  the Tasks so that we do not have to add any sleeps.
 Got the solution from 
 https://forums.swift.org/t/reliably-testing-code-that-adopts-swift-concurrency/57304/64?page=4
 
## Accessibility 
Test using the Xcode Developer tools -> Accessibility Inspector for the Voice over. 

## CI/CD
The project uses the configuration files and have added different configurations in the project for different environments. During the CI/CD we can use these different configurations to use pass on values for the secrets or properties specific to the environment.
