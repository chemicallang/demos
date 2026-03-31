application mssql_demo

source "src"

import std
import "../../extra/mssql"

link "odbc32" if windows
