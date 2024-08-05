function fetchData(data, url, callback) {
    var xhr = new XMLHttpRequest();

    xhr.onreadystatechange = function(){
        if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
            print("HEADERS RECEIVED")
        } else if (xhr.readyState === XMLHttpRequest.DONE) {
            print("DONE")
            if (xhr.status === 200) {
                callback(xhr.responseText.toString());
            } else {
                callback(null);
            }
        }
    };

    xhr.open("POST", url);
    xhr.setRequestHeader("Content-Type", "application/json")
    xhr.send(data);
}
