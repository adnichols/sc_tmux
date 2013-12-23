Feature: My bootstrapped app kinda works
  In order to get going on coding my awesome app
  I want to have aruba and cucumber setup
  So I don't have to do it myself

  Scenario: App just runs
    When I get help for "sc"
    Then the exit status should be 0
    And the banner should be present
    And the banner should document that this app takes options
    And the following options should be documented:
      |--version|
      |--create|
      |--attach|
      |--fix|
      |--grab|
      |--name|
      |--agent_file|

  Scenario: App provides help with no arguments
    When I run `sc`
    Then the exit status should be 64
    And the banner should be present
    And the output should contain "We expect a HOST if no options are passed"

  Scenario: Grab gets variables
    Given I set the environment variables to:
      | SSH_CLIENT     | foo  |
      | SSH_TTY        | bar  |
      | SSH_AUTH_SOCK  | derp |
      | SSH_CONNECTION | perp |
    When I run `sc -g`
    Then the exit status should be 0

  Scenario: Grab gets variables to a custom agent_file
    Given I set the environment variables to:
      | SSH_CLIENT     | foo  |
      | SSH_TTY        | bar  |
      | SSH_AUTH_SOCK  | derp |
      | SSH_CONNECTION | perp |
    When I run `sc -g --agent_file .ag_file_test`
    Then the exit status should be 0
    And the file ".ag_file_test" should contain:
    """
    SSH_CLIENT="foo"
    SSH_TTY="bar"
    SSH_AUTH_SOCK="derp"
    SSH_CONNECTION="perp"
    """

  Scenario: Fix outputs variables
    Given a file named ".ag_file_test" with:
    """
    SSH_CLIENT="bark"
    SSH_TTY="meow"
    SSH_AUTH_SOCK="oink"
    SSH_CONNECTION="caw"
    """
    When I run `sc -f --agent_file .ag_file_test`
    Then the output should contain:
    """
    SSH_CLIENT="bark"
    SSH_TTY="meow"
    SSH_AUTH_SOCK="oink"
    SSH_CONNECTION="caw"
    """

  Scenario: Setup outputs alias
    When I run `sc -s`
    Then the exit status should be 0
    And the output should contain:
    """
    Add the following alias to wherever you keep aliases:
    alias fixssh='eval $(sc -f)'
    """

