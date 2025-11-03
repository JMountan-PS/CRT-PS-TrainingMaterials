*** Settings ***
Resource                        ../resources/common.resource
Resource                        ../resources/Sales/leads.resource
Library                         DataDriver     reader_class=TestDataApi    name=Leads.csv
Suite Setup                     Setup Browser
Test Setup                      Home 
Suite Teardown                  Close All Browser Sessions
Test Template                   Create Verify and Delete Lead End to End

# In this exercise we use the same salesforce scenario built with exercise 6 and 12.

*** Test Cases ***
Exercise 14 - Data Driven Testing - Create Lead using Suite Test Template with ${lead_status} ${last_name} ${company} ${first_name} ${salutation}
    [Tags]                    alternate CSV

*** Keywords ***
Create Verify and Delete Lead End to End
    [Arguments]             ${lead_status}              ${last_name}           ${company}      ${first_name}    ${salutation}    ${phone}=${EMPTY}    ${title}=${EMPTY}    ${email}=${EMPTY}    ${website}=${EMPTY}    ${lead_source}=${EMPTY}
    Log To Console          Step: Entering Lead - ${first_name} ${lastname} - ${lead_status}
    Enter a Lead            ${lead_status}              ${last_name}           ${company}      ${first_name}    ${salutation}    ${phone}             ${title}             ${email}             ${website}             ${lead_source}
    Log To Console          Step: Deleting Lead - ${first_name} ${lastname} - ${lead_status}
    Delete a Lead           ${first_name}               ${last_name}