/**
 * Created by Lena Lebedeva on 25.03.2017.
 */
function hidePage(page) {
    page.style.visibility = "hidden";
    page.style.display = "none";
}

function showPage(page) {
    page.style.visibility = "visible";
    page.style.display = "block";
}

function showNextPage() {
    var parent = this.parentElement;
    hidePage(parent);
    var nextPage = document.getElementById(parseInt(parent.id) + 1);
    showPage(nextPage);
}

function showPreviousPage() {
    var parent = this.parentElement;
    hidePage(parent);
    var previousPage = document.getElementById(parseInt(parent.id) - 1);
    showPage(previousPage);
}

window.onload = function() {
    var nextButtons = document.getElementsByClassName("next");
    var previousButtons = document.getElementsByClassName("previous");
    for (var i = 0; i < nextButtons.length; i++) {
        nextButtons[i].addEventListener("click", showNextPage);
        previousButtons[i].addEventListener("click", showPreviousPage);
    }
}
