
List of Parameters
==================

The list of parameters is:

<div id="parameters"></div>

<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script>

$.get("https://b5ms5dkmia.execute-api.ap-southeast-2.amazonaws.com/test/data-by-doi/10.25845/5c09bf93f315d/parameters")
.done(populateParameters);

function populateParameters(data) { populate("Parameters", "parameters", data); }

function populate(title, divId, data) {
  console.log(data);
  $("#" + divId).append("<h4>" + title + "</h4>");
  data.forEach(item => $("#" + divId).append("<p>" + item + "</p>"));
}

</script>
