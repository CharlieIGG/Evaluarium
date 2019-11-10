# frozen_string_literal: true

desc 'Release tasks meant to happen on each deploy'
task :release do
  # 1: Invoke the database migration task:
  Rake::Task['db:migrate'].invoke

  # 2: Add other tasks to execute. It is EXTREMELY IMPORTANT that these tasks
  # can be called repeatedly producing the same result as the first call (be
  # "Idempotent")
end