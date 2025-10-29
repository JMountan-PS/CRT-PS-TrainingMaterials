*** Settings ***
Library           ExcelLibrary
Library           Collections
Resource          ../resources/Sales/leads.resource

*** Variables ***
${EXCEL_FILE}     ${CURDIR}/../testdata/leadsDataScrubbed.xlsx

*** Keywords ***
Load Lead Test Data From Excel
    [Documentation]    Loads lead test data from Excel file into a list of dictionaries.
    ...                Each dictionary represents one lead with all field values.
    [Arguments]       ${sheet_name}=leadsDataScrubbed
    
    # Open the Excel file
    Open Excel Document    filename=${EXCEL_FILE}    doc_id=LeadData
    
    # Get the header row (row 1)
    @{headers}=    Read Excel Row    row_num=1    sheet_name=${sheet_name}
    
    # Initialize empty list to store lead dictionaries
    @{lead_data_list}=    Create List
    
    # Read data starting from row 2 (skip header)
    ${row_num}=    Set Variable    2
    
    # Loop through all data rows until we hit an empty row
    FOR    ${i}    IN RANGE    999999
        ${current_row}=    Set Variable    ${row_num}
        
        # Read the first cell to check if row is empty
        ${first_cell}=    Read Excel Cell    row_num=${current_row}    col_num=1    sheet_name=${sheet_name}
        
        # Exit loop if we hit an empty row
        Exit For Loop If    '${first_cell}' == 'None' or '${first_cell}' == ''
        
        # Read the entire row
        @{row_data}=    Read Excel Row    row_num=${current_row}    sheet_name=${sheet_name}
        
        # Create dictionary for this lead
        &{lead_dict}=    Create Dictionary
        
        # Map each column value to its header name
        ${col_count}=    Get Length    ${headers}
        FOR    ${col_index}    IN RANGE    ${col_count}
            ${field_name}=     Get From List    ${headers}       ${col_index}
            ${field_value}=    Get From List    ${row_data}      ${col_index}
            
            # Convert None to empty string
            ${field_value}=    Set Variable If    '${field_value}' == 'None'    ${EMPTY}    ${field_value}
            
            Set To Dictionary    ${lead_dict}    ${field_name}=${field_value}
        END
        
        # Add this lead dictionary to the list
        Append To List    ${lead_data_list}    ${lead_dict}
        
        # Increment row counter
        ${row_num}=    Evaluate    ${row_num} + 1
    END
    
    # Close the Excel document
    Close Current Excel Document
    
    ${count}=    Get Length    ${lead_data_list}
    Log    Loaded ${count} lead records from Excel
    
    [Return]    @{lead_data_list}


Load Lead Test Data From Excel With Max Rows
    [Documentation]    Loads lead test data with a specified maximum number of rows.
    ...                More efficient when you know the data size.
    [Arguments]       ${max_rows}=100    ${sheet_name}=Sheet1
    
    # Open the Excel file
    Open Excel Document    filename=${EXCEL_FILE}    doc_id=LeadData
    
    # Get the header row (row 1)
    @{headers}=    Read Excel Row    row_num=1    sheet_name=${sheet_name}
    
    # Initialize empty list to store lead dictionaries
    @{lead_data_list}=    Create List
    
    # Read data rows (starting from row 2)
    FOR    ${row_num}    IN RANGE    2    ${max_rows + 2}
        # Read the entire row
        @{row_data}=    Read Excel Row    row_num=${row_num}    sheet_name=${sheet_name}
        
        # Check if first cell is empty (end of data)
        ${first_cell}=    Get From List    ${row_data}    0
        Exit For Loop If    '${first_cell}' == 'None' or '${first_cell}' == ''
        
        # Create dictionary for this lead
        &{lead_dict}=    Create Dictionary
        
        # Map each column value to its header name
        ${col_count}=    Get Length    ${headers}
        FOR    ${col_index}    IN RANGE    ${col_count}
            ${field_name}=     Get From List    ${headers}       ${col_index}
            ${field_value}=    Get From List    ${row_data}      ${col_index}
            
            # Convert None to empty string
            ${field_value}=    Set Variable If    '${field_value}' == 'None'    ${EMPTY}    ${field_value}
            
            Set To Dictionary    ${lead_dict}    ${field_name}=${field_value}
        END
        
        # Add this lead dictionary to the list
        Append To List    ${lead_data_list}    ${lead_dict}
    END
    
    # Close the Excel document
    Close Current Excel Document
    
    ${count}=    Get Length    ${lead_data_list}
    Log    Loaded ${count} lead records from Excel
    
    [Return]    @{lead_data_list}


*** Test Cases ***
Example: Load and Use Excel Data
    [Documentation]    Demonstrates loading Excel data and iterating through it
    
    # Load all lead data into a list of dictionaries
    @{all_leads}=    Load Lead Test Data From Excel
    
    # Log how many records were loaded
    ${record_count}=    Get Length    ${all_leads}
    Log To Console    \nLoaded ${record_count} lead records
    
    # Example: Access first lead's data
    &{first_lead}=    Get From List    ${all_leads}    0
    Log To Console    First Lead: ${first_lead}[first_name] ${first_lead}[last_name]
    Log To Console    Company: ${first_lead}[company]
    Log To Console    Status: ${first_lead}[lead_status]
    
    # Example: Iterate through all leads
    FOR    ${lead}    IN    @{all_leads}
        Log To Console    Processing: ${lead}[first_name] ${lead}[last_name] - ${lead}[company]
    END


Example: Load With Max Rows
    [Documentation]    Load only first 20 records for faster execution
    
    @{leads}=    Load Lead Test Data From Excel With Max Rows    max_rows=20
    
    ${count}=    Get Length    ${leads}
    Log To Console    \nLoaded ${count} leads (max 20)


Example: Data-Driven Test Using Excel
    [Documentation]    Use Excel data to drive multiple test executions
    
    @{leads}=    Load Lead Test Data From Excel
    
    FOR    &{lead}    IN    @{leads}
        Create Verify and Delete Lead From Dictionary    &{lead}
    END


Example: Filter Specific Leads
    [Documentation]    Load all leads then filter by status
    
    @{all_leads}=    Load Lead Test Data From Excel
    @{working_leads}=    Create List
    
    # Filter only "Working" status leads
    FOR    &{lead}    IN    @{all_leads}
        Run Keyword If    '${lead}[lead_status]' == 'Working'
        ...    Append To List    ${working_leads}    ${lead}
    END
    
    ${count}=    Get Length    ${working_leads}
    Log To Console    \nFound ${count} leads with 'Working' status


*** Keywords ***
Create Verify and Delete Lead From Dictionary
    [Documentation]    Accepts a dictionary with lead data and executes the test
    [Arguments]       &{lead}
    
    # Extract values from dictionary with default empty strings
    ${lead_status}=     Get From Dictionary    ${lead}    lead_status
    ${last_name}=       Get From Dictionary    ${lead}    last_name
    ${company}=         Get From Dictionary    ${lead}    company
    ${first_name}=      Get From Dictionary    ${lead}    first_name
    ${salutation}=      Get From Dictionary    ${lead}    salutation
    ${phone}=           Get From Dictionary    ${lead}    phone          default=${EMPTY}
    ${title}=           Get From Dictionary    ${lead}    title          default=${EMPTY}
    ${email}=           Get From Dictionary    ${lead}    email          default=${EMPTY}
    ${website}=         Get From Dictionary    ${lead}    website        default=${EMPTY}
    ${lead_source}=     Get From Dictionary    ${lead}    lead_source    default=${EMPTY}
    
    # Call your existing keyword with the extracted values
    Enter a Lead      ${lead_status}    ${last_name}    ${company}    ${salutation}    ${first_name}
    ...               ${phone}          ${title}        ${email}      ${website}       ${lead_source}
    Delete a Lead     ${first_name}     ${last_name}