# Put your step definitions here
Given(/^I set the environment variables to:$/) do |table|
  # table is a Cucumber::Ast::Table
  data = table.rows_hash
  data.each do |key, value|
    ENV[key] = value
  end
end
