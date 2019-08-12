
List of Sites
=============

The list of sites is:

<div id="sites"></div>

<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script>

$.get("https://b5ms5dkmia.execute-api.ap-southeast-2.amazonaws.com/test/data-by-doi/10.25845/5c09bf93f315d/sites")
.done(populateSites);

function populateSites(data) { populate("Sites", "sites", data); }

function populate(title, divId, data) {
  console.log(data);
  $("#" + divId).append("<h4>" + title + "</h4>");
  data.forEach(item => $("#" + divId).append("<p>" + item + "</p>"));
}

</script>
