# exercise-tracker

A shiny app that allows to enter data on exercise and visualizes the result.

The data is stored locally in a SQLite database and will hence be available whenever the app in launched again on the same device.

Work in progress.

To launch app: 
- The first time
  - download files and remove the current database with the example data
  - run create_datanbase.R to create a new database

- Every time the app is used
  - run helters_rsqlite.R to get the helper function in the environment
  - enter exercise data in the sidebar panel and submit

Current layout

![Picture1](https://github.com/sophchl/exercise-tracker/blob/master/documentation/pic1.jpg?raw=true)
<img src="https://github.com/sophchl/exercise-tracker/blob/master/documentation/pic1.jpg?raw=true" width="100" height="100">

The input fields adjust according to the exercise type selected, e.g. for climbing:

![Picture1](https://github.com/sophchl/exercise-tracker/blob/master/documentation/pic2.jpg?raw=true)

Data storage
- one table per exercise type
- main_id: rowid in responses_main, and id in each respective exercise type table
