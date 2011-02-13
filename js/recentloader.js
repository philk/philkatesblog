function add_recent_links(url) {
    $('#recent').append("<ul>");
    $.getJSON(url, function(json) {
        $.each(json["entries"], function(i, item) {
            var service = item.via.name.toLowerCase();
            if (service == "philk's activity") {service = "github"};
            var serviceImg = '<a class="imglink" id="'+service+'" href="'+item.via.url+'"></a>';
            var liItem = '<article class="entry"><li>'+item.body+'</li></div>';
            var rel_date = '<time datetime="'+ item.date + '" class="date_and_time">'+jQuery.timeago(item.date)+'</div>';
            var output = serviceImg + liItem + rel_date;
            $('#recent ul').append(output);
//            console.log(output);
        });
    });
}
