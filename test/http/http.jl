using Test

using HTTP
@test HTTP.escapepath("/El Niño/") == "/El%20Ni%C3%B1o/"
@test HTTP.escapeuri((a=1, b=2)) == "a=1&b=2"

using URIParser
@test URIParser.escape_form("/El Niño/") == "%2FEl+Ni%C3%B1o%2F"
