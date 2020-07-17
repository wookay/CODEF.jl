# module CODEF.API

export http_sender, request_token

using HTTP, JSON, Base64

function http_post(url, headers, data)
    response = nothing
    try
        response = HTTP.post(url, headers, data)
    catch err
        if err isa HTTP.ExceptionRequest.StatusError
            response = err.response
        else
            @info :typeof typeof(err)
            @info :err err
            err
        end
    end
    return response
end

"""
    http_sender(url, token, body)

HTTP 기본 함수
"""
function http_sender(url, token, body)
    headers = [
        "Content-Type"  => "application/json",
        "Authorization" => string("Bearer ", token),
    ]
    http_post(url, headers, (HTTP.escapepath ∘ JSON.json)(body))
end

"""
    request_token(url, client_id, client_secret)

Token 재발급
"""
function request_token(url, client_id, client_secret)
    authHeader = Base64.base64encode(string(client_id, ':', client_secret))
    headers = [
        "Acceppt"       => "application/json",
        "Content-Type"  => "application/x-www-form-urlencoded",
        "Authorization" => string("Basic ", authHeader),
    ]
    http_post(url, headers, HTTP.escapeuri((grant_type=:client_credentials, scope=:read)))
end

# module CODEF.API
