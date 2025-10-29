*** Settings ***
Resource              ../resources/common.resource
Library               FakerLibrary
Suite Setup           Setup Browser
Test Setup            Run Keywords                Home                        Unique Test Data
Suite Teardown        Close All Browser Sessions
Test Template         Create Verify and Delete Lead End to End

# In this exercise we use the same salesforce scenario built with exercise 6 and 12.

*** Test Cases ***                                                                            lead_status         last_name                      company        first_name     salutation
Exercise 14 - Data Driven Testing - Create Lead using Suite Test Template Unique Data         Working              ${last_name}                  ${company}     ${first_name}  Ms.
Exercise 14 - Data Driven Testing - Create Lead using Suite Test Template Fixed Data          Working              Smith                         Growmore       Tina           Ms.


*** Keywords ***

Create Verify and Delete Lead End to End
    [Arguments]       ${lead_status}              ${last_name}                ${company}             ${first_name}     ${salutation}               ${phone}=${EMPTY}    ${title}=${EMPTY}    ${email}=${EMPTY}    ${website}=${EMPTY}    ${lead_source}=${EMPTY}
    Enter a Lead      ${lead_status}              ${last_name}                ${company}             ${salutation}     ${first_name}               ${phone}             ${title}             ${email}             ${website}             ${lead_source}
    Delete a Lead     ${first_name}               ${last_name}

Enter a Lead
    [tags]            Lead
    [Arguments]       ${lead_status}              ${last_name}                ${company}
    ...               ${first_name}               ${salutation}               ${phone}=${EMPTY}
    ...               ${title}=${EMPTY}           ${email}=${EMPTY}           ${website}=${EMPTY}
    ...               ${lead_source}=${EMPTY}

    Home
    Launch App        Sales

    ClickText         Leads
    ClickText         New                         anchor=Import
    VerifyText        Lead Information
    UseModal          On                          # Only find fields from open modal dialog

    #Fill in required information
    Picklist          Salutation                  ${salutation}
    TypeText          First Name                  ${first_name}
    TypeText          Last Name                   ${last_name}
    Picklist          Lead Status                 ${lead_status}
    TypeText          Company                     ${company}                  anchor=Last Name

    #Fill in optional information
    Run Keyword If    "${phone}"!="${EMPTY}"      TypeText                    Phone                  ${phone}          anchor=First Name
    Run Keyword If    "${title}"!="${EMPTY}"      TypeText                    Title                  ${title}          anchor=Address Information
    Run Keyword If    "${email}"!="${EMPTY}"      TypeText                    Email                  ${email}          anchor=Rating
    Run Keyword If    "${website}"!="${EMPTY}"    TypeText                    Website                ${website}
    Run Keyword If    "${lead_source}"!="${EMPTY}"                            PickList               Lead Source       ${lead_source}

    #Save
    ClickText         Save                        partial_match=False
    UseModal          Off
    Sleep             2

    #Verify Details
    ClickText         Details                     anchor=Activity
    VerifyText        ${salutation} ${first_name} ${last_name}                anchor=Details
    VerifyText        ${title}                    anchor=Details
    VerifyText        ${phone}                    anchor=Lead Status
    VerifyField       Company                     ${company}
    VerifyField       Website                     ${website}
    Log Screenshot

    ClickText         Leads
    VerifyText        ${first_name} ${last_name}
    VerifyText        ${title}
    VerifyText        ${company}

Delete a Lead
    [tags]            Lead                        Git Repo Exercise
    [Arguments]       ${first_name}               ${last_name}
    LaunchApp         Sales
    ClickText         Leads
    VerifyText        Intelligence View           timeout=120s

    ClickText         ${first_name} ${last_name}
    ClickText         Delete
    ClickText         Delete
    ClickText         Close
    Log Screenshot
