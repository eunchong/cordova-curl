var argscheck = require('cordova/argscheck'),
    exec = require('cordova/exec');

function Curl() { }

//reset cookies
Curl.prototype.reset = function(data, successCallback, errorCallback) {
    argscheck.checkArgs('aff', 'Curl.reset', arguments);
    exec(successCallback, errorCallback, "Curl", "reset", data);
};

//make request
Curl.prototype.query = function(data, successCallback, errorCallback) {
    argscheck.checkArgs('aff', 'Curl.query', arguments);
    exec(successCallback, errorCallback, "Curl", "query", data);
};

//get cookies
Curl.prototype.cookie = function(data, successCallback, errorCallback) {
    argscheck.checkArgs('aff', 'Curl.cookie', arguments);
    exec(successCallback, errorCallback, "Curl", "cookie", data);
};

module.exports = new Curl();