import urllib.parse

assert(urllib.parse.quote("/El Niño/") == "/El%20Ni%C3%B1o/")
assert(urllib.parse.quote_plus("/El Niño/") == "%2FEl+Ni%C3%B1o%2F")
