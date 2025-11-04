*** Settings ***
###############################################################################
# RESOURCE FILE: Excel Write Operations
# PURPOSE: Provides reusable keywords for writing data to Excel spreadsheets
# DEPENDENCIES: ExcelLibrary, common.resource
###############################################################################
Resource                        common.resource
Library                         ExcelLibrary
Library                    OperatingSystem


*** Variables ***
###############################################################################
# CONFIGURATION VARIABLES
###############################################################################

# ${CURDIR} is a built-in Robot Framework variable that contains the absolute
# path to the directory where the current test suite file is located.
${EXCEL_OUTPUT_DIR}             ${CURDIR}/../../output

# Default sheet name for new Excel documents
${DEFAULT_SHEET_NAME}           Sheet1

# Safety limit: Maximum number of rows to write before stopping
${MAX_WRITE_ROWS}               10000

# Default starting positions for writing data
${DEFAULT_START_ROW}            1
${DEFAULT_START_COLUMN}         1


*** Keywords ***
###############################################################################
# EXCEL DOCUMENT MANAGEMENT KEYWORDS
###############################################################################

Create New Excel Document-copado
    ###########################################################################
    # KEYWORD DOCUMENTATION
    ###########################################################################
    [Documentation]    Creates a new Excel document and returns its identifier.
    ...
    ...                *Purpose:*
    ...                Initializes a new Excel workbook in memory that can be used
    ...                for writing test data, results, or reports.
    ...
    ...                *Arguments:*
    ...                - doc_id_copado: Unique identifier for the document in cache
    ...
    ...                *Returns:*
    ...                Document identifier that can be used to reference this document
    ...
    ...                *Usage Example:*
    ...                | ${doc}= | Create New Excel Document-copado | doc_id_copado=test_results |
    ...                | Write Single Cell-copado | row_num_copado=1 | col_num_copado=1 | value_copado=Test Name |
    ...                | Save Excel Document-copado | filename_copado=results.xlsx |
    ...                | Close Excel Document-copado | doc_id_copado=${doc} |
    
    [Arguments]                 ${doc_id_copado}
    [Tags]                      excel    document-management    creation
    
    ${document_id}=             Create Excel Document    doc_id=${doc_id_copado}
    Log To Console              Created Excel document with ID: ${doc_id_copado}
    
    [Return]                    ${document_id}


Open Existing Excel Document-copado
    ###########################################################################
    # KEYWORD DOCUMENTATION
    ###########################################################################
    [Documentation]    Opens an existing Excel document from disk.
    ...
    ...                *Purpose:*
    ...                Loads an existing Excel file into memory for reading or modification.
    ...
    ...                *Arguments:*
    ...                - filename_copado: Path to the Excel file to open
    ...                - doc_id_copado: Unique identifier for the document in cache
    ...
    ...                *Returns:*
    ...                Document identifier that can be used to reference this document
    ...
    ...                *Usage Example:*
    ...                | ${doc}= | Open Existing Excel Document-copado | filename_copado=data.xlsx | doc_id_copado=my_doc |
    ...                | ${value}= | Read Single Cell-copado | row_num_copado=1 | col_num_copado=1 |
    ...                | Close Excel Document-copado | doc_id_copado=${doc} |
    
    [Arguments]                 ${filename_copado}    ${doc_id_copado}
    [Tags]                      excel    document-management    file-operations
    
    ${document_id}=             Open Excel Document    filename=${filename_copado}    doc_id=${doc_id_copado}
    Log To Console              Opened Excel document: ${filename_copado} with ID: ${doc_id_copado}
    
    [Return]                    ${document_id}


Save Excel Document-copado
    ###########################################################################
    # KEYWORD DOCUMENTATION
    ###########################################################################
    [Documentation]    Saves the current Excel document to disk.
    ...
    ...                *Purpose:*
    ...                Persists the in-memory Excel document to a file on disk.
    ...
    ...                *Arguments:*
    ...                - filename_copado: Path where the file should be saved
    ...
    ...                *Usage Example:*
    ...                | Create New Excel Document-copado | doc_id_copado=report |
    ...                | Write Single Cell-copado | row_num_copado=1 | col_num_copado=1 | value_copado=Report Title |
    ...                | Save Excel Document-copado | filename_copado=${EXCEL_OUTPUT_DIR}/report.xlsx |
    
    [Arguments]                 ${filename_copado}
    [Tags]                      excel    document-management    file-operations
    
    Save Excel Document         filename=${filename_copado}
    Log To Console              Saved Excel document to: ${filename_copado}


Close Excel Document-copado
    ###########################################################################
    # KEYWORD DOCUMENTATION
    ###########################################################################
    [Documentation]    Closes a specific Excel document.
    ...
    ...                *Purpose:*
    ...                Removes the specified document from memory cache.
    ...
    ...                *Arguments:*
    ...                - doc_id_copado: Identifier of the document to close
    ...
    ...                *Usage Example:*
    ...                | ${doc}= | Create New Excel Document-copado | doc_id_copado=temp |
    ...                | # ... perform operations ...
    ...                | Close Excel Document-copado | doc_id_copado=${doc} |
    
    [Arguments]                 ${doc_id_copado}
    [Tags]                      excel    document-management    cleanup
    
    Switch Current Excel Document    doc_id=${doc_id_copado}
    Close Current Excel Document
    Log To Console              Closed Excel document with ID: ${doc_id_copado}


Close All Excel Documents-copado
    ###########################################################################
    # KEYWORD DOCUMENTATION
    ###########################################################################
    [Documentation]    Closes all open Excel documents.
    ...
    ...                *Purpose:*
    ...                Cleanup keyword to close all Excel documents in memory.
    ...                Useful in Suite Teardown or error handling.
    ...
    ...                *Usage Example:*
    ...                | [Teardown] | Close All Excel Documents-copado |
    
    [Tags]                      excel    document-management    cleanup
    
    Close All Excel Documents
    Log To Console              Closed all Excel documents


###############################################################################
# SINGLE CELL WRITE KEYWORDS
###############################################################################

Write Single Cell-copado
    ###########################################################################
    # KEYWORD DOCUMENTATION
    ###########################################################################
    [Documentation]    Writes a value to a specific cell in the Excel document.
    ...
    ...                *Purpose:*
    ...                Writes data to a single cell identified by row and column numbers.
    ...
    ...                *Arguments:*
    ...                - row_num_copado: Row number (starts at 1)
    ...                - col_num_copado: Column number (starts at 1)
    ...                - value_copado: Value to write to the cell
    ...                - sheet_name_copado: (Optional) Sheet name to write to
    ...
    ...                *Usage Example:*
    ...                | Write Single Cell-copado | row_num_copado=1 | col_num_copado=1 | value_copado=Test Name |
    ...                | Write Single Cell-copado | row_num_copado=2 | col_num_copado=3 | value_copado=PASS | sheet_name_copado=Results |
    
    [Arguments]                 ${row_num_copado}    ${col_num_copado}    ${value_copado}    ${sheet_name_copado}=${None}
    [Tags]                      excel    write-operations    cell
    
    Write Excel Cell            row_num=${row_num_copado}    col_num=${col_num_copado}    value=${value_copado}    sheet_name=${sheet_name_copado}
    Log To Console              Wrote value '${value_copado}' to cell (${row_num_copado}, ${col_num_copado})


Write Cell By Reference-copado
    ###########################################################################
    # KEYWORD DOCUMENTATION
    ###########################################################################
    [Documentation]    Writes a value to a cell using Excel-style reference (e.g., A1, B2).
    ...
    ...                *Purpose:*
    ...                Provides an alternative way to write to cells using familiar
    ...                Excel notation instead of row/column numbers.
    ...
    ...                *Arguments:*
    ...                - cell_reference_copado: Excel-style cell reference (e.g., 'A1', 'B5', 'AA10')
    ...                - value_copado: Value to write to the cell
    ...                - sheet_name_copado: (Optional) Sheet name to write to
    ...
    ...                *Usage Example:*
    ...                | Write Cell By Reference-copado | cell_reference_copado=A1 | value_copado=Header |
    ...                | Write Cell By Reference-copado | cell_reference_copado=B5 | value_copado=100 | sheet_name_copado=Data |
    
    [Arguments]                 ${cell_reference_copado}    ${value_copado}    ${sheet_name_copado}=${None}
    [Tags]                      excel    write-operations    cell    reference
    
    ${row_copado}    ${col_copado}=    Convert Cell Reference To Numbers-copado    ${cell_reference_copado}
    Write Excel Cell            row_num=${row_copado}    col_num=${col_copado}    value=${value_copado}    sheet_name=${sheet_name_copado}
    Log To Console              Wrote value '${value_copado}' to cell ${cell_reference_copado}


###############################################################################
# ROW WRITE KEYWORDS
###############################################################################

Write Single Row-copado
    ###########################################################################
    # KEYWORD DOCUMENTATION
    ###########################################################################
    [Documentation]    Writes a list of values to a single row in the Excel document.
    ...
    ...                *Purpose:*
    ...                Writes multiple values horizontally across a row, starting from
    ...                a specified row number and optional column offset.
    ...
    ...                *Arguments:*
    ...                - row_num_copado: Row number to write to (starts at 1)
    ...                - row_data_copado: List of values to write
    ...                - col_offset_copado: (Optional) Number of columns to skip from start (default: 0)
    ...                - sheet_name_copado: (Optional) Sheet name to write to
    ...
    ...                *Usage Example:*
    ...                | @{headers}= | Create List | Name | Email | Status |
    ...                | Write Single Row-copado | row_num_copado=1 | row_data_copado=${headers} |
    ...                | @{data}= | Create List | John Doe | john@example.com | Active |
    ...                | Write Single Row-copado | row_num_copado=2 | row_data_copado=${data} | col_offset_copado=1 |
    
    [Arguments]                 ${row_num_copado}    ${row_data_copado}    ${col_offset_copado}=0    ${sheet_name_copado}=${None}
    [Tags]                      excel    write-operations    row
    
    Write Excel Row             row_num=${row_num_copado}    row_data=${row_data_copado}    col_offset=${col_offset_copado}    sheet_name=${sheet_name_copado}
    ${row_length}=              Get Length    ${row_data_copado}
    Log To Console              Wrote ${row_length} values to row ${row_num_copado}


Write Multiple Rows-copado
    ###########################################################################
    # KEYWORD DOCUMENTATION
    ###########################################################################
    [Documentation]    Writes multiple rows of data to the Excel document.
    ...
    ...                *Purpose:*
    ...                Efficiently writes a list of rows (where each row is a list of values)
    ...                to the Excel document starting from a specified position.
    ...
    ...                *Arguments:*
    ...                - rows_data_copado: List of lists, where each inner list represents a row
    ...                - rows_offset_copado: (Optional) Number of rows to skip from start (default: 0)
    ...                - col_offset_copado: (Optional) Number of columns to skip from start (default: 0)
    ...                - sheet_name_copado: (Optional) Sheet name to write to
    ...
    ...                *Usage Example:*
    ...                | @{row1}= | Create List | Name | Email | Status |
    ...                | @{row2}= | Create List | John | john@example.com | Active |
    ...                | @{row3}= | Create List | Jane | jane@example.com | Inactive |
    ...                | @{all_rows}= | Create List | ${row1} | ${row2} | ${row3} |
    ...                | Write Multiple Rows-copado | rows_data_copado=${all_rows} |
    
    [Arguments]                 ${rows_data_copado}    ${rows_offset_copado}=0    ${col_offset_copado}=0    ${sheet_name_copado}=${None}
    [Tags]                      excel    write-operations    row    bulk
    
    Write Excel Rows            rows_data=${rows_data_copado}    rows_offset=${rows_offset_copado}    col_offset=${col_offset_copado}    sheet_name=${sheet_name_copado}
    ${rows_count}=              Get Length    ${rows_data_copado}
    Log To Console              Wrote ${rows_count} rows to Excel document


###############################################################################
# COLUMN WRITE KEYWORDS
###############################################################################

Write Single Column-copado
    ###########################################################################
    # KEYWORD DOCUMENTATION
    ###########################################################################
    [Documentation]    Writes a list of values to a single column in the Excel document.
    ...
    ...                *Purpose:*
    ...                Writes multiple values vertically down a column, starting from
    ...                a specified column number and optional row offset.
    ...
    ...                *Arguments:*
    ...                - col_num_copado: Column number to write to (starts at 1)
    ...                - col_data_copado: List of values to write
    ...                - row_offset_copado: (Optional) Number of rows to skip from start (default: 0)
    ...                - sheet_name_copado: (Optional) Sheet name to write to
    ...
    ...                *Usage Example:*
    ...                | @{statuses}= | Create List | Active | Inactive | Pending |
    ...                | Write Single Column-copado | col_num_copado=3 | col_data_copado=${statuses} | row_offset_copado=1 |
    
    [Arguments]                 ${col_num_copado}    ${col_data_copado}    ${row_offset_copado}=0    ${sheet_name_copado}=${None}
    [Tags]                      excel    write-operations    column
    
    Write Excel Column          col_num=${col_num_copado}    col_data=${col_data_copado}    row_offset=${row_offset_copado}    sheet_name=${sheet_name_copado}
    ${col_length}=              Get Length    ${col_data_copado}
    Log To Console              Wrote ${col_length} values to column ${col_num_copado}


###############################################################################
# DICTIONARY-BASED WRITE KEYWORDS
###############################################################################

Write Dictionary As Row-copado
    ###########################################################################
    # KEYWORD DOCUMENTATION
    ###########################################################################
    [Documentation]    Writes a dictionary as a row, with keys as headers and values as data.
    ...
    ...                *Purpose:*
    ...                Converts a dictionary into a row format, useful for writing
    ...                structured data where keys represent column headers.
    ...
    ...                *Arguments:*
    ...                - row_num_copado: Row number to write to (starts at 1)
    ...                - data_dict_copado: Dictionary containing the data
    ...                - headers_copado: (Optional) List of keys in desired order. If not provided, uses dictionary keys
    ...                - sheet_name_copado: (Optional) Sheet name to write to
    ...
    ...                *Usage Example:*
    ...                | &{lead}= | Create Dictionary | first_name=John | last_name=Doe | company=Acme Corp |
    ...                | @{headers}= | Create List | first_name | last_name | company |
    ...                | Write Dictionary As Row-copado | row_num_copado=2 | data_dict_copado=${lead} | headers_copado=${headers} |
    
    [Arguments]                 ${row_num_copado}    ${data_dict_copado}    ${headers_copado}=${None}    ${sheet_name_copado}=${None}
    [Tags]                      excel    write-operations    row    dictionary
    
    # If headers not provided, use dictionary keys
    ${headers_to_use}=          Run Keyword If    ${headers_copado} == ${None}    Get Dictionary Keys    ${data_dict_copado}
    ...                         ELSE    Set Variable    ${headers_copado}
    
    # Build row data from dictionary using headers
    @{row_data}=                Create List
    FOR    ${header}    IN    @{headers_to_use}
        ${value}=               Get From Dictionary    ${data_dict_copado}    ${header}    default=${EMPTY}
        Append To List          ${row_data}    ${value}
    END
    
    Write Excel Row             row_num=${row_num_copado}    row_data=${row_data}    sheet_name=${sheet_name_copado}
    Log To Console              Wrote dictionary as row ${row_num_copado}


Write List Of Dictionaries-copado
    ###########################################################################
    # KEYWORD DOCUMENTATION
    ###########################################################################
    [Documentation]    Writes a list of dictionaries to Excel with headers.
    ...
    ...                *Purpose:*
    ...                Converts a list of dictionaries into tabular format with headers
    ...                in the first row and data in subsequent rows. This is the inverse
    ...                operation of the Load Lead Test Data From Excel keyword.
    ...
    ...                *Arguments:*
    ...                - data_list_copado: List of dictionaries to write
    ...                - headers_copado: (Optional) List of keys in desired column order
    ...                - start_row_copado: (Optional) Row to start writing (default: 1)
    ...                - write_headers_copado: (Optional) Whether to write header row (default: True)
    ...                - sheet_name_copado: (Optional) Sheet name to write to
    ...
    ...                *Returns:*
    ...                Number of rows written (including header if written)
    ...
    ...                *Usage Example:*
    ...                | @{leads}= | Load Lead Test Data From Excel |
    ...                | ${doc}= | Create New Excel Document-copado | doc_id_copado=output |
    ...                | ${rows}= | Write List Of Dictionaries-copado | data_list_copado=${leads} |
    ...                | Save Excel Document-copado | filename_copado=output.xlsx |
    
    [Arguments]                 ${data_list_copado}    ${headers_copado}=${None}    ${start_row_copado}=1    ${write_headers_copado}=${True}    ${sheet_name_copado}=${None}
    [Tags]                      excel    write-operations    dictionary    bulk
    
    # Validate input
    ${list_length}=             Get Length    ${data_list_copado}
    Run Keyword If              ${list_length} == 0    Log To Console    Warning: Empty data list provided
    Return From Keyword If      ${list_length} == 0    0
    
    # Get headers from first dictionary if not provided
    ${first_dict}=              Get From List    ${data_list_copado}    0
    ${headers_to_use}=          Run Keyword If    ${headers_copado} == ${None}    Get Dictionary Keys    ${first_dict}
    ...                         ELSE    Set Variable    ${headers_copado}
    
    ${current_row}=             Set Variable    ${start_row_copado}
    
    # Write headers if requested
    IF    ${write_headers_copado}
        Write Excel Row         row_num=${current_row}    row_data=${headers_to_use}    sheet_name=${sheet_name_copado}
        ${current_row}=         Evaluate    ${current_row} + 1
    END
    
    # Write each dictionary as a row
    FOR    ${data_dict}    IN    @{data_list_copado}
        @{row_data}=            Create List
        FOR    ${header}    IN    @{headers_to_use}
            ${value}=           Get From Dictionary    ${data_dict}    ${header}    default=${EMPTY}
            Append To List      ${row_data}    ${value}
        END
        Write Excel Row         row_num=${current_row}    row_data=${row_data}    sheet_name=${sheet_name_copado}
        ${current_row}=         Evaluate    ${current_row} + 1
    END
    
    ${total_rows}=              Evaluate    ${current_row} - ${start_row_copado}
    Log To Console              Wrote ${list_length} data rows to Excel (${total_rows} total rows including headers)
    
    [Return]                    ${total_rows}


###############################################################################
# TEST RESULTS WRITE KEYWORDS
###############################################################################

Write Test Result Row-copado
    ###########################################################################
    # KEYWORD DOCUMENTATION
    ###########################################################################
    [Documentation]    Writes a test result row with timestamp, test name, status, and message.
    ...
    ...                *Purpose:*
    ...                Standardized keyword for writing test execution results to Excel
    ...                for reporting and tracking purposes.
    ...
    ...                *Arguments:*
    ...                - row_num_copado: Row number to write to
    ...                - test_name_copado: Name of the test case
    ...                - status_copado: Test status (PASS/FAIL/SKIP)
    ...                - message_copado: (Optional) Additional message or error details
    ...                - sheet_name_copado: (Optional) Sheet name to write to
    ...
    ...                *Usage Example:*
    ...                | Write Test Result Row-copado | row_num_copado=2 | test_name_copado=Login Test | status_copado=PASS |
    ...                | Write Test Result Row-copado | row_num_copado=3 | test_name_copado=Create Lead | status_copado=FAIL | message_copado=Required field missing |
    
    [Arguments]                 ${row_num_copado}    ${test_name_copado}    ${status_copado}    ${message_copado}=${EMPTY}    ${sheet_name_copado}=${None}
    [Tags]                      excel    write-operations    test-results
    
    ${timestamp}=               Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    @{result_row}=              Create List    ${timestamp}    ${test_name_copado}    ${status_copado}    ${message_copado}
    
    Write Excel Row             row_num=${row_num_copado}    row_data=${result_row}    sheet_name=${sheet_name_copado}
    Log To Console              Wrote test result: ${test_name_copado} - ${status_copado}


Write Test Results Header-copado
    ###########################################################################
    # KEYWORD DOCUMENTATION
    ###########################################################################
    [Documentation]    Writes a standard header row for test results.
    ...
    ...                *Purpose:*
    ...                Creates a consistent header row for test result reports.
    ...
    ...                *Arguments:*
    ...                - row_num_copado: (Optional) Row number to write header (default: 1)
    ...                - sheet_name_copado: (Optional) Sheet name to write to
    ...
    ...                *Usage Example:*
    ...                | ${doc}= | Create New Excel Document-copado | doc_id_copado=results |
    ...                | Write Test Results Header-copado |
    ...                | Write Test Result Row-copado | row_num_copado=2 | test_name_copado=Test 1 | status_copado=PASS |
    
    [Arguments]                 ${row_num_copado}=1    ${sheet_name_copado}=${None}
    [Tags]                      excel    write-operations    test-results    header
    
    @{headers}=                 Create List    Timestamp    Test Name    Status    Message
    Write Excel Row             row_num=${row_num_copado}    row_data=${headers}    sheet_name=${sheet_name_copado}
    Log To Console              Wrote test results header row


###############################################################################
# UTILITY KEYWORDS
###############################################################################

Convert Cell Reference To Numbers-copado
    ###########################################################################
    # KEYWORD DOCUMENTATION
    ###########################################################################
    [Documentation]    Converts Excel-style cell reference (e.g., A1, B5) to row and column numbers.
    ...
    ...                *Purpose:*
    ...                Helper keyword to convert familiar Excel notation to numeric
    ...                row/column values required by ExcelLibrary.
    ...
    ...                *Arguments:*
    ...                - cell_reference_copado: Excel-style cell reference (e.g., 'A1', 'AA10')
    ...
    ...                *Returns:*
    ...                Two values: row number and column number (both starting at 1)
    ...
    ...                *Examples:*
    ...                | ${row}    ${col}= | Convert Cell Reference To Numbers-copado | A1 |
    ...                | # Returns: row=1, col=1
    ...                | ${row}    ${col}= | Convert Cell Reference To Numbers-copado | B5 |
    ...                | # Returns: row=5, col=2
    ...                | ${row}    ${col}= | Convert Cell Reference To Numbers-copado | AA10 |
    ...                | # Returns: row=10, col=27
    
    [Arguments]                 ${cell_reference_copado}
    [Tags]                      excel    utility    conversion
    
    # Extract column letters and row number using regex
    ${col_letters}=             Evaluate    ''.join([c for c in '${cell_reference_copado}' if c.isalpha()])
    ${row_num}=                 Evaluate    int(''.join([c for c in '${cell_reference_copado}' if c.isdigit()]))
    
    # Convert column letters to number (A=1, B=2, ..., Z=26, AA=27, etc.)
    ${col_num}=                 Evaluate    sum((ord(c.upper()) - 64) * (26 ** i) for i, c in enumerate(reversed('${col_letters}')))
    
    Log To Console              Converted ${cell_reference_copado} to row=${row_num}, col=${col_num}
    
    [Return]                    ${row_num}    ${col_num}


Get Next Available Row-copado
    ###########################################################################
    # KEYWORD DOCUMENTATION
    ###########################################################################
    [Documentation]    Finds the next empty row in a column (useful for appending data).
    ...
    ...                *Purpose:*
    ...                Scans a column to find the first empty cell, useful when you need
    ...                to append data without overwriting existing content.
    ...
    ...                *Arguments:*
    ...                - col_num_copado: Column number to scan (default: 1)
    ...                - start_row_copado: Row to start scanning from (default: 1)
    ...                - max_rows_copado: Maximum rows to scan (default: 1000)
    ...                - sheet_name_copado: (Optional) Sheet name to scan
    ...
    ...                *Returns:*
    ...                Row number of the first empty cell found
    ...
    ...                *Usage Example:*
    ...                | ${next_row}= | Get Next Available Row-copado | col_num_copado=1 |
    ...                | Write Single Row-copado | row_num_copado=${next_row} | row_data_copado=${new_data} |
    
    [Arguments]                 ${col_num_copado}=1    ${start_row_copado}=1    ${max_rows_copado}=1000    ${sheet_name_copado}=${None}
    [Tags]                      excel    utility    navigation
    
    FOR    ${row}    IN RANGE    ${start_row_copado}    ${max_rows_copado}
        ${cell_value}=          Read Excel Cell    row_num=${row}    col_num=${col_num_copado}    sheet_name=${sheet_name_copado}
        ${is_empty}=            Run Keyword And Return Status    Should Be Equal    ${cell_value}    ${None}
        Return From Keyword If    ${is_empty}    ${row}
    END
    
    # If no empty row found, return max_rows + 1
    ${next_row}=                Evaluate    ${max_rows_copado} + 1
    Log To Console              Warning: No empty row found in first ${max_rows_copado} rows, returning ${next_row}
    
    [Return]                    ${next_row}


Create Excel Report With Headers-copado
    ###########################################################################
    # KEYWORD DOCUMENTATION
    ###########################################################################
    [Documentation]    Creates a new Excel document with custom headers.
    ...
    ...                *Purpose:*
    ...                Convenience keyword that creates a new Excel document and
    ...                writes a header row in one operation.
    ...
    ...                *Arguments:*
    ...                - doc_id_copado: Document identifier
    ...                - headers_copado: List of header values
    ...                - filename_copado: (Optional) If provided, saves the document immediately
    ...                - sheet_name_copado: (Optional) Sheet name to write to
    ...
    ...                *Returns:*
    ...                Document identifier
    ...
    ...                *Usage Example:*
    ...                | @{headers}= | Create List | Test Name | Status | Duration | Notes |
    ...                | ${doc}= | Create Excel Report With Headers-copado | doc_id_copado=report | headers_copado=${headers} |
    
    [Arguments]                 ${doc_id_copado}    ${headers_copado}    ${filename_copado}=${None}    ${sheet_name_copado}=${None}
    [Tags]                      excel    utility    report-generation
    
    ${doc}=                     Create New Excel Document-copado    doc_id_copado=${doc_id_copado}
    Write Single Row-copado     row_num_copado=1    row_data_copado=${headers_copado}    sheet_name_copado=${sheet_name_copado}
    
    Run Keyword If              '${filename_copado}' != '${None}'    Save Excel Document-copado    filename_copado=${filename_copado}
    
    [Return]                    ${doc}