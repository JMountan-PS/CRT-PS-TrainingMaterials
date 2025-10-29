*** Settings ***
Resource              ../resources/common.resource
Resource              ../resources/Sales/leads.resource
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

