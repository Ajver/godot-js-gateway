// Communication JS -> Godot
class GatewayToGodot {
	_eventsArray = [];

	// How many events was readed and which one is readed now
	_currentEventIndex = 0;

	// Creates and pushs the new event to the events array
	newEvent(eName, eData) {
		this._eventsArray.push({
			name: eName,
			data: eData
		});
	}

	// If has any unreaded event
	hasEvent() {
		return this._currentEventIndex < this._eventsArray.length;
	}

	// Called after reading all events in frame. It clears every READED event (and if there is some unreaded one, the function leaves it)
	clearEventsArray() {
		// currentEventIndex also stores number of readed events so we remove all readed events from array
		this._eventsArray.splice(0, this._currentEventIndex);
		this._currentEventIndex = 0;
	}

	getCurrentEvent() {
		return this._eventsArray[this._currentEventIndex];
	}

	getCurrentEventName() {
		return this.getCurrentEvent().name;
	}

	getCurrentEventData() {
		return this.getCurrentEvent().data;
	}

	// Increase readed events counter 
	next() {
		this._currentEventIndex++;
	}
}

// Communication Godot -> JS
class GatewayToJS {
	_eventListeners = {};

	// Calls listeners for the new event
	newEvent(eName, eData) {
		this._callListeners(eName, eData);
	}

	_callListeners(eName, eData) {
		if (!this._eventListeners.hasOwnProperty(eName)) {
			return;
		}

		const arr = this._eventListeners[eName];

		for (let i = 0; i < arr.length; i++) {
			const callback = arr[i];
			callback(eData);
		}
	}

	addEventListener(eName, callback) {
		if (!this._eventListeners.hasOwnProperty(eName)) {
			this._eventListeners[eName] = [];
		}

		const arr = this._eventListeners[eName];
		arr.push(callback);
	}

	removeEventListener(eName, callback) {
		if (!this._eventListeners.hasOwnProperty(eName)) {
			return;
		}

		const arr = this._eventListeners[eName];

		for (let i = 0; i < arr.length; i++) {
			if (arr[i] == callback) {
				arr.splice(i, 1);
			}
		}
	}

	hasEventListener(eName, callback) {
		if (!this._eventListeners.hasOwnProperty(eName)) {
			return false;
		}

		const arr = this._eventListeners[eName];

		for (let i = 0; i < arr.length; i++) {
			if (arr[i] == callback) {
				return true;
			}
		}

		return false;
	}
}

// Events happens in JS to tell Godot app
document.gatewayToGodot = new GatewayToGodot();

// Events happens in Godot to tell JS app
document.gatewayToJS = new GatewayToJS();