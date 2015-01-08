"use strict";

var Department = require("./Department");

module.exports = function (target, _0, utils) {
    var department = {};

    Object.defineProperty(target, "department", {
        value: department,
        enumerable: true
    });

    target.createDepartment = function (departmentName) {
        if (!department[departmentName]) {
            department[departmentName] = new Department(departmentName, target, utils);
        }
        return department[departmentName];
    };
};
