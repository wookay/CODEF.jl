module TestKR_BK_1_B_001

using CODEF.API
using JSON
using URIParser
using Test

# https://github.com/codef-io/codef-python/blob/master/sandbox/bk/TestKR_BK_1_B_001.py

######################################
##      은행 법인 보유계좌
######################################

# API서버 샌드박스 도메인
CODEF_URL = "https://tsandbox.codef.io";
TOKEN_URL = "https://oauth.codef.io/oauth/token";
SANDBOX_CLIENT_ID   = "ef27cfaa-10c1-4470-adac-60ba476273f9";    # CODEF 샌드박스 클라이언트 아이디
SANDBOX_SECERET_KEY = "83160c33-9045-4915-86d8-809473cdf5c3";    # CODEF 샌드박스 클라이언트 시크릿

# 은행 법인 보유계좌
account_list_path = "/v1/kr/bank/b/account/account-list"

# 기 발급된 토큰
token = ""

# BodyData
body = (
    connectedId  = "sandbox_connectedId",    # SANDBOX 커넥티드아이디
    organization = "0004"                    # 기관코드(https://developer.codef.io "은행 목록" 참조)
)

# CODEF API 요청
response_codef_api = http_sender(CODEF_URL * account_list_path, token, body)
if response_codef_api.status == 200
    println("정상처리")
elseif response_codef_api.status == 401
    dict = JSON.parse(IOBuffer(response_codef_api.body))
    # invalid_token
    println("error = ", dict["error"])
    # Cannot convert access token to JSON
    println("error_description = ", dict["error_description"])

    # reissue token
    response_oauth = request_token(TOKEN_URL, SANDBOX_CLIENT_ID, SANDBOX_SECERET_KEY);
    if response_oauth.status == 200
        dict = JSON.parse(IOBuffer(response_oauth.body))
        # reissue_token
        token = dict["access_token"]
        println("access_token = ", token)

        # request codef_api
        response = http_sender(CODEF_URL * account_list_path, token, body)
        dict = (JSON.parse ∘ URIParser.unescape_form ∘ String)(response.body)
        @info :dict dict
        @test dict["result"]["message"] == "성공"
    else
        println("토큰발급 오류")
    end
else
    prinlnt("API 요청 오류")
end

end # module TestKR_BK_1_B_001
