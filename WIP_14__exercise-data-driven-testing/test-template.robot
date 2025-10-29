*** Settings ***
Resource                        ../resources/common.robot
Library                         FakerLibrary
Suite Setup                     Setup Browser
Test Setup                      Run Keywords                Home                        Unique Test Data
Suite Teardown                  Close All Browser Sessions
# Test Template                 Create Lead
Test Template                   Create Verify and Delete Lead End to End

# In this exercise we use the same salesforce scenario built with exercise 6 and 12.

*** Test Cases ***                                        lead_status         last_name                      company        first_name     salutation
Create Lead using Suite Test Template Unique Data         Working              ${last_name}                  ${company}     ${first_name}  ${salutation}
Create Lead using Suite Test Template Fixed Data          Working              Smith                         Growmore       Tina           Ms.

Create Leads using Test Case Template
    [Template]                  Create Lead
    lead_status=Working         last_name=Smith             company=Growmore            salutation=Ms.         first_name=Tina             phone=+12234567858449     title=Manager               email=tina.smith@gmail.com                              website=https://www.growmore.com/                      lead_source=Advertisement
    lead_status=Working         last_name=Smith             company=Growmore            salutation=Ms.         first_name=Tina             phone=+12234567858449     title=Manager               email=tina.smith@gmail.com                              website=https://www.growmore.com/                      lead_source=Advertisement
    lead_status=Working         last_name=Smith             company=Growmore            salutation=Ms.         first_name=Tina             phone=+12234567858449     title=Manager               email=tina.smith@gmail.com                              website=https://www.growmore.com/                      lead_source=Advertisement

Verify Leads using Test Case Template
    [Template]                  Verify Lead
    last_name=Smith             salutation=Ms.              first_name=Tina             company=Growmore       phone=+12234567858449       title=Manager             website=https://www.growmore.com/
    last_name=Smith             salutation=Ms.              first_name=Tina             company=Growmore       phone=+12234567858449       title=Manager             website=https://www.growmore.com/
    last_name=Smith             salutation=Ms.              first_name=Tina             company=Growmore       phone=+12234567858449       title=Manager             website=https://www.growmore.com/
Delete Leads using Test Case Template
    [Template]                  Delete Lead
    last_name=Smith             first_name=Tina
    last_name=Smith             first_name=Tina
    last_name=Smith             first_name=Tina




*** Keywords ***

Create Verify and Delete Lead End to End
    [Arguments]                 ${lead_status}              ${last_name}                ${company}             ${first_name}               ${salutation}             ${phone}=${EMPTY}           ${title}=${EMPTY}           ${email}=${EMPTY}           ${website}=${EMPTY}         ${lead_source}=${EMPTY}
    Create Lead                 ${lead_status}              ${last_name}                ${company}             ${salutation}               ${first_name}             ${phone}                    ${title}                    ${email}                    ${website}                  ${lead_source}
    Verify Lead                 ${lead_status}              ${last_name}                ${company}             ${salutation}               ${first_name}             ${phone}                    ${title}                    ${email}                    ${website}                  ${lead_source}
    Delete Lead                 ${first_name}               ${last_name}

Create Lead 
    [Arguments]                 ${lead_status}              ${last_name}                ${company}             ${salutation}=${EMPTY}      ${first_name}=${EMPTY}    ${phone}=${EMPTY}           ${title}=${EMPTY}           ${email}=${EMPTY}           ${website}=${EMPTY}         ${lead_source}=${EMPTY}
    Launch App                  Sales
    ClickText                   Leads
    VerifyText                  Recently Viewed             timeout=120s
    ClickText                   New                         anchor=Import
    VerifyText                  Lead Information
    UseModal                    On                          # Only find fields from open modal dialog
    Run Keyword If              '${salutation}'!='${EMPTY}'                             Picklist               Salutation                  Ms.                       #optional
    Run Keyword If              '${first_name}'!='${EMPTY}'                             TypeText               First Name                  Tina                      #optional
    TypeText                    Last Name                   ${last_name}                #mandatory
    Picklist                    Lead Status                 ${lead_status}              #mandatory
    Run Keyword If              '${phone}'!='${EMPTY}'      TypeText                    Phone                  +12234567858449             First Name                #optional
    TypeText                    Company                     ${company}                  Last Name              #mandatory
    Run Keyword If              '${title}'!='${EMPTY}'      TypeText                    Title                  Manager                     Address Information       #optional
    Run Keyword If              '${email}'!='${EMPTY}'      TypeText                    Email                  tina.smith@gmail.com        Rating                    #optional
    Run Keyword If              '${website}'!='${EMPTY}'    TypeText                    Website                https://www.growmore.com/                             #optional
    Run Keyword If              '${lead_source}'!='${EMPTY}'                            Picklist               Lead Source                 Advertisement             #optional
    ClickText                   Save                        partial_match=False
    UseModal                    Off
    Sleep                       2

Verify Lead
    [Arguments]                 ${lead_status}=${EMPTY}     ${last_name}=${EMPTY}       ${company}=${EMPTY}    ${salutation}=${EMPTY}      ${first_name}=${EMPTY}    ${phone}=${EMPTY}           ${title}=${EMPTY}           ${email}=${EMPTY}           ${website}=${EMPTY}         ${lead_source}=${EMPTY}
    Launch App                  Sales
    ClickText                   Leads
    VerifyText                  Recently Viewed             timeout=120s
    Wait Until Keyword Succeeds                             1 min                       5 sec                  ClickText                   ${first_name} ${last_name}
    ClickText                   Details                     anchor=Activity
    Log Many                    ${salutation}               ${first_name}               ${last_name}
    ${full_name}=               Catenate                    ${salutation}               ${first_name}          ${last_name}
    Log                         ${full_name}
    VerifyText                  ${full_name}                anchor=Details
    VerifyText                  ${title}                    anchor=Details
    VerifyText                  ${phone}                    anchor=Lead Status
    VerifyField                 Company                     ${company}
    VerifyField                 Website                     ${website}
    Log Screenshot

Delete Lead
    [Arguments]                 ${first_name}               ${last_name}
    Launch App                  Sales
    ClickText                   Leads
    VerifyText                  Recently Viewed             timeout=120s
    Wait Until Keyword Succeeds                             1 min                       5 sec                  ClickText                   ${first_name} ${last_name}
    ClickText                   Delete
    ClickText                   Delete
    ClickText                   Close
    Log Screenshot

Unique Test Data
    ${Last_Name}=               Last Name
    Set Suite Variable          ${last_name}                ${Last Name}
    ${Company}=                 Company
    Set Suite Variable          ${company}                  ${Company}
    ${First_Name}=              First Name
    Set Suite Variable          ${first_name}               ${First_Name}
    ${Salutation}=              Suffix Female
    Set Suite Variable          ${salutation}               ${Salutation}      