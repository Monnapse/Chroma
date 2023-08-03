# Rodux API Reference

## Rodux.Store
The Store class is the core piece of Rodux. It is the state container that you create and use.

### Store.new
```
Store.new(reducer, [initialState, [middlewares, [errorReporter]]]) -> Store
```

Creates and returns a new Store.

* `reducer` is the store's root reducer function, and is invoked whenever an action is dispatched. It must be a pure function.
* `initialState` is the store's initial state. This should be used to load a saved state from storage.
* `middlewares` is a list of [middleware functions](#middleware) to apply each time an action is dispatched to the store.
* `errorReporter` is a [error reporter object](advanced/error-reporters.md) that allows custom handling of errors that occur during different phases of the store's updates

The store will automatically dispatch an initialization action with a `type` of `@@INIT`.

!!! note
	The initialization action does not pass through any middleware prior to reaching the reducer.

### Store.changed
```lua
store.changed:connect(function(newState, oldState)
	-- do something with newState or oldState
end)
```

A [Signal](#Signal) that is fired when the store's state is changed up to once per frame.

!!! warning
	Multiple actions can be grouped together into one changed event!

!!! danger
	Do not yield within any listeners on `changed`; an error will be thrown.

### Store:dispatch
```
store:dispatch(action) -> nil
```

Dispatches an action. The action will travel through all of the store's middlewares before reaching the store's reducer.

Unless handled by middleware, `action` must contain a `type` field to indicate what type of action it is. No other fields are required.

### Store:getState
```
store:getState() -> table
```

Gets the store's current state.

!!! warning
	Do not modify this state! Doing so will cause **serious** bugs your code!

### Store:destruct
```
store:destruct() -> nil
```

Destroys the store, cleaning up its connections.

!!! danger
	Attempting to use the store after `destruct` has been called will cause problems.

### Store:flush
```
store:flush() -> nil
```

Flushes the store's pending actions, firing the `changed` event if necessary.

!!! info
	`flush` is called by Rodux automatically every frame and usually doesn't need to be called manually.

## Signal
The Signal class in Rodux represents a simple, predictable event that is controlled from within Rodux. It cannot be created outside of Rodux, but is used as `Store.changed`.

### Signal:connect
```
signal:connect(listener) -> { disconnect }
```

Connects a listener to the signal. The listener will be invoked whenever the signal is fired.

`connect` returns a table with a `disconnect` function that can be used to disconnect the listener from the signal.

## Helper functions
Rodux supplies some helper functions to make creating complex reducers easier.

### Rodux.combineReducers
A helper function that can be used to combine multiple reducers into a new reducer.

```lua
local reducer = combineReducers({
	key1 = reducer1,
	key2 = reducer2,
})
```

`combineReducers` is functionally equivalent to writing:

```lua
local function reducer(state, action)
	return {
		key1 = reducer1(state.key1, action),
		key2 = reducer2(state.key2, action),
	}
end
```

### Rodux.createReducer
```
Rodux.createReducer(initialState, actionHandlers) -> reducer
```

A helper function that can be used to create reducers.

Unlike JavaScript, Lua has no `switch` statement, which can make writing reducers that respond to lots of actions clunky.

Reducers often have a structure that looks like this:

```lua
local initialState = {}

local function reducer(state, action)
	state = state or initialState

	if action.type == "setFoo" then
		-- Handle the setFoo action
	elseif action.type == "setBar" then
		-- Handle the setBar action
	end

	return state
end
```

`createReducer` can replace the chain of `if` statements in a reducer:

```lua
local initialState = {}

local reducer = createReducer(initialState, {
	setFoo = function(state, action)
		-- Handle the setFoo action
	end,

	setBar = function(state, action)
		-- Handle the setBar action
	end
})
```

### Rodux.makeActionCreator
```
Rodux.makeActionCreator(name, actionGeneratorFunction) -> actionCreator
```

A helper function that can be used to make action creators.

Action creators are helper objects that will generate actions from provided data and automatically populate the `type` field.

Actions often have a structure that looks like this:

```lua
local MyAction = {
	type = "SetFoo",
	value = 1,
}
```

They are often generated by functions that take the action's data as arguments:

```lua
local function SetFoo(value)
	return {
		type = "SetFoo",
		value = value,
	}
end
```

`makeActionCreator` looks similar, but it automatically populates the action's type with the action creator's name. This makes it easier to keep track of which actions your reducers are responding to:

Make an action creator in `SetFoo.lua`:
```lua
return makeActionCreator("SetFoo", function(value)
	-- The action creator will automatically add the 'type' field
	return {
		value = value,
	}
end)
```

Then check for that action by name in `FooReducer.lua`:
```lua
local SetFoo = require(SetFoo)
...
if action.type == SetFoo.name then
	-- change some state!
end
```

## Middleware
Rodux provides an API that allows changing the way that actions are dispatched called *middleware*. To attach middleware to a store, pass a list of middleware as the third argument to `Store.new`.

!!! warn
	The middleware API changed in [#29](https://github.com/Roblox/rodux/pull/29) -- middleware written against the old API will not work!

A single middleware is just a function with the following signature:

```
(nextDispatch, store) -> (action) -> result
```

A middleware is a function that accepts the next dispatch function in the *middleware chain*, as well as the store the middleware is being used with, and returns a new function. That function is called whenever an action is dispatched and can dispatch more actions, log to output, or perform any other side effects!

A simple version of Rodux's `loggerMiddleware` is as easy as:

```lua
local function simpleLogger(nextDispatch, store)
	return function(action)
		print("Dispatched action of type", action.type)

		return nextDispatch(action)
	end
end
```

Rodux also ships with several middleware that address common use-cases.

To apply middleware, pass a list of middleware as the third argument to `Store.new`:

```lua
local store = Store.new(reducer, initialState, { simpleLogger })
```

Middleware runs from left to right when an action is dispatched. That means that if a middleware does not call `nextDispatch` when handling an action, any middleware after it will not run.

For a more detailed example, see the [middleware guide](advanced/middleware.md).

### Rodux.loggerMiddleware
A middleware that logs actions and the new state that results from them.

`loggerMiddleware` is useful for getting a quick look at what actions are being dispatched. In the future, Rodux will have tools similar to [Redux's DevTools](https://github.com/gaearon/redux-devtools).

```lua
local store = Store.new(reducer, initialState, { loggerMiddleware })
```

### Rodux.thunkMiddleware
A middleware that allows thunks to be dispatched. Thunks are functions that perform asynchronous tasks or side effects, and can dispatch actions.

`thunkMiddleware` is comparable to Redux's [redux-thunk](https://github.com/gaearon/redux-thunk).

```lua
local store = Store.new(reducer, initialState, { thunkMiddleware })

store:dispatch(function(store)
	print("Hello from a thunk!")

	store:dispatch({
		type = "thunkAction"
	})
end)
```

### Rodux.makeThunkMiddleware (unreleased)
```
Rodux.makeThunkMiddleware(extraArgument) -> thunkMiddleware
```

A function that creates a thunk middleware that injects a custom argument when invoking thunks (in addition to the store itself). This is useful for cases like using an API service layer that could be swapped out for a mock service in tests.

```lua
local myThunkMiddleware = Rodux.makeThunkMiddleware(myCustomArg)
local store = Store.new(reducer, initialState, { myThunkMiddleware })

store:dispatch(function(store, myCustomArg)
	print("Hello from a thunk with extra argument:", myCustomArg)

	store:dispatch({
		type = "thunkAction"
	})
end)
```

## Error Reporters

In version 3.0.0+, the Rodux store can be provided with a custom error reporter. This is a good entry point to enable improved logging, debugging, and analytics. 

The error reporter interface is an object with two functions:

### reportReducerError
```
reportReducerError(prevState, action, errorResult) -> ()
```

Called when an error is thrown while processing an action through the reducer. If [thunk middleware](#RoduxthunkMiddleware) is included, errors encountered while executing thunks will also be caught and reported through this function.

The function receives these arguments:

* `prevState` - the last known state value for the store. Since this reporter catches errors that occurred before the reducer finished resolving, the `prevState` value will be equal to the store state _before the action was processed_
* `action` - the action that was being processed when the error occurred
* `errorResult` - an object describing the error that was caught

The default error reporter will simply rethrow the value from the caught errorResult.

### reportUpdateError
```
reportUpdateError(prevState, currentState, actionLog, errorResult) -> ()
```

Called when an error is thrown while updating listeners subscribed to the store state. Rodux flushes actions on a regular interval rather than synchronously, so there may be several actions queued up before each flush.

The last 3 actions that were received before the current flush are provided to the error reporter. This is currently hard coded in the store logic, but could be overridden with an option in the future if it's useful to do so.

The function receives these arguments:

* `prevState` - the last known state that was flushed to consumers _before_ the update that produced the error
* `currentState` - the new store state that was being flushed to consumers when the error occurred. Some consumers may have already processed to this new state by the time the reporter is called
* `actionLog` - an array containing the last three actions that were dispatched to the store, sorted from oldest to newest
* `errorResult` - an object describing the error that was caught

The default error reporter will simply rethrow the value from the caught errorResult.