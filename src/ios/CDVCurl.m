#import <Cordova/CDV.h>
#import "CDVCurl.h"

struct MemoryStruct {
  char *memory;
  size_t size;
};

@interface CDVCurl () {}
@end

@implementation CDVCurl

- (void)reset:(CDVInvokedUrlCommand*)command
{
		self.callbackId = command.callbackId;
		CDVPluginResult* pluginResult;
		if (unlink([[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"cookie"] UTF8String]))
			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
		else
			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (void)cookie:(CDVInvokedUrlCommand*)command
{
		CDVPluginResult* pluginResult;

        NSError *error;
		NSString *str = [NSString stringWithContentsOfFile:@"db4.txt"
                                                  encoding:NSASCIIStringEncoding
                                                     error:&error];
		if (error != nil)
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:str];
		else
			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)query:(CDVInvokedUrlCommand*)command
{
		NSString *url = [command argumentAtIndex:0];
		NSArray *headers = [command argumentAtIndex:1];
		NSData *postfields_data = NULL;
		NSString *postfields_string = NULL;
		if ([[command argumentAtIndex:2] isKindOfClass:[NSString class]])
			postfields_string = [command argumentAtIndex:2];
		else
			postfields_data = [command argumentAtIndex:2];
		NSNumber *follow = [command argumentAtIndex:3];
		self.callbackId = command.callbackId;
		[self.commandDelegate runInBackground:^{
				CDVPluginResult* pluginResult;
				struct MemoryStruct chunk;
			  chunk.memory = malloc(1);
				chunk.memory[0] = 0;
			  chunk.size = 0;
				CURL *curl = curl_easy_init();
				if (curl) {
					curl_easy_setopt(curl, CURLOPT_URL, [url UTF8String]);
					//curl_easy_setopt(curl, CURLOPT_PROXY, "0.0.0.0");
					//curl_easy_setopt(curl, CURLOPT_PROXYPORT, 8888);
					NSString *cookie = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"cookie"];
					curl_easy_setopt(curl, CURLOPT_COOKIEFILE, [cookie UTF8String]);
					curl_easy_setopt(curl, CURLOPT_COOKIEJAR, [cookie UTF8String]);
					curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteMemoryCallback);
					curl_easy_setopt(curl, CURLOPT_WRITEDATA, (void *)&chunk);
					curl_easy_setopt(curl, CURLOPT_HEADER, 1);
					if ([follow boolValue]) curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1);
					if (postfields_string != NULL) curl_easy_setopt(curl, CURLOPT_POSTFIELDS, [postfields_string UTF8String]);
					else if (postfields_data != NULL) curl_easy_setopt(curl, CURLOPT_POSTFIELDS, [postfields_data bytes]);
					struct curl_slist *list = NULL;
					for (NSString *header in headers) list = curl_slist_append(list, [header UTF8String]);
					curl_easy_setopt(curl, CURLOPT_HTTPHEADER, list);
					if (curl_easy_perform(curl) == CURLE_OK) {
						long header_size;
						curl_easy_getinfo(curl, CURLINFO_HEADER_SIZE, &header_size);
						NSString *data = [NSString stringWithCString:chunk.memory encoding:NSUTF8StringEncoding];
						pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:@[[data substringFromIndex:header_size], [data substringToIndex:header_size]]];
					} else pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
					free(chunk.memory);
					curl_easy_cleanup(curl);
					curl_slist_free_all(list);
				} else pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
				[self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
		}];
}

WriteMemoryCallback(void *contents, size_t size, size_t nmemb, void *userp)
{
  size_t realsize = size * nmemb;
  struct MemoryStruct *mem = (struct MemoryStruct *)userp;
  mem->memory = realloc(mem->memory, mem->size + realsize + 1);
  if (mem->memory == NULL) return 0;
  memcpy(&(mem->memory[mem->size]), contents, realsize);
  mem->size += realsize;
  mem->memory[mem->size] = 0;
  return realsize;
}

@end
