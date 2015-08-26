var argscheck = require('cordova/argscheck'),
    exec = require('cordova/exec');

function Curl() { }

//reset cookies
Curl.prototype.reset = function(successCallback, errorCallback) {
    argscheck.checkArgs('ff', 'Curl.query', arguments);
    exec(successCallback, errorCallback, "Curl", "reset", []);
};

//make request
Curl.prototype.query = function(data, successCallback, errorCallback) {
    argscheck.checkArgs('aff', 'Curl.query', arguments);
    exec(successCallback, errorCallback, "Curl", "query", data);
};

//get cookies
Curl.prototype.cookie = function(successCallback, errorCallback) {
    argscheck.checkArgs('ff', 'Curl.cookie', arguments);
    exec(successCallback, errorCallback, "Curl", "cookie", []);
};

module.exports = new Curl();