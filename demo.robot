# FILE: demo.robot

#  ███████╗███████╗████████╗████████╗██╗███╗   ██╗ ██████╗ ███████╗
#  ██╔════╝██╔════╝╚══██╔══╝╚══██╔══╝██║████╗  ██║██╔════╝ ██╔════╝
#  ███████╗█████╗     ██║      ██║   ██║██╔██╗ ██║██║  ███╗███████╗
#  ╚════██║██╔══╝     ██║      ██║   ██║██║╚██╗██║██║   ██║╚════██║
#  ███████║███████╗   ██║      ██║   ██║██║ ╚████║╚██████╔╝███████║
#  ╚══════╝╚══════╝   ╚═╝      ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝
*** Settings ***
Documentation     Wordpress Testing.
Library           Selenium2Library
Library           OperatingSystem
Library           String
Library           Collections
Resource          demokeyword.txt

Suite Setup     Setup_Suite
Test Setup      Setup_Test
Test Teardown   TD_Test
Suite Teardown  TD_Suite



#  ██╗   ██╗ █████╗ ██████╗ ██╗ █████╗ ██████╗ ██╗     ███████╗███████╗
#  ██║   ██║██╔══██╗██╔══██╗██║██╔══██╗██╔══██╗██║     ██╔════╝██╔════╝
#  ██║   ██║███████║██████╔╝██║███████║██████╔╝██║     █████╗  ███████╗
#  ╚██╗ ██╔╝██╔══██║██╔══██╗██║██╔══██║██╔══██╗██║     ██╔══╝  ╚════██║
#   ╚████╔╝ ██║  ██║██║  ██║██║██║  ██║██████╔╝███████╗███████╗███████║
#    ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝╚══════╝
*** Variables ***
${URL}          http://localhost/wordpress
${BROWSER}      Chrome
${SuperUser}    admin
${SuperUserPW}  !NCS2019



#  ████████╗███████╗███████╗████████╗     ██████╗ █████╗ ███████╗███████╗███████╗
#  ╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝    ██╔════╝██╔══██╗██╔════╝██╔════╝██╔════╝
#     ██║   █████╗  ███████╗   ██║       ██║     ███████║███████╗█████╗  ███████╗
#     ██║   ██╔══╝  ╚════██║   ██║       ██║     ██╔══██║╚════██║██╔══╝  ╚════██║
#     ██║   ███████╗███████║   ██║       ╚██████╗██║  ██║███████║███████╗███████║
#     ╚═╝   ╚══════╝╚══════╝   ╚═╝        ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
*** Test Cases ***

Wrong Password Login
    [Tags]              All     Login   ErrorLogin
    [Documentation]     Perform a login as ${SuperUser} with a wrong password

    Navigate To Login Page
    Input Username      ${SuperUser}
    Input Password      FALSCH
    Submit Credentials
    Password Error Message Should Be Shown

    [Teardown]


Wrong Username Login
    [Tags]              All     Login   ErrorLogin
    [Documentation]     Perform a login with a wrong Username

    Navigate To Login Page
    Input Username      FLASCH
    Input Password      ${SuperUserPW}
    Submit Credentials
    User Error Message Should Be Shown

    [Teardown]


Valid Admin Login
    [Tags]              All     Login
    [Documentation]     Perform a succesfull admin login

    Navigate To Login Page
    Input Username      ${SuperUser}
    Input Password      ${SuperUserPW}
    Submit Credentials
    Dashboard Should Be Open
    Screenshot          AdminLogin.png


Create User Single Hardcoded
    [Tags]              All     CreateUser
    [Documentation]     Create a single User hardcoded
    [Setup]     run keywords    Setup_Test
    ...         AND             Setup_AdminLogin

    Navigate To User Page
    Click on "Neu hinzufuegen" (User)
    Input Username      stweiss_robot
    Input EMail         stweiss@nomail.org
    Input FirstName     Stephan
    Input LastName      Weiss
    Click on "Password anzeigen"
    Enter new Password  !NCS2019-sw
    Disable Email notification
    Change the Role     Mitarbeiter
    Click on "Neuen Benutzer hinzufuegen"
    Textmessage should appear
    Screenshot          CreateUser_Hardcoded.png


Create User Template
    [Tags]              All     CreateUser
    [Documentation]     Create User through a Robot Framework Test Template
    [Setup]     run keywords    Setup_Test
    ...         AND             Setup_AdminLogin

    [Template]  Create User Loop with Template
    stweiss-robot1  stweiss-robot1@nomail.org   Stephan1    Weiss1  !NCS2019-robot1     Mitarbeiter
    stweiss-robot2  stweiss-robot2@nomail.org   Stephan2    Weiss2  !NCS2019-robot2     Mitarbeiter


Create User CSV
    [Tags]              All     CreateUser
    [Documentation]     Create User based on a CSV-file ("testdata.csv")
    [Setup]     run keywords    Setup_Test
    ...         AND             Setup_AdminLogin

    Create User Loop with CSV


Delete User
    [Tags]              All     CreateUser      InDev
    [Documentation]     Delete all created users
    [Setup]     run keywords    Setup_Test
    ...         AND             Setup_AdminLogin

    [Template]  Delete User Loop with Template
    stweiss_robot
    stweiss-robot1
    stweiss-robot2
    stweiss-robot3
    stweiss-robot4