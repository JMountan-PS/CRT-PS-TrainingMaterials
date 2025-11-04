*** Settings ***
Resource    ../resources/common.resource
Resource    ../resources/excelLoad.resource
Resource    ../resources/excelWrite.resource

*** Variables ***
${excel-path}        ${CURDIR}/../testdata/BulkLeadData.xlsx

*** Test Cases ***
Open Existing excel and write to it via single cell

    # First load and output excel data that currently exists
    @{all_leads}=    Load Lead Test Data From Excel

    #Open Excel for Writing 
    Open Existing Excel Document-copado    ${excel-path}    LeadsData
    
    # Get the first lead from the list (index 0)
    &{first_lead}=    Get From List    ${all_leads}    0
    
    # Access individual fields using dictionary syntax: ${dict}[key]
    Log To Console    \nFirst Lead Details:
    Log To Console    Name: ${first_lead}[first_name] ${first_lead}[last_name]
    Log To Console    Company: ${first_lead}[company]
    Log To Console    Status: ${first_lead}[lead_status]

    #Use write single cell to update first row from Sarah Johnson -> Jim Smith
    Write Single Cell-copado               1                4    Jim
    Write Single Cell-copado               1                2    Smith
    
    Save Excel Document-copado             ${excel-path}

    #Load and output excel data that currently exists
    @{all_leads}=    Load Lead Test Data From Excel
    
    # Get the first lead from the list (index 0)
    &{first_lead}=    Get From List    ${all_leads}    0
    
    # Access individual fields using dictionary syntax: ${dict}[key]
    Log To Console    \nFirst Lead Details:
    Log To Console    Name: ${first_lead}[first_name] ${first_lead}[last_name]
    Log To Console    Company: ${first_lead}[company]
    Log To Console    Status: ${first_lead}[lead_status]
    