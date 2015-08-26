# cordova-curl
=============================
> Simple wrapper under libcurl(plain c)  
> Precomplired binaries taken from https://github.com/gcesarmza/curl-android-ios

**Attention:**
On android disabled SSL verefying!   
To repair http://stackoverflow.com/questions/25253823/how-to-make-ssl-peer-verify-work-on-android

 --------------------------------------------------------------------------------  
## Installation:
```bash
  cordova plugin add https://github.com/mnill/cordova-curl
```

### Android
In addition to the Android SDK, the NDK is required. See https://developer.android.com/tools/sdk/ndk/index.html for installation instructions.

The environment variables ANDROID_HOME and ANDROID_NDK_HOME must be set to the point to the locations where the Android SDK and NDK are installed.

 --------------------------------------------------------------------------------  

## Using:

Three methods are there:


**Perform request:** curl.query(successCallback, failCallback, [url(string), headers(array of strings), postData(string, optional), followLocation(boolean, optional, default false)]);

**Reset cookies:** curl.reset(successCallback, failCallback);  

**Get cookies file content:** curl.cookie(successCallback, failCallback);

 
### Examples:
curl.query(function(answer, answerHeaders){alert(answer)}, function(){alert('fail')}, ['http://ru.wikipedia.org/' ['Accept: text/plain', 'Host: ru.wikipedia.org'], null, true]);

curl.reset(function(){alert('cookies deted')}, function(){alert('fail to delete cookies')});

curl.cookie(function(content){alert(content)}, function(){alert('fail to get cookies')});

 --------------------------------------------------------------------------------  