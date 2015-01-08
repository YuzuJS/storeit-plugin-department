"use strict"

departmentPlugin = require("..")
Department = require("../lib/Department")
StoreIt = require("storeit")
StoreitError = StoreIt.StoreitError;

StoreIt.use(departmentPlugin)

describe "StoreIt!", ->
    store = null

    beforeEach ->
        @storageProvider = {
            name: "NoopProvider"
            metadataSerializer: "TestMetadataSerializer"
            itemSerializer: "TestItemSerializer"
            getMetadata: =>
            setMetadata: =>
            getItem: =>
            setItem: =>
            removeItem: =>
        }

    describe "when extended with the department plugin", ->
        beforeEach ->
            store = new StoreIt("testns", @storageProvider)
            store.clear()

        it "implements the additional interface method createDepartment", ->
            store.should.respondTo("createDepartment")

        it "should have a `department` property with correct defaults", ->
            store.department.should.deep.equal({})

        describe "when calling createDepartment", ->
            beforeEach ->
                @department = store.createDepartment("dept")

            it "should return return an instance of Department", ->
                (@department instanceof Department).should.equal(true)
            describe "and the instance of Department", ->
                it "should be reflected in store.department.dept", ->
                    store.department.dept.should.deep.equal(@department)
                it "should have a `name` property", ->
                    @department.name.should.equal("dept")
                it "should impliment a `has` method", ->
                    @department.should.respondTo("has")
                it "should impliment a `get` method", ->
                    @department.should.respondTo("get")
                it "should impliment a `set` method", ->
                    @department.should.respondTo("set")
                it "should impliment a `remove` method", ->
                    @department.should.respondTo("remove")
                it "should impliment a `delete` method", ->
                    @department.should.respondTo("delete")
                it "should impliment a `on` method", ->
                    @department.should.respondTo("on")
                it "should impliment a `once` method", ->
                    @department.should.respondTo("once")
                it "should impliment a `off` method", ->
                    @department.should.respondTo("off")

        describe "a set of 'key' in a department", ->
            beforeEach ->
                @storeHandler = sinon.stub()
                @departmentHandler = sinon.stub()

                @department = store.createDepartment("dept")

                store.on("added", @storeHandler)
                @department.on("added", @departmentHandler)

                @department.set("key", "foo")

            it "should cause the namespaced key 'dept/key' to be created in the parent store", ->
                val = store.has("dept/key")
                val.should.be.equal(true)

            it "should publish an 'added' in the store with 'dept/key'", ->
                spyCall = @storeHandler.getCall(0)
                spyCall.args[0].should.equal("foo")
                spyCall.args[1].should.equal("dept/key")

            it "should publish an 'added' in the department with just 'key'", ->
                spyCall = @departmentHandler.getCall(0)
                spyCall.args[0].should.equal("foo")
                spyCall.args[1].should.equal("key")

        describe "a set of 'dept/key' in a store", ->
            beforeEach ->
                @storeHandler = sinon.stub()
                @departmentHandler = sinon.stub()

                @department = store.createDepartment("dept")

                store.on("added", @storeHandler)
                @department.on("added", @departmentHandler)

                store.set("dept/key", "foo")

            it "should cause 'key' to be created in the department", ->
                val = @department.has("key")
                val.should.be.equal(true)

            it "should publish an 'added' in the store with 'dept/key'", ->
                spyCall = @storeHandler.getCall(0)
                spyCall.args[0].should.equal("foo")
                spyCall.args[1].should.equal("dept/key")

            it "should publish an 'added' in the department with just 'key'", ->
                spyCall = @departmentHandler.getCall(0)
                spyCall.args[0].should.equal("foo")
                spyCall.args[1].should.equal("key")
