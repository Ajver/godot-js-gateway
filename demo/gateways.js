class IDefaultGateway {
	constructor() {
		this.eventsArray = [];

		// How many events was readed and whitch one is readed now
		this.currentEventIndex = 0;
	}
	
	// Creates and pushs the new event to the events array
	newEvent(eName, eData) { 
		this.eventsArray.push({
			name: eName, 
			data: eData
		});
	}
	
	// If has any unreaded event
	hasEvent() {
		return this.currentEventIndex < this.eventsArray.length;
	}
			
	// Called after reading all events in frame. It clears every READED event (and if there is some unreaded one, the function leaves it)
	clearEventsArray() { 
		// currentEventIndex also stores number of readed events so we remove all readed events from array
		this.eventsArray.splice(0, this.currentEventIndex);
		this.currentEventIndex = 0;
	}
}

// Communication ReactJS -> Godot
class GatewayToGodot extends IDefaultGateway {
	getCurrentEvent() {
		return this.eventsArray[this.currentEventIndex];
	}
	
	getCurrentEventName() {
		return this.getCurrentEvent().name;
	}
	
	getCurrentEventData() {
		return this.getCurrentEvent().data;
	}
	
	// Increase readed events counter 
	next() {
		this.currentEventIndex++;
	}
}

// Communication Godot -> JS
class GatewayToJS extends IDefaultGateway {
	// Returning event object and moving counter forwards
	popEvent() {
		return this.eventsArray[this.currentEventIndex++];
	}
}

// Events happens in JS to tell Godot app
const gatewayToGodot = new GatewayToGodot();

// Events happens in Godot to tell JS app
const gatewayToJS = new GatewayToJS();



