public func main() : int {
    var henv : *mut void
    var hdbc : *mut void
    
    // Allocate environment
    if (mssql::ffi::SQLAllocHandle(mssql::SQL_HANDLE_ENV, null as *mut void, &mut henv) != mssql::SQL_SUCCESS) {
        printf("Failed to allocate environment handle\n")
        return 1
    }

    // Set ODBC version
    // mssql.h: #define SQL_OV_ODBC3 3UL
    mssql::ffi::SQLSetEnvAttr(henv, mssql::SQL_ATTR_ODBC_VERSION, 3 as *void, 0)

    // Allocate connection
    if (mssql::ffi::SQLAllocHandle(mssql::SQL_HANDLE_DBC, henv, &mut hdbc) != mssql::SQL_SUCCESS) {
        printf("Failed to allocate connection handle\n")
        mssql::ffi::SQLFreeHandle(mssql::SQL_HANDLE_ENV, henv)
        return 1
    }

    printf("Successfully allocated MSSQL/ODBC handles!\n")

    // Free handles
    mssql::ffi::SQLFreeHandle(mssql::SQL_HANDLE_DBC, hdbc)
    mssql::ffi::SQLFreeHandle(mssql::SQL_HANDLE_ENV, henv)

    printf("mssql Demo Success!\n")
    return 0
}
