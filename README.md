# README

This is still very much a work in progress, but the idea is to create a simple app that manages data around Github
users and their repositories.  The app will allow users to search for Github users and then add them to a list of
registered/managed users. That list of users will then be updated based on rankings based on things like the number of
stars a user's repositories have, the languages used in those repositories, etc.

## Setup
To get started, clone the repo and run `bundle install` to install the necessary gems.

Then run `rails db:migrate` to setup the database.

In order to use the Github API, you'll need to create a Github API token and create an ApiToken record in the database
with the name `github` and the token as the token field's value (the easiest way to do this is to use the Rails console).

Finally, run `rails s` to start the server.

You should then be able to navigate to `localhost:3000` and see the home page.

## Testing
To run the tests, run `rspec`.

## TODO
* Implement ranking system.
* Implement background jobs to update user data based on rankings.
* It should use UUIDs for the user ids instead of integers.
* Better error handling/messaging.
* Add internationalization.
* Increased security around the Github API token and other sensitive data.

## Notes
* Only the first part of the test has been implemented so far (perhaps part two would make for a good pairing session).
* The app currently only keeps track of the primary language of a repository. It ultimately should keep track of all
languages in a repository and the usage size of each.
* CSRF protection is disabled for now. It should be re-enabled once the app is ready to be deployed.