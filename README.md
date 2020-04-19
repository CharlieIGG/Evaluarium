![alt text](./app/javascript/images/logo1.svg "Logo Title Text 1")

# **Evaluarium**

![](https://github.com/CharlieIGG/evaluarium/workflows/specs/badge.svg)

## ⚠️**WARNING**: This application is still a Work-in-progress!

Evaluating Projects is easy in a lot of cases, but when it comes down to projects where the evaluation
is rather qualitative, things get messy.

Evaluarium is an open-source, self-hosted platform for managing Projects in the context of Evaluation Programs.
It can be used for voting panels in Hackathons and/or Admission Comittes, or even to keep up with a Venture Capital portfolio.

Typical use-cases are Startup Incubators, Accelerators, Hackathons, and other such scenarios where projects get evaluated in any matter that has a degree of "qualitativeness", as opposed to projects that can be very easily normalized and analyzed in a purely numerical manner (e.g. Real Estate development).

**[Check out the live demo!](https://evaluarium.herokuapp.com/users/sign_in)** (You can log-in as an Admin using `admin@example.com` // `123456`, the demo database is cleaned regularly.)

## Table of contents

- [**Evaluarium**](#evaluarium)
  - [⚠️**WARNING**: This application is still a Work-in-progress!](#%e2%9a%a0%ef%b8%8fwarning-this-application-is-still-a-work-in-progress)
  - [Table of contents](#table-of-contents)
    - [**Environments & URLs**](#environments--urls)
  - [**Development**](#development)
    - [**Prerequisites**](#prerequisites)
    - [**Entity Relationship Diagram**](#entity-relationship-diagram)
    - [**Setup the project**](#setup-the-project)
    - [**Running the stack for Development**](#running-the-stack-for-development)
      - [**Running AND attaching to a container**](#running-and-attaching-to-a-container)
    - [**Stop the project**](#stop-the-project)
    - [**Restoring the database**](#restoring-the-database)
    - [**Debugging**](#debugging)
    - [**Running specs**](#running-specs)
    - [**Writing Specs**](#writing-specs)
  - [**Application Architecture**](#application-architecture)
    - [**Major Facets**](#major-facets)
    - [**Best Practices**](#best-practices)
    - [**Responsibility-separation Patterns**](#responsibility-separation-patterns)
    - [**Application Layers**](#application-layers)
    - [**Analyzing code for linting issues**](#analyzing-code-for-linting-issues)
  - [**CI/CD**](#cicd)
  - [**Deploying**](#deploying)
  - [**TO-DO**](#to-do)
  - [**Contributing**](#contributing)

### **Environments & URLs**

- **Production** - TBD
- **Staging** - TBD

## **Development**

### **Prerequisites**

All you need to start developing this project is to have [Docker](https://www.docker.com/products/docker-desktop) and [Docker Compose](https://docs.docker.com/compose/) installed.

### **Entity Relationship Diagram**

**[Here](./erd.pdf)'s** a glimpse of the current Entity Relationships.

### **Setup the project**

You'll probably want to install [`plis`](https://github.com/IcaliaLabs/plis)(a wrapper around `docker-compose` that helps us simplify some commands, and overall make our terminal commands less verbose when using Docker), in order to simplify most Docker commands, as this project is meant to be run using Docker.
`plis start`, which will start up the services in the `development` group (i.e. rails
and sidekiq), along with their dependencies (posgres, redis, etc).

Alternatively, you can use the more verbose `docker-compose` like you usually would. Both
methods of starting containers will be shown, but keep in mind out of
every plis/docker-compose pair of commands you only need to choose one.

After installing please you can follow these simple steps:

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
Docker will automatically pick up any constants you declare here during the construction of containers. These then be exposed within the container as **Environment Variables** through the `docker-compose` file, using the `environment` for the respective container.

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

> 💡 Note how most `docker-compose` commands are interchangeable with `plis`, however `plis` has some extra syntactic sugar, see [below](#running-the-stack-for-development).

4. Inside the container you need to migrate the database:
```bash
% rails db:create db:migrate db:seed
```

> ⚠️ Note how migrating the database should be run from within the container every time you make changes to the database, so don't forget to run `plis run <container-name> bash` before running the migrations. You can also migrate directly and skip loading the bash session: `plis run <container-name> rails db:migrate`. Please note that this has to be done from within (or using a -) container that is loading Rails, namely `web` and `test` in this case.

### **Running the stack for Development**

1. Fire up a terminal and run:

plis:

```bash
$ plis start
```

docker-compose:

```bash
$ docker-compose up
```

That command will lift every service Evaluarium needs, such as the `rails server`, `postgres`, and `redis`.

It may take a while before you see anything, you can follow the logs of the containers with:

```bash
$ docker-compose logs
```

Once you see an output like this:

```bash
web_1   | => Booting Puma
web_1   | => Rails 5.1.3 application starting in development on http://0.0.0.0:3000
web_1   | => Run `rails server -h` for more startup options
web_1   | => Ctrl-C to shutdown server
web_1   | Listening on 0.0.0.0:3000, CTRL+C to stop
```

This means the project is up and running.

#### **Running AND attaching to a container**

You can actually run an attached session that will focus exclusively on the main container (i.e. you won't get mixed with the logs of the other dependent container, and you can attach debugger sessions), all in one command:

```bash
$ plis run --service-ports <container-name>
```

### **Stop the project**

In order to stop Evaluarium as a whole you can run:

```bash
$ plis stop
```

This will stop every container, but if you need to stop one in particular, you can specify it like:

```bash
$ plis stop web
```

`web` is the service name located on the `docker-compose.yml` file, there you can see the services name and stop each of them if you need to.

### **Restoring the database**

You probably won't be working with a blank database, so once you are able to run Evaluarium you can restore the database, to do it, first stop all services:

```
$ plis stop
```

Then just lift up the `db` service:

```
$ plis start db
```

The next step is to login to the database container:

```
$ docker exec -ti evaluarium_db_1 bash
```

This will open up a bash session in to the database container.

Up to this point we just need to download a database dump and copy under `Evaluarium/backups/`, this directory is mounted on the container, so you will be able to restore it with:

```
root@a3f695b39869:/# bin/restoredb evaluarium_dev db/backups/<databaseDump>
```

If you want to see how this script works, you can find it under `bin/restoredb`

Once the script finishes its execution you can just exit the session from the container and lift the other services:

```
$ plis start
```

### **Debugging**

We know you love to use `debugger` or `byebug`, and who doesn't, and with Docker is a bit tricky, but don't worry, we have you covered.

Just run this line at the terminal and you can start debugging like a pro:

```
% plis attach web
```

This will display the logs from the rails app, as well as give you access to stop the execution on the debugging point as you would expect.

>⚠️ **Take note that if you kill this process you will kill the web service, and you will probably need to lift it up again.**

> 💡 Note that is you have run the `plis run --service-ports web` command mentioned above in the document, you can skip this step before throwing in debuggers inside the code.

### **Running specs**

To run specs, you can do:

```
$ plis run test rspec
```

Or for a specific file:

```
$ plis run test rspec spec/models/user_spec.rb

```

> 💡 If you have questions or doubts about the current behavior of any component in the system, please take a look at any related specs, since they also function as a way of documenting desired behaviors that might not be 100% explicit in the component itself.

### **Writing Specs**

All of our specs are based on [RSpec](https://rspec.info/), as well as [Capybara](https://teamcapybara.github.io/capybara/) and [Selenium WebDriver](https://www.selenium.dev/projects/) for Integration specs. [Our Philosophy is completely oriented towards a combination of BDD and DDD](https://medium.com/datadriveninvestor/the-value-at-the-intersection-of-tdd-ddd-and-bdd-da58ea1f3ac8).

Please refer to our [writing specs](docs/writing_specs.rb) section for more details specific to this project.

## **Application Architecture**

Ahead is a summary of the application's architecture. **For more detail, please see our dedicated [application architecture section](docs/application_architecture.md)**.

### **Major Facets**

The application is divided into **two "Major Facets"**: a "monolithic" **back-office service**, which serves as the management system for our staff and our partners (in the near future?), and a "decoupled" back-end which stems from the former facet, and is expressed in it's majority as a [RESOURCEful API](https://medium.com/@trevorhreed/you-re-api-isn-t-restful-and-that-s-good-b2662079cf0e)

### **Best Practices**

Before you write any new features for this application it is strongly recommended to have a look at [This document of "Best Practices" for Rails applications](https://docs.google.com/document/d/1YZ1L4h2TMJ07YFN7dN_3lZSDB17iRUE0XLKMOZhHoNg/edit#heading=h.1doftf9akxl5).

### **Responsibility-separation Patterns**

This application's back-office follows as [MVC Pattern](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller), while the API follows a "Resource-Controller" pattern in its majority.

### **Application Layers**

1. **Migrations and DB Schema**: Manage and map the Database
2. **Models**: Add higher-level rules and behaviors that correlate to the Database schema and enhance existing instances of every entry in every "modelled" table in the database.
3. **Resources**: Map and Serialize Models that shall be exposed via the API, as well as certain rules and behavior for said exposition.
4. **Policies and Policy Scopes**: determine the ability (or inability) to interact in different ways with specific Models/Resources, in a Identity- and Role-based way. Policy Scopes determine exactly what records can be accessed (if at all) by a given user, based on the user's identity and role(s).
5. **Controllers**: Recieve requests, delegate execution to the lower layers, respond something.
6. **Decorators**: Augment models with additional representational behavior, while helping us encapsulate and isolate representational behavior from inherent relational and functional behavior. **Helps us keep our Views clean and simple**.
7. **Views**: Render the GUI, typically served by the controllers based on the controller action name.
8. **Javascript**: Augment the views with dynamic, client-side behavior and logic, from pre-compiled libraries, to our own React components, we drive all assets, in particular Javascript using Webpack.

### **Analyzing code for linting issues**

You can use codeclimate to analyze code & detect issues. Install [Codeclimate CLI](https://github.com/codeclimate/codeclimate#packages)
and then run the following commands:

```bash
1: Fetch the codeclimate engine configurations - we continuously update them,
so it is a good idea to run this command often:
codeclimate prepare

2: You might not have the codeclimate engines downloaded. While this is not
required, doing this might prevent you from thinking codeclimate is stuck on
the `structure` and `duplication` checks, when in fact they are huge images :(
codeclimate engine:install

3: Finally, run codeclimate to analyze the code:
codeclimate analyze
```

## **CI/CD**

We use [GitHub Actions](https://github.com/features/actions) as the driver to run our CI, and Heroku as the driver to our CD (see [below](#deploying)).
Check out the [.github/workflows](.github/workflows) for the configuration of tasks that are run as part of the GitHub Actions Pipeline.

Most importantly we have the [specs.yml](.github/workflows/specs.yml) file, which will run all specs as soon as a new version of a new branch is deployed to GitHub, and the status of this run will be shown in any PR. It is encouraged that we create Branch-Protection rules based on the results of these workflows.

The results of these workflows can also be shown at the top of the repository, take a look at the badge near the header of this README.

The result of these workflows is currently also acting as a blocking mechanism for the automated deploys (see below).

## **Deploying**

Both the Staging and Production servers for this application are deployed to Heroku.
The Staging server is configured to deploy a new version, as soon as it detects that the CI/CD pipeline ("the checks") has passed successfully.

The Production server is not configured to do automatic deploys, but you can trigger the one-click "Deploy" button from Heroku (recommended), or deploy directly from your console if you've added the Server as a Git targer (not recommended for production).

Please take a look at the [heroku.yml file](heroku.yml) to see the instructions that are executed by Heroku upon deployment. In particular note how the "release" command ensures that Migrations are always up-to-date.

> ⚠️ If you're setting up a new Heroku target you will have to go through [the usual steps](https://devcenter.heroku.com/articles/getting-started-with-rails5), and be aware of the following details:
> 1. As with any first Rails env setup, you will have to create the database manually through the shell (recommended)
> 2. You will need to ensure that the Heroku project hast a NodeJS buildbpack (for JS asset compilation) and a Ruby buildpack **in that order**, otherwise you'll get issues with JS asset precompilation
> 3. Although you can (as of March 2020) run the application without Sidekiq, our ActiveStorage configuration will still expect some job-processing system it can connect to through Redis, so **you have to at least have Redis in the project** (you can find it as a Heroku Add-on)
> 4. You have to set the required Environment Variables in the Project's settings, most notably, the `CORS_ORIGINS_REGEXP`, all Facebook and `STORAGE_` related environment variables. See our current Staging implementation of an example.

## **TO-DO**

For the sake of readability, each major version's TO-DO list will be put into a separate file. You can find each corresponding TO-DO list here:

- [ ] [Version 1.0](docs/todo_v1_0.md)

## **Contributing**

Feel free to create forks + pull requests for this project with new features and bug-fixes.
If you're wanting to implement a functionallity that is very specific to your use case or industry, it should be added in a modular way (as an opt-in feature).
