function getProcessingInstance(){
    let pjs = Processing.getInstanceById("Minesweeper");
    if (pjs == undefined){
        setTimeout(getProcessingInstance, 100);
        return
    }
    
    console.log(pjs.getInteractiveMethodNames());
    document.getElementById("staticMethodSpan").innerText = pjs.getInteractiveMethodNames();
}

window.onload = function(){
    getProcessingInstance();
};
