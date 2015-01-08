"use strict";

var pubit = require("pubit-as-promised");

var SEPARATOR = "/"; // TODO allow this to be an option.

module.exports = function Department(departmentName, store, utils) {
    var that = this;

    var EventName = utils.EventName;
    var events = [EventName.added, EventName.modified, EventName.removed, EventName.cleared];
    var publish = pubit.makeEmitter(that, events); // Mixin `on`, `off`, `once`.

    function prefixWithDepartment(key) { // Add the department to the key.
        return departmentName + SEPARATOR + key;
    }

    function stripDepartment(storeKey) { // Return the key without the department.
        return storeKey.substr(departmentName.length + SEPARATOR.length);
    }

    function isThisDepartment(storeKey) {
        return storeKey.indexOf(departmentName + SEPARATOR) === 0;
    }

    function republish(eventName, value, storeKey) {
        if (isThisDepartment(storeKey)) {
            publish(eventName, value, stripDepartment(storeKey));
        }
    }

    var handler = {
        added: republish.bind(null, EventName.added),
        modified: republish.bind(null, EventName.modified),
        removed: republish.bind(null, EventName.removed),
        cleared: publish.bind(null, EventName.cleared)
    };

    Object.defineProperty(that, "name", {
        value: departmentName,
        enumerable: true
    });

    that.has = function (key) {
        return store.has(prefixWithDepartment(key));
    };

    that.get = function (key, defaultValue) {
        return store.get(prefixWithDepartment(key), defaultValue);
    };

    that.set = function (key, value) {
        var results = store.set(prefixWithDepartment(key), value);
        results.key = key;
        return results;
    };

    function remove(key) {
        var results = store.remove(prefixWithDepartment(key));
        results.key = key;
        return results;
    }

    that.remove = remove;
    that["delete"] = remove;

    that.destroy = function () {
        events.forEach(function (eventName) {
            store.off(eventName, handler[eventName]);
        });
    };

    events.forEach(function (eventName) {
        store.on(eventName, handler[eventName]);
    });
};
