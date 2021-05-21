# exercise-tracker

A shiny app that allows to enter data on exercise and visualizes the result.

The data is stored locally in a SQLite database and will hence be available whenever the app in launched again on the same device.

_Work in progress_

To launch app
- The first time
  - download files
  - run create_datanbase.R to create a new database (dependingon path name need to add folder "data" in "shiny-exercise")

- Every time the app is used
  - run helters_rsqlite.R to get the helper function in the environment
  - run app
  - enter exercise data in sidebar panel and submit

Current layout (data is just exemplary)

<img src="https://github.com/sophchl/exercise-tracker/blob/master/documentation/pic1.jpg?raw=true" width="700" height="500">

The input fields adjust according to the exercise type selected. Values can also be modified:

<img src="https://github.com/sophchl/exercise-tracker/blob/master/documentation/pic2.jpg?raw=true" width="700" height="500">

Data storage
- one table per exercise type
- main_id: rowid in responses_main, and id in each respective exercise type table
