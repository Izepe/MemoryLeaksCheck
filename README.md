
# 🔎 CILeaksDetector 

This is a simple package that enables you to easily integrate the Memory leaks check to your CI workflow.

## Usage

Just need to follow these simple steps:

1. Copy `Dangerfile.leaksReport` to your project. This contains the logic to get the leaks message and post to your Pull request. You can custom this Dangerfile.  
Learn more about `Danger` [here](https://danger.systems/ruby/)

2. Create a maestro flow to run simulate the flow in your app.  
Learn more about `Maestro` [here](https://maestro.mobile.dev/)

3. In your ci workflow, just call:

```bash
    leaksdetector -processName $YOUR_APP_NAME -e $SUPPORTED_TESTING_FRAMEWORKS -d $PATH_TO_DANGER_FILE
```

## Current support testing frameworks

- [Maestro](https://maestro.mobile.dev/)
- [XCUITest](https://developer.apple.com/documentation/xctest) (In progress)

## How it works

1. Use Maestro to simulate the UI flow in your app.   

2. Generate `memgraph` using `leaks` tool provided by Apple.  
Find more about `leaks` tool and `memgraph` [here](https://developer.apple.com/videos/play/wwdc2018/416/)   

3. Use `leaksdetector` program to proceed the `memgraph` file. If any leaks founded, it will use Danger to post a message to your PR/slack, ... 

## Why I used Maestro?
   
1. I need a testing tool which doesn't kill the program after the testing finished execution. And Maestro support that. Also Maestro is very easy to integrate & use.  
2. I've tried to used XCUItest, which is really promissing. Based on this [WWDC video](https://developer.apple.com/videos/play/wwdc2021/10180/) from Apple, XCUITest even *allows us to capture the stacktrace where leaks occur & generate a memgraph*. However, I've tried to follow the video but Xcode didn't generate any memgraph. 
 => I'm working on this.


## How to support your testing frameworks

If you're using another UI testing framework which also support preserve the execution of the program after finish testing, you can create another PR to update the `leaksdetector`.   
It's easy to do that, just need to follow these steps:   

1. Open `Executor.swift`, create a new instance of your testing frameworks. Your new instance needs to conform to `Executor` protocol. 
  
```swift

    struct XCUITestExecutor: Executor {
        
        func simulateUI() throws {
            // Custom logic to start simulating UI
        }
        
        func generateMemgraph(for processName: String) throws {
            // Custom logic to start generating memgraph for a `processName`
        }
        
        func getMemgraphPath() -> String {
            // return the path to the generated memgraph
        }
    }
    
```

2. Open `ExecutorFactory.swift`, define your new UI testing frameworks to the `ExecutorType`, and add logic to generate it in the `createExecutor` func.

3. Add new `@Option` to the executable program if need

## Result

<img src=resources/result.png width=800/>