var methodNames = Processing.getInstanceById("Minesweeper").getInteractiveMethodNames();
console.log(methodNames);
document.getElementById("staticMethodSpan").innerText = methodNames;
