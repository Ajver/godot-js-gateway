
// Called 20 times per second
window.setInterval(() => {
		
	if(document.gatewayToJS.hasEvent()) {		
		do {
			const event = document.gatewayToJS.popEvent();
			onEvent(event.name, event.data);
		}while(document.gatewayToJS.hasEvent());	
	
		document.gatewayToJS.clearEventsArray();
	}
	
}, 50);

const onEvent = (eventName, eventData) => {
	console.log("Got event from godot: ", eventName, eventData)

	switch(eventName) {
		case 'ready':
			createDemoEventButton();
			break;
		case 'message_from_godot':
			alert(eventData);
			break;
		default:
			console.log("Unexpected event:", eventName, eventData)
	}
}

const createDemoEventButton = () => {
	const btn = document.createElement('button');
	btn.addEventListener('click', () => {
		document.gatewayToGodot.newEvent('message', 'This message comes from JS App');
	})
	
	btn.innerHTML = 'Call JS event';
	
	// I know, that I should do this via css, but it's just demo
	btn.style.position = 'fixed';
	btn.style.right = 0;
	btn.style.top = 0;
	btn.style.zIndex = 10;
	
	const body = document.querySelector('body')
	body.appendChild(btn)
}