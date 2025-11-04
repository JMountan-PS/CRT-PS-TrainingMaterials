*** Settings ***
###############################################################################
# LIBRARY IMPORTS
###############################################################################
# ExcelLibrary: Provides keywords for reading and writing Excel files (.xlsx)
# Documentation: https://github.com/peterservice-rnd/robotframework-excellib
Library           ExcelLibrary

# Collections: Provides keywords for working with lists and dictionaries
# Built-in Robot Framework library for data structure manipulation
Library           Collections
Library            OperatingSystem


*** Variables ***
###############################################################################
# CONFIGURATION VARIABLES
###############################################################################

# ${EXECDIR} is a built-in Robot Framework variable that contains the absolute
# path to the directory where the executing test suite file is located.
# 
# Example: If the executing file is at /home/user/tests/suite.robot
#          then ${EXECDIR} = /home/user/tests
#          and ${EXECDIR}/../testdata = /home/user/testdata
${EXCEL_FILE}        ${EXECDIR}/../testdata/BulkLeadData.xlsx

# The name of the worksheet/sheet within the Excel file to read from.
# Excel files can contain multiple sheets - this specifies which one to use.
${SHEET_NAME}        BulkLeadData

# Safety limit: Maximum number of rows to process before stopping.
# This prevents infinite loops if the empty row detection fails.
# Adjust this value based on your expected data size.
${MAX_ROWS}          1000

# Row number where the column headers are located.
# In most Excel files, row 1 contains the field names (headers).
# Note: Excel row numbering starts at 1, not 0.
${HEADER_ROW}        1

# Row number where the actual data begins.
# Typically row 2, since row 1 contains headers.
${DATA_START_ROW}    2


*** Keywords ***
###############################################################################
# MAIN DATA LOADING KEYWORD
###############################################################################

Load Lead Test Data From Excel
    ###########################################################################
    # KEYWORD DOCUMENTATION
    ###########################################################################
    [Documentation]    Loads lead test data from an Excel file into a list of dictionaries.
    ...                
    ...                *Purpose:*
    ...                This keyword transforms Excel spreadsheet data into a Robot Framework
    ...                data structure that's easy to work with in tests. Each row becomes a
    ...                dictionary, and all rows are collected into a list.
    ...                
    ...                *How it works:*
    ...                1. Opens the Excel file
    ...                2. Reads the header row to get field names
    ...                3. Reads each data row and creates a dictionary
    ...                4. Maps cell values to their corresponding header names
    ...                5. Returns a list of all lead dictionaries
    ...                
    ...                *Excel File Structure Expected:*
    ...                | first_name | last_name | company    | lead_status |
    ...                | John       | Doe       | Acme Corp  | Working     |
    ...                | Jane       | Smith     | Tech Inc   | New         |
    ...                
    ...                *Returns:*
    ...                List of dictionaries. Each dictionary represents one lead with
    ...                header names as keys and cell values as values.
    ...                
    ...                Example return value:
    ...                [
    ...                    {'first_name': 'John', 'last_name': 'Doe', 'company': 'Acme Corp', 'lead_status': 'Working'},
    ...                    {'first_name': 'Jane', 'last_name': 'Smith', 'company': 'Tech Inc', 'lead_status': 'New'}
    ...                ]
    ...                
    ...                *Usage Example:*
    ...                | @{leads}= | Load Lead Test Data From Excel |
    ...                | ${count}= | Get Length | ${leads} |
    ...                | Log | Loaded ${count} leads |
    ...                | FOR | &{lead} | IN | @{leads} |
    ...                |     Log | Processing: ${lead}[first_name] ${lead}[last_name] |
    ...                |     Log | Company: ${lead}[company] |
    ...                | END |
    
    ###########################################################################
    # STEP 1: OPEN THE EXCEL FILE
    ###########################################################################
    # The 'Open Excel Document' keyword from ExcelLibrary opens the file
    # and assigns it a document ID ('LeadData') so we can reference it later.
    # This is useful when working with multiple Excel files simultaneously.
    Open Excel Document    filename=${EXCEL_FILE}    doc_id=LeadData
    
    # Log the file path for debugging purposes
    # This appears in the Robot Framework log file
    Log    Opened Excel file: ${EXCEL_FILE}

    ###########################################################################
    # STEP 2: READ THE HEADER ROW
    ###########################################################################
    # The header row contains the column names (field names) that will become
    # the keys in our dictionaries. For example: first_name, last_name, company
    #
    # 'Read Excel Row' returns a list of cell values from the specified row.
    # The '@' prefix creates a list variable that can hold multiple values.
    @{header_row}=    Read Excel Row    
    ...    row_num=${HEADER_ROW}    
    ...    sheet_name=${SHEET_NAME}
    
    # Example: If row 1 contains: | first_name | last_name | company |
    # Then @{header_row} = ['first_name', 'last_name', 'company']
    
    ###########################################################################
    # STEP 3: CACHE THE COLUMN COUNT
    ###########################################################################
    # We calculate the number of columns once and store it in a variable.
    # This is more efficient than calling 'Get Length' repeatedly in loops.
    ${column_count}=    Get Length    ${header_row}
    
    # Log the column count for debugging
    Log    Found ${column_count} columns in header row
    
    ###########################################################################
    # STEP 4: INITIALIZE THE RESULT LIST
    ###########################################################################
    # Create an empty list that will store all the lead dictionaries.
    # As we process each row, we'll append a new dictionary to this list.
    @{lead_list}=    Create List
    
    ###########################################################################
    # STEP 5: SET THE STARTING ROW
    ###########################################################################
    # We start reading data from row 2 because row 1 contains headers.
    # This variable will be incremented as we process each row.
    ${current_row}=    Set Variable    ${DATA_START_ROW}
    
    ###########################################################################
    # STEP 6: MAIN PROCESSING LOOP - READ ALL DATA ROWS
    ###########################################################################
    # This FOR loop iterates up to MAX_ROWS times (10,000 by default).
    # We use a large range as a safety net, but we'll exit early when we
    # encounter an empty row (which indicates the end of data).
    FOR    ${index}    IN RANGE    ${MAX_ROWS}
        
        #######################################################################
        # STEP 6A: CHECK IF CURRENT ROW IS EMPTY
        #######################################################################
        # Read the first cell of the current row to determine if there's data.
        # If the first cell is empty, we assume the entire row is empty and
        # we've reached the end of the data.
        ${first_cell_value}=    Read Excel Cell    
        ...    row_num=${current_row}    
        ...    col_num=1    
        ...    sheet_name=${SHEET_NAME}
        
        # ExcelLibrary returns the string 'None' for empty cells.
        # We check for both 'None' and empty string '' to be safe.
        # If either condition is true, we exit the FOR loop.
        Exit For Loop If    '${first_cell_value}' == 'None' or '${first_cell_value}' == ''
        
        #######################################################################
        # STEP 6B: READ THE ENTIRE CURRENT ROW
        #######################################################################
        # Now that we know the row has data, read all cells in the row.
        # This returns a list of values, one for each column.
        @{current_row_data}=    Read Excel Row    
        ...    row_num=${current_row}    
        ...    sheet_name=${SHEET_NAME}
        
        # Example: If row 2 contains: | John | Doe | Acme Corp | Working |
        # Then @{current_row_data} = ['John', 'Doe', 'Acme Corp', 'Working']
        
        #######################################################################
        # STEP 6C: CREATE A DICTIONARY FOR THIS LEAD
        #######################################################################
        # Create an empty dictionary that will store this lead's data.
        # The '&' prefix indicates a dictionary variable (key-value pairs).
        &{lead_dictionary}=    Create Dictionary
        
        #######################################################################
        # STEP 6D: MAP CELL VALUES TO HEADER NAMES
        #######################################################################
        # This inner FOR loop processes each column in the current row.
        # It pairs each cell value with its corresponding header name.
        FOR    ${column_index}    IN RANGE    ${column_count}
            
            # Get the header name for this column position
            # Example: column_index=0 → header_name='first_name'
            ${header_name}=    Get From List    ${header_row}         ${column_index}
            
            # Get the cell value for this column position in the current row
            # Example: column_index=0 → cell_value='John'
            ${cell_value}=     Get From List    ${current_row_data}   ${column_index}
            
            ###################################################################
            # STEP 6E: HANDLE EMPTY CELLS
            ###################################################################
            # ExcelLibrary returns the string 'None' for empty cells.
            # We convert this to Robot Framework's ${EMPTY} variable for
            # consistency and easier handling in tests.
            #
            # 'Set Variable If' syntax:
            #   Set Variable If    <condition>    <value_if_true>    <value_if_false>
            ${cell_value}=    Set Variable If    
            ...    '${cell_value}' == 'None'    
            ...    ${EMPTY}    
            ...    ${cell_value}
            
            ###################################################################
            # STEP 6F: ADD THE FIELD TO THE DICTIONARY
            ###################################################################
            # Add this key-value pair to the lead dictionary.
            # Example: If header_name='first_name' and cell_value='John'
            #          Then lead_dictionary['first_name'] = 'John'
            Set To Dictionary    ${lead_dictionary}    ${header_name}=${cell_value}
        END
        # End of column processing loop
        
        # At this point, ${lead_dictionary} contains all fields for one lead:
        # {'first_name': 'John', 'last_name': 'Doe', 'company': 'Acme Corp', ...}
        
        #######################################################################
        # STEP 6G: ADD THE LEAD DICTIONARY TO THE RESULT LIST
        #######################################################################
        # Append the completed dictionary to our list of all leads
        Append To List    ${lead_list}    ${lead_dictionary}
        
        #######################################################################
        # STEP 6H: MOVE TO THE NEXT ROW
        #######################################################################
        # Increment the row counter to process the next row in the next iteration
        # 'Evaluate' allows us to perform Python expressions
        ${current_row}=    Evaluate    ${current_row} + 1
    END
    # End of row processing loop
    
    ###########################################################################
    # STEP 7: CLOSE THE EXCEL FILE
    ###########################################################################
    # Close the Excel document to free up system resources.
    # This is important when processing multiple files or large datasets.
    Close Current Excel Document
    Log    Closed Excel document
    
    ###########################################################################
    # STEP 8: LOG THE RESULTS
    ###########################################################################
    # Count how many lead records were successfully loaded
    ${total_records}=    Get Length    ${lead_list}
    
    # Log the count for visibility in test reports
    Log    Successfully loaded ${total_records} lead records from Excel
    
    ###########################################################################
    # STEP 9: RETURN THE RESULT
    ###########################################################################
    # Return the list of lead dictionaries to the calling test or keyword.
    # The '@' prefix unpacks the list so it can be assigned to a list variable.
    [Return]    @{lead_list}


###############################################################################
# EXAMPLE TEST CASES
###############################################################################

*** Test Cases ***

Example 1: Basic Data Loading
    [Documentation]    Demonstrates the simplest way to load and verify Excel data
    
    List Directory     ${EXECDIR}

    # Load all leads from the Excel file
    @{all_leads}=    Load Lead Test Data From Excel
    
    # Verify that we loaded some data
    ${count}=    Get Length    ${all_leads}
    Should Be True    ${count} > 0    msg=No leads were loaded from Excel
    
    # Log the count to the console
    Log To Console    \nSuccessfully loaded ${count} lead records


Example 2: Accessing Individual Lead Data
    [Documentation]    Shows how to access specific fields from a lead dictionary
    
    # Load all leads
    @{all_leads}=    Load Lead Test Data From Excel
    
    # Get the first lead from the list (index 0)
    &{first_lead}=    Get From List    ${all_leads}    0
    
    # Access individual fields using dictionary syntax: ${dict}[key]
    Log To Console    \nFirst Lead Details:
    Log To Console    Name: ${first_lead}[first_name] ${first_lead}[last_name]
    Log To Console    Company: ${first_lead}[company]
    Log To Console    Status: ${first_lead}[lead_status]


Example 3: Iterating Through All Leads
    [Documentation]    Demonstrates how to process each lead in a loop
    
    # Load all leads
    @{all_leads}=    Load Lead Test Data From Excel
    
    # Loop through each lead dictionary
    # The '&{lead}' syntax unpacks each dictionary from the list
    FOR    ${lead}    IN    @{all_leads}
        # Access fields directly using ${lead}[field_name]
        Log To Console    Processing: ${lead}[first_name] ${lead}[last_name]
        Log To Console    Company: ${lead}[company]
        Log To Console    Status: ${lead}[lead_status]
        Log To Console    ---
    END


Example 4: Data-Driven Testing
    [Documentation]    Use Excel data to drive multiple test executions
    
    # Load all leads
    @{all_leads}=    Load Lead Test Data From Excel
    
    # Execute a test for each lead
    FOR    ${lead}    IN    @{all_leads}
        # Call a keyword that performs the actual test
        # Pass the entire dictionary using &{lead} syntax
        Process Single Lead    &{lead}
    END


Example 5: Filtering Data
    [Documentation]    Shows how to filter leads based on criteria
    
    # Load all leads
    @{all_leads}=    Load Lead Test Data From Excel
    
    # Create an empty list for filtered results
    @{working_leads}=    Create List
    
    # Filter leads with 'Working' status
    FOR    ${lead}    IN    @{all_leads}
        # Check if the lead_status field equals 'Working'
        ${is_working}=    Evaluate    '${lead}[lead_status]' == 'Working'
        
        # If true, add this lead to the filtered list
        Run Keyword If    ${is_working}
        ...    Append To List    ${working_leads}    ${lead}
    END
    
    # Log how many working leads were found
    ${count}=    Get Length    ${working_leads}
    Log To Console    \nFound ${count} leads with 'Working' status


Example 6: Extracting Values to Variables
    [Documentation]    Shows how to extract dictionary values into separate variables
    
    # Load all leads
    @{all_leads}=    Load Lead Test Data From Excel
    
    # Get the first lead
    &{lead}=    Get From List    ${all_leads}    0
    
    # Extract specific fields into individual variables
    # The 'default' parameter provides a fallback value if the key doesn't exist
    ${first_name}=     Get From Dictionary    ${lead}    first_name
    ${last_name}=      Get From Dictionary    ${lead}    last_name
    ${company}=        Get From Dictionary    ${lead}    company
    ${phone}=          Get From Dictionary    ${lead}    phone          default=${EMPTY}
    ${email}=          Get From Dictionary    ${lead}    email          default=${EMPTY}
    
    # Now you can use these variables individually
    Log To Console    \nExtracted Variables:
    Log To Console    First Name: ${first_name}
    Log To Console    Last Name: ${last_name}
    Log To Console    Company: ${company}
    Log To Console    Phone: ${phone}
    Log To Console    Email: ${email}


*** Keywords ***

Process Single Lead
    [Documentation]    Example keyword that processes a single lead
    ...                This would contain your actual test logic
    [Arguments]       &{lead}
    
    # Extract the values you need
    ${first_name}=    Get From Dictionary    ${lead}    first_name
    ${last_name}=     Get From Dictionary    ${lead}    last_name
    ${company}=       Get From Dictionary    ${lead}    company
    
    # Perform your test actions here
    Log    Processing lead: ${first_name} ${last_name} from ${company}
    
    # Example: You might call your existing keywords here
    # Enter a Lead    ${lead}[lead_status]    ${last_name}    ${company}    ...
    # Verify Lead Created    ${first_name}    ${last_name}
    # Delete a Lead    ${first_name}    ${last_name}


###############################################################################
# TROUBLESHOOTING GUIDE
###############################################################################
# 
# Common Issues and Solutions:
# 
# 1. "No leads were loaded" or empty list returned
#    - Check that ${EXCEL_FILE} path is correct
#    - Verify ${SHEET_NAME} matches the actual sheet name in Excel
#    - Ensure row 1 contains headers and row 2+ contains data
#    - Check that the first column has data (used for empty row detection)
# 
# 2. "KeyError" when accessing dictionary fields
#    - Verify the header names in Excel match what you're using in code
#    - Check for extra spaces in header names
#    - Use 'Get From Dictionary' with 'default' parameter for optional fields
# 
# 3. Getting 'None' values instead of empty strings
#    - The keyword already handles this, but if you see 'None', check that
#      the conversion logic is working (Step 6E in the code)
# 
# 4. Loop runs too long or times out
#    - Reduce ${MAX_ROWS} if you have a smaller dataset
#    - Verify that empty row detection is working (check first column has data)
# 
# 5. "File not found" error
#    - Verify the file exists at ${CURDIR}/../testdata/leadsDataScrubbed.xlsx
#    - Check file permissions (must be readable)
#    - Ensure the file is not open in Excel (may cause locking issues)
# 
###############################################################################