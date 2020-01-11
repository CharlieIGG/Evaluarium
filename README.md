![alt text](./app/javascript/images/logo1.svg "Logo Title Text 1")

# Evaluarium

![](https://github.com/CharlieIGG/evaluarium/workflows/specs/badge.svg)

## ⚠️**WARNING**: This application is still a Work-in-progress!

Evaluating Projects is easy in a lot of cases, but when it comes down to projects where the evaluation
is rather qualitative, things get messy.

Evaluarium is an open-source, self-hosted platform for managing Projects in the context of Evaluation Programs.
It can be used for voting panels in Hackathons and/or Admission Comittes, or even to keep up with a Venture Capital portfolio.

Typical use-cases are Startup Incubators, Accelerators, Hackathons, and other such scenarios where projects get evaluated in any matter that has a degree of "qualitativeness", as opposed to projects that can be very easily normalized and analyzed in a purely numerical manner (e.g. Real Estate development).

**[Check out the live demo!](https://evaluarium.herokuapp.com/users/sign_in)** (You can log-in as an Admin using `admin@example.com` // `123456`, the demo database is cleaned regularly.)

## Table of contents

- [Evaluarium](#evaluarium)
  - [⚠️WARNING: This application is still a Work-in-progress!](#%e2%9a%a0%ef%b8%8fwarning-this-application-is-still-a-work-in-progress)
  - [Table of contents](#table-of-contents)
    - [Environment URLS](#environment-urls)
    - [The team](#the-team)
    - [Management tools](#management-tools)
  - [Development](#development)
    - [Setup the project](#setup-the-project)
    - [Running the stack for Development](#running-the-stack-for-development)
    - [Stop the project](#stop-the-project)
    - [Restoring the database](#restoring-the-database)
    - [Debugging](#debugging)
    - [Running specs](#running-specs)
      - [TestProf](#testprof)
    - [Analyzing code for issues](#analyzing-code-for-issues)
  - [Deploying](#deploying)
  - [Contributing](#contributing)

### Environment URLS

- **Production** - TBD
- **Staging** - TBD

### The team

| Name             | Email                 | Role               |
| ---------------- | --------------------- | ------------------ |
| Carlos I. Garcia | charlie.igg@gmail.com | Development, Owner |

### Management tools

You should ask for access to this tools if you don't have it already:

- [Github repo](https://github.com/charlieigg/EVALUARIUM)
- [Pivotal tracker project](https://www.pivotaltracker.com/)
- [Client Slack](https://change-me.slack.com/)
- [Heroku](https://heroku.com)

## Development

### Setup the project

You'll definitely want to install [`plis`](https://github.com/IcaliaLabs/plis), as in this case will
let you bring up the containers needed for development. This is done by running the command
`plis start`, which will start up the services in the `development` group (i.e. rails
and sidekiq), along with their dependencies (posgres, redis, etc).

Alternatively, you can use the more verbose `docker-compose` like you usually would. Both
methods of starting containers will be shown, but keep in mind out of
every plis/docker-compose pair of commands you only need to choose one.

After installing please you can follow this simple steps:

1. Clone this repository into your local machine

```bash
$ git clone git@github.com:charlieigg/evaluarium.git

```

2. Copy the `example.env` file to `.env` in the project's source directory.

```bash
$ cd evaluarium
$ cp example.env .env
```

The container can be started with both of these files being empty, but they must exist.
Talk to any team member to get the contents of each file so the
application works correctly.

3. Run the web service in bash mode to get inside the container by using
   the following command:

plis:

```bash
$ plis run web bash
```

docker-compose:

```bash
$ docker-compose run web bash
```

4. Inside the container you need to migrate the database:

```
% rails db:migrate
```

### Running the stack for Development

1. Fire up a terminal and run:

plis:

```bash
$ plis start
```

docker-compose:

```bash
$ docker-compose up
```

That command will lift every service EVALUARIUM needs, such as the `rails server`, `postgres`, and `redis`.

It may take a while before you see anything, you can follow the logs of the containers with:

```
$ docker-compose logs
```

Once you see an output like this:

```
web_1   | => Booting Puma
web_1   | => Rails 5.1.3 application starting in development on http://0.0.0.0:3000
web_1   | => Run `rails server -h` for more startup options
web_1   | => Ctrl-C to shutdown server
web_1   | Listening on 0.0.0.0:3000, CTRL+C to stop
```

This means the project is up and running.

### Stop the project

In order to stop EVALUARIUM as a whole you can run:

```
% plis stop
```

This will stop every container, but if you need to stop one in particular, you can specify it like:

```
% plis stop web
```

`web` is the service name located on the `docker-compose.yml` file, there you can see the services name and stop each of them if you need to.

### Restoring the database

You probably won't be working with a blank database, so once you are able to run EVALUARIUM you can restore the database, to do it, first stop all services:

```
% plis stop
```

Then just lift up the `db` service:

```
% plis start db
```

The next step is to login to the database container:

```
% docker exec -ti evaluarium_db_1 bash
```

This will open up a bash session in to the database container.

Up to this point we just need to download a database dump and copy under `EVALUARIUM/backups/`, this directory is mounted on the container, so you will be able to restore it with:

```
root@a3f695b39869:/# bin/restoredb evaluarium_dev db/backups/<databaseDump>
```

If you want to see how this script works, you can find it under `bin/restoredb`

Once the script finishes its execution you can just exit the session from the container and lift the other services:

```
% plis start
```

### Debugging

We know you love to use `debugger`, and who doesn't, and with Docker is a bit tricky, but don't worry, we have you covered.

Just run this line at the terminal and you can start debugging like a pro:

```
% plis attach web
```

This will display the logs from the rails app, as well as give you access to stop the execution on the debugging point as you would expect.

**Take note that if you kill this process you will kill the web service, and you will probably need to lift it up again.**

### Running specs

To run specs, you can do:

```
$ plis run test rspec
```

Or for a specific file:

```
$ plis run test rspec spec/models/user_spec.rb
```

#### TestProf

We use https://test-prof.evilmartians.io/#/ to profile tests, along with the `let_it_be` and `create_default` recipes there included to minimize the time spent in each test's setup and teardown.
These two recipes are very helpful to keep testing time in check, but they do come with a handful of caveats you need to be aware of, and which you can read [here](https://test-prof.evilmartians.io/#/let_it_be?id=caveats-amp-modifers).

### Analyzing code for issues

We use codeclimate to analyze code & detect issues. Install [Codeclimate CLI](https://github.com/codeclimate/codeclimate#packages)
and then run the following commands:

```bash
1: Fetch the codeclimate engine configurations - we continuously update them,
so it is a good idea to run this command often:
codeclimate prepare

2: You might not have the codeclimate engines downloaded. While this is not
required, doing this miht prevent you from thinking codeclimate is stuck on
the `structure` and `duplication` checks, when in fact they are huge images :(
codeclimate engine:install

3: Finally, run codeclimate to analyze the code:
codeclimate analyze
```

## Deploying

If you have previously run the `./bin/setup` script,
you can deploy to staging and production with:
% ./bin/deploy staging
% ./bin/deploy production

## Contributing

Feel free to create forks + pull requests for this project with new features and bug-fixes.
If you're wanting to implement a functionallity that is very specific to your use case or industry, it should be added in a modular way (as an opt-in feature).
