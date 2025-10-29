*** Settings ***
Resource                        ../resources/common.robot
Suite Setup                     Setup Browser
Suite Teardown                  Close All Browser Sessions

# In this exercise we use the same salesforce scenario built with exercise 6.

*** Test Cases ***

Exercise 12 - Custom Keywords - Step 1 Grouping
    # At this point the test data in the custom keywords are fixed.
    Appstate                    Home
    Create Lead Step 1 Grouping
    Verify Lead Step 1 Grouping
    Delete Lead Step 1 Grouping

Exercise 12 - Custom Keywords - Step 2 Replace values with arguments
    # At this point the test data in the custom keywords are variables
    Appstate                    Home
    Create Lead Step 2 Replace values with arguments      lead_status=Working         last_name=Smith        company=Growmore            salutation=Ms.            first_name=Tina          phone=+12234567858449       title=Manager               email=tina.smith@gmail.com                              website=https://www.growmore.com/    lead_source=Advertisement
    Verify Lead Step 2 Replace values with arguments      last_name=Smith             salutation=Ms.         first_name=Tina             company=Growmore          phone=+12234567858449    title=Manager               website=https://www.growmore.com/
    Delete Lead Step 2 Replace values with arguments      last_name=Smith             first_name=Tina

*** Keywords ***

##############################################################################################################################
# Step 1 - Group keywords in Custom Keywords
##############################################################################################################################

Create Lead Step 1 Grouping
    Launch App                  Sales
    ClickText                   Leads
    VerifyText                  Recently Viewed             timeout=120s
    ClickText                   New                         anchor=Import
    VerifyText                  Lead Information
    UseModal                    On                          # Only find fields from open modal dialog
    Picklist                    Salutation                  Ms.                         #optional
    TypeText                    First Name                  Tina                        #optional
    TypeText                    Last Name                   Smith                       #mandatory
    Picklist                    Lead Status                 Working                     #mandatory
    TypeText                    Phone                       +12234567858449             First Name             #optional
    TypeText                    Company                     Growmore                    Industry               #mandatory
    TypeText                    Title                       Manager                     Address Information    #optional
    TypeText                    Email                       tina.smith@gmail.com        Rating                 #optional
    TypeText                    Website                     https://www.growmore.com/                          #optional
    Picklist                    Lead Source                 Advertisement               #optional
    ClickText                   Save                        partial_match=False
    UseModal                    Off
    Sleep                       2

Verify Lead Step 1 Grouping
    Launch App                  Sales
    ClickText                   Leads
    VerifyText                  Recently Viewed             timeout=120s
    Wait Until Keyword Succeeds                             1 min                       5 sec                  ClickText                   Tina Smith 
    ClickText                   Details                     anchor=Activity
    VerifyText                  Ms. Tina Smith              anchor=Details
    VerifyText                  Manager                     anchor=Details
    VerifyText                  +12234567858449             anchor=Lead Status
    VerifyField                 Company                     Growmore
    VerifyField                 Website                     https://www.growmore.com/
    Log Screenshot

Delete Lead Step 1 Grouping
    Launch App                  Sales
    ClickText                   Leads
    VerifyText                  Recently Viewed             timeout=120s  
    Wait Until Keyword Succeeds                             1 min                       5 sec                  ClickText                   Tina Smith
    ClickText                   Delete
    ClickText                   Delete
    ClickText                   Close
    Log Screenshot

##############################################################################################################################
# Step 2 - Update Custom Keywords with arguments, making them generic for different test data, re-usable keywords
##############################################################################################################################

Create Lead Step 2 Replace values with arguments 
    [Arguments]                 ${lead_status}              ${last_name}                ${company}             ${salutation}=${EMPTY}      ${first_name}=${EMPTY}    ${phone}=${EMPTY}        ${title}=${EMPTY}           ${email}=${EMPTY}           ${website}=${EMPTY}         ${lead_source}=${EMPTY}
    Launch App                  Sales
    ClickText                   Leads
    VerifyText                  Recently Viewed             timeout=120s
    ClickText                   New                         anchor=Import
    VerifyText                  Lead Information
    UseModal                    On                          # Only find fields from open modal dialog
    Run Keyword If              '${salutation}'!='${EMPTY}'                             Picklist               Salutation                  ${salutation}                       #optional
    Run Keyword If              '${first_name}'!='${EMPTY}'                             TypeText               First Name                  ${first_name}                      #optional
    TypeText                    Last Name                   ${last_name}                #mandatory
    Picklist                    Lead Status                 ${lead_status}              #mandatory
    Run Keyword If              '${phone}'!='${EMPTY}'      TypeText                    Phone                  ${phone}             First Name                #optional
    TypeText                    Company                     ${company}                  Last Name              #mandatory
    Run Keyword If              '${title}'!='${EMPTY}'      TypeText                    Title                  ${title}                     Address Information       #optional
    Run Keyword If              '${email}'!='${EMPTY}'      TypeText                    Email                  tina.smith@gmail.com        Rating                    #optional
    Run Keyword If              '${website}'!='${EMPTY}'    TypeText                    Website                https://www.growmore.com/                             #optional
    Run Keyword If              '${lead_source}'!='${EMPTY}'                            Picklist               Lead Source                 Advertisement             #optional
    ClickText                   Save                        partial_match=False
    UseModal                    Off
    Sleep                       2

Verify Lead Step 2 Replace values with arguments
    [Arguments]                 ${lead_status}=${EMPTY}     ${last_name}=${EMPTY}       ${company}=${EMPTY}    ${salutation}=${EMPTY}      ${first_name}=${EMPTY}    ${phone}=${EMPTY}        ${title}=${EMPTY}           ${email}=${EMPTY}           ${website}=${EMPTY}         ${lead_source}=${EMPTY}
    Launch App                  Sales
    ClickText                   Leads
    VerifyText                  Recently Viewed             timeout=120s
    Wait Until Keyword Succeeds                             1 min                       5 sec                  ClickText                   ${first_name} ${last_name}
    ClickText                   Details                     anchor=Activity
    ${full_name}=               Catenate                    ${salutation}               ${first_name}          ${last_name}
    VerifyText                  ${full_name}                anchor=Details
    VerifyText                  ${title}                    anchor=Details
    VerifyText                  ${phone}                    anchor=Lead Status
    VerifyField                 Company                     ${company}
    VerifyField                 Website                     ${website}
    Log Screenshot

Delete Lead Step 2 Replace values with arguments
    [Arguments]                 ${first_name}               ${last_name}
    Launch App                  Sales
    ClickText                   Leads
    VerifyText                  Recently Viewed             timeout=120s
    Wait Until Keyword Succeeds                             1 min                       5 sec                  ClickText                   ${first_name} ${last_name}
    ClickText                   Delete
    ClickText                   Delete
    ClickText                   Close
    Log Screenshot
