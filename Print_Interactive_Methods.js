function getProcessingInstance(){
    let pjs = Processing.getInstanceById("Minesweeper");
    if (pjs == undefined){
        setTimeout(getProcessingInstance, 100);
        return
    }
    
    console.log(pjs.InteractiveMethodNames);
    document.getElementById("staticMethodSpan").innerText = pjs.InteractiveMethodNames;
}

window.onload = function(){
    getProcessingInstance();
};
