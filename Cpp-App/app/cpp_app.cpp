#include <cstring>
#include <iostream>
#include <sstream>
#include <string>
#include <curl/curl.h>
#include "/opt/appdynamics-sdk-native/sdk_lib/appdynamics.h"

const char APP_NAME[] = "<your_app_name>";
const char TIER_NAME[] = "<your_tier_name>";
const char NODE_NAME[] = "<your_node_name>";
const char CONTROLLER_HOST[] = "<your_controller>";
const int CONTROLLER_PORT = <your_controller_port>;
const char CONTROLLER_ACCOUNT[] = "<your_account_name>";
const char CONTROLLER_ACCESS_KEY[] = "<your_access_key>";
const int CONTROLLER_USE_SSL = 0;
const int WAITTIMEFORCONFIG = 10000;

struct ErrorMessage
{
    ErrorMessage() {}
    ~ErrorMessage()
    {
        if (text.size())
        {
            std::cerr << text << std::endl;
        }
    }

    std::string text;
};

struct SDKWrapper
{
    SDKWrapper(appd_config& cfg) : initRC(0)
    {
        initRC = appd_sdk_init(&cfg);
    }

    ~SDKWrapper()
    {
        if (!initRC)
        {
            appd_sdk_term();
        }
    }

    int initRC;
};

class LibcurlURLGet
{
public:
    LibcurlURLGet(const std::string& url) : url(url), curlHandle(NULL) {}

    std::string GetResponse(const char* correlationHeader)
    {
        CURLcode res;
        Response response;

        curlHandle = curl_easy_init();
        if (curlHandle)
        {
            curl_easy_setopt(curlHandle, CURLOPT_URL, url.c_str());
            curl_easy_setopt(curlHandle, CURLOPT_WRITEFUNCTION, WriteDataCallback);
            curl_easy_setopt(curlHandle, CURLOPT_WRITEDATA, &response);

            if(correlationHeader && strlen(correlationHeader))
            {
                std::string singularityHeader(APPD_CORRELATION_HEADER_NAME);
                singularityHeader.append(": ");
                singularityHeader.append(correlationHeader);
                curl_slist* slistNewHeaders = 0;
                slistNewHeaders = curl_slist_append(slistNewHeaders, singularityHeader.c_str());
                curl_easy_setopt(curlHandle, CURLOPT_HTTPHEADER, slistNewHeaders);
            }

            res = curl_easy_perform(curlHandle);
            if(res != CURLE_OK)
            {
            }
        }

        curl_easy_cleanup(curlHandle);

        return response.GetResponseString();
    }

private:
    class Response
    {
    public:
        std::string GetResponseString()
        {
            return sResponse;
        }

        void AppendResponse(void* ptr, size_t sizeBytes)
        {
            sResponse.append((char*)ptr, sizeBytes);
        }

    private:
        std::string sResponse;
    };

    static size_t WriteDataCallback(void* ptr, size_t size, size_t nmemb, Response* response)
    {
        response->AppendResponse(ptr, size * nmemb);
        return size * nmemb;
    }

    std::string url;
    CURL* curlHandle;
};

void setSnapshotAttributes(appd_bt_handle btHandle, int minute, int halfsec)
{
    if (appd_bt_is_snapshotting(btHandle))
    {
        printf("***");

        char nameBuf[30];
        char valueBuf[30];
        snprintf(nameBuf, sizeof(nameBuf), "BT:%p\n", btHandle);
        snprintf(valueBuf, sizeof(valueBuf), "Minute:%d Second:%d\n", minute, halfsec/2);

        appd_bt_add_user_data(btHandle, nameBuf, valueBuf);

        static int snapCount = 0;
        int switchVal = snapCount % 4;
        if (switchVal)
        {
            appd_error_level errorLevel;
            bool markBtAsError;
            switch (switchVal)
            {
            case 1:
                errorLevel = APPD_LEVEL_NOTICE;
                markBtAsError = false;
                snprintf(nameBuf, sizeof(nameBuf), "NOTICE BT:%p M:%d S:%d\n", btHandle, minute, halfsec/2);
                break;
            case 2:
                errorLevel = APPD_LEVEL_WARNING;
                markBtAsError = false;
                snprintf(nameBuf, sizeof(nameBuf), "WARNING BT:%p M:%d S:%d\n", btHandle, minute, halfsec/2);
                break;
            case 3:
                errorLevel = APPD_LEVEL_ERROR;
                markBtAsError = true;
                snprintf(nameBuf, sizeof(nameBuf), "ERROR BT:%p M:%d S:%d\n", btHandle, minute, halfsec/2);
                break;
            }

            appd_bt_add_error(btHandle, errorLevel, nameBuf, markBtAsError);
        }

        snapCount++;
        snprintf(nameBuf, sizeof(nameBuf), "http://bt-%p.com", btHandle);
        appd_bt_set_url(btHandle, nameBuf);
    }
}

int main(int argc, char** argv)
{
    if (argc < 2)
    {
        printf("Input Error: Missing URL.\n");
        printf("Usage:    testcase <url>\n");
        printf("Example1: testcase java_app\n");
        return -1;
    }

    char const nullbyte = '\0';
    const char* APP_URL = argv[1];
    const char* APP_DIR = &nullbyte;

    char* slash = const_cast<char*>(strchr(APP_URL, '/'));
    if (slash)
    {
        *slash = '\0';
        APP_DIR = slash+1;
    }

    printf("PID: %d\n", getpid());
    printf("URL: %s/%s\n\n", APP_URL, APP_DIR);
    printf("     Application name: %s\n", APP_NAME);
    printf("            Tier name: %s\n", TIER_NAME);
    printf("            Node name: %s\n", NODE_NAME);
    printf("      Controller host: %s\n", CONTROLLER_HOST);
    printf("      Controller port: %d\n", CONTROLLER_PORT);
    printf("   Controller account: %s\n", CONTROLLER_ACCOUNT);
    printf("Controller access key: %s\n", CONTROLLER_ACCESS_KEY);
    printf("   Controller use SSL: %d\n", CONTROLLER_USE_SSL );
    printf("\nChange the constants in main.cpp if anything above is incorrect.\n\n\n");

    appd_config cfg;
    appd_config_init(&cfg);
    cfg.app_name = (char*)APP_NAME;
    cfg.tier_name = (char*)TIER_NAME;
    cfg.node_name = (char*)NODE_NAME;
    cfg.controller.host = (char*)CONTROLLER_HOST;
    cfg.controller.port = CONTROLLER_PORT;
    cfg.controller.account = (char*)CONTROLLER_ACCOUNT;
    cfg.controller.access_key = (char*)CONTROLLER_ACCESS_KEY;
    cfg.controller.use_ssl = CONTROLLER_USE_SSL;
    cfg.init_timeout_ms = WAITTIMEFORCONFIG;

    printf("Calling appd_sdk_init. Waiting %d milliseconds for config\n", WAITTIMEFORCONFIG);

    int rc = 0;
    ErrorMessage theError;
    std::ostringstream errStream;
    SDKWrapper SDK(cfg);
    if (SDK.initRC)
    {
        errStream <<  "Error: sdk init: " << SDK.initRC << ". Check that proxy was manually started.";
        theError.text = errStream.str();
        return -1;
    }

    printf("\nnative sdk initialized\n");
    printf("\nrunning infinite loop to generate normal BT and BT with Error.");
    printf("\npress CTRL-C to terminate.\n");

    // declare/add backend
    const char backendOne[] = "first backend";
    appd_backend_declare(APPD_BACKEND_HTTP,  backendOne);

    rc = appd_backend_set_identifying_property(backendOne, "HOST", "<backend_host>");
    rc = appd_backend_set_identifying_property(backendOne, "PORT", "<backend_port>");
    
    if (rc)
    {
        errStream << "Error: appd_backend_set_identifying_property: " << rc << ".";
        theError.text = errStream.str();
        return -1;
    }

    rc = appd_backend_add(backendOne);
    if (rc)
    {
        errStream << "Error: appd_backend_add: " << rc << ".";
        theError.text = errStream.str();
        return -1;
    }

    int halfsec = 1;
    int minute = 1;

    while(minute <= 1440)
    {
        appd_bt_handle btHandle = appd_bt_begin("<cpp_file_name>", NULL);

        std::string urlBase(APP_URL) ;
        std::string url = std::string("http://") + urlBase + std::string("/") + APP_DIR;
        LibcurlURLGet urlGet(url);

        const char urlLiteral[] = "backend url";
        const char dirLiteral[] = "backend directory";
        appd_bt_add_user_data(btHandle, urlLiteral, urlBase.c_str());
        appd_bt_add_user_data(btHandle, dirLiteral, APP_DIR);

        appd_exitcall_handle ecHandle = appd_exitcall_begin(btHandle, backendOne);

        const char* corrHeader1 = appd_exitcall_get_correlation_header(ecHandle);

        std::string response = urlGet.GetResponse(corrHeader1);

        usleep(500000 * 60); // 0.5 seconds

        if (!ecHandle)
        {
            std::cout << " ," << std::flush;
        }
        else
        {
            std::cout << (long long)ecHandle << "," << std::flush;

            setSnapshotAttributes(btHandle, minute, halfsec);

            rc = appd_exitcall_set_details(ecHandle, "backend ONE");
            if (rc)
            {
                errStream << "Error: exitcall details1";
                theError.text = errStream.str();
                return -1;
            }
//            appd_exitcall_add_error(ecHandle, APPD_LEVEL_ERROR, "exitcall1 error!", 1);
            appd_exitcall_end(ecHandle);
        }

        appd_bt_end(btHandle);

        if(halfsec % 24 == 0)
        {
            if(halfsec % 120 == 0)
            {
                printf(" M%d", minute);
                halfsec = 0;
                minute++;
            }
            printf("\n");
        }
        halfsec++;
    } // end while

    return 0;
}
