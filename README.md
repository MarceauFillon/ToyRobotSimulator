# Toy Robot Simulator

This is the solution to answer Curve Tomorrow's challenge given on Monday 26/10/2020. 
As a test for software practices and ability to learn, I set the deadline to Wednesday 28/10/2020 11:59PM.
I chose the Ruby On Rails technology for the learning exercise.

## Requirements
This application requires you to have the following prerequisites.
* Ruby
* SQLite3
* Node.js
* Yarn
* The gem Rails

## Versions
### Ruby
```bash
ruby 2.7.2p137 
```

### Rails
```bash
Rails 6.0.3.4
```

## Run application
First initialise the database, run the following command in the workspace folder
```bash
rails db:migrate
```
Then, launch the server, run the following command in the workspace folder
```bash
ruby bin\rails server
```

### Commands
* **CREATE**: Create a robot to interact with (only one robot can be created)
* **DESTROY**: Destroy the robot, allowing you to create a new one.
* **PLACE**: Place the created robot on the table at the coordinates requested (A robot can only be placed if it has been created).
* **MOVE**: Move the robot one unit into the direction (orientation) of the robot (Can only happen if the robot has been place).
* **ROTATE**: Rotate the robot 90 degres on the right or on the left (Can only happen if the robot has been place).
* **REPORT**: Report the robot current status (coordinates and orientation).

## How to run the test suite
To set up the test database, run the following command in the workspace folder
```bash
rails db:migrate RAILS_ENV=test 
```
To run the test suite, run the following command in the workspace folder
```bash
rake TESTOPTS="-v" test 
```

## Future improvements
* Make the number of cells generic and ready to use in all the code
* Build system test suite (started the implementation but failing because Selenium does not wait for Ajax requests)
* Outputs in the log for wrong commands
* Persistent log
* Robot based on session

