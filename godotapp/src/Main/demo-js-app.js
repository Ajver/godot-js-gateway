
document.gatewayToJS.addEventListener("ready", () => {
	createDemoEventButton();
})

document.gatewayToJS.addEventListener("message_from_godot", data => {
	alert(data);
})


const createDemoEventButton = () => {
	const btn = document.createElement('button');
	btn.addEventListener('click', () => {
		document.gatewayToGodot.newEvent('message_from_js', 'This message comes from JS App');
	})
	
	btn.innerHTML = 'Call JS event';
	
	btn.style.position = 'fixed';
	btn.style.right = 0;
	btn.style.top = 0;
	btn.style.zIndex = 10;
	
	const body = document.querySelector('body')
	body.appendChild(btn)
}