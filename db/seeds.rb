# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

superadmin = User.create(email: 'admin@example.com', password: '123456')
superadmin.add_role :superadmin

criteria = [
  {
    name: 'Problem to Solve',
    short_description: 'How relevant is the problem that is trying to be solved?'
  },
  {
    name: 'Target Market',
    short_description: 'How relevant is the Target Market?  How well defined is\
                        it in terms of Demographics? Does it have a large potential?'
  },
  {
    name: 'Solution',
    short_description: 'How well does the proposed solution align with both the\
                        Problem and the Target Market?'
  },
  {
    name: 'Team',
    short_description: 'How good is the team? Do they have relevant experience\
                        in the field? Can they fullfill all the necessary roles?'
  },
  {
    name: 'Validation',
    short_description: 'Does the team have first-hand validation? Can they corroborate\
                        That an alignment exists between their target Problem, Customer, and Solution?'
  },
  {
    name: 'Bussiness Model',
    short_description: 'How sound does the proposed Business Model seem? Is there\
                        first-hand validation?'
  },
  {
    name: 'Traction',
    short_description: 'Is there any relevant traction already in terms of\
                        Revenue, Customers and Users (in that order of importance)?'
  }
]

criteria.each { |crit| EvaluationCriterium.create(name: crit[:name], short_description: crit[:short_description]) }
