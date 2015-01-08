storeit-plugin-department  [![Build Status](https://travis-ci.org/YuzuJS/storeit-plugin-department.svg?branch=master)](https://travis-ci.org/YuzuJS/storeit-plugin-department)
=======
 
A StoreIt plugin that adds departments to a store. 

It adds a `store.createDepartment("name")` method and returns an instance of `Department`.
A `department` is basically same as a store but limited in scope.

## Use the Plugin

Before you can use the `storeit-plugin-department` plugin, you must install it into StoreIt as follows:
```javascript
var Storeit = require("storeit");
var departmentPliugin = require("storeit-plugin-department");
Storeit.use(departmentPliugin);
```
## Example
Here is an example of what you can do with departments:
```javascript
var store = new Storeit("my-store", provider);
var mensDepartment = store.createDepartment("mens");
var womensDepartment = store.createDepartment("womens");

function logit(value, key) {
    console.log("key=%s value=%s", key, value);
}

store.on("added", logit);
mensDepartment.on("added", logit);
womensDepartment.on("added", logit);

mensDepartment.set("foo", "bar");
```

The output would be:
```shell
key=mens/foo value=bar
key=foo value=bar
```

## License

For use under [MIT license](http://github.com/YuzuJS/storeit-plugin-department/raw/master/LICENSE)
