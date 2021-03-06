Feature: Task
  >In order to remember what I did  
  As a person short on time  
  I want to keep track of tasks  

  Background: Signed in
    Given I am signed in as a new user

  Scenario: Create new task with title
    Given I am on the new task page
    And I fill in all required fields
    And I fill in "task_title" with "My first task title"
    When I press "Create"
    Then I should see "Task was successfully created."
    And I should see "My first task title"
  
  Scenario: Create new task with description
    Given I am on the new task page
    When I fill in all required fields
    And I fill in "task_description" with "A long task description explaining in more detail what the task is about"
    And I press "Create"
    Then I should see "Task was successfully created."
    And I should see "A long task description explaining"
  
  Scenario: Descending task order
    Given I have some tasks
    When I am on the tasks page
    Then I should see more recent tasks first
  
