find_path(MBEDTLS_INCLUDE_DIRS mbedtls/version.h)

if (MBEDTLS_INCLUDE_DIRS AND EXISTS ${MBEDTLS_INCLUDE_DIRS}/mbedtls/version.h)
    file(STRINGS "${MBEDTLS_INCLUDE_DIRS}/mbedtls/version.h" MBEDTLS_VERSION_STRING_LINE REGEX "^#define[ \t]+MBEDTLS_VERSION_STRING[ \t]+\"[0-9.]+\"$")
    string(REGEX REPLACE "^#define[ \t]+MBEDTLS_VERSION_STRING[ \t]+\"([0-9.]+)\"$" "\\1" MBEDTLS_VERSION_STRING "${MBEDTLS_VERSION_STRING_LINE}")
    unset(MBEDTLS_VERSION_STRING_LINE)
endif()

find_library(MBEDTLS_LIBRARY mbedtls)
find_library(MBEDX509_LIBRARY mbedx509)
find_library(MBEDCRYPTO_LIBRARY mbedcrypto)

set(MBEDTLS_LIBRARIES "${MBEDTLS_LIBRARY}" "${MBEDX509_LIBRARY}" "${MBEDCRYPTO_LIBRARY}")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MbedTLS
    REQUIRED_VARS MBEDTLS_LIBRARIES MBEDTLS_INCLUDE_DIRS
    VERSION_VAR MBEDTLS_VERSION_STRING
)

mark_as_advanced(MBEDTLS_INCLUDE_DIRS MBEDTLS_LIBRARY MBEDX509_LIBRARY MBEDCRYPTO_LIBRARY)
