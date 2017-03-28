/**
 * Created by Lena Lebedeva on 28.03.2017.
 */
function checkCompulsoryFields(page) {
    var children = page.children;
    for (var i = 0; i < children.length; i++){
        if (children[i].className == "compulsoryField" && children[i].value == ""){
            alert("All compulsory fields should be filled in.");
            return false;
        }
    }
    return true;
}