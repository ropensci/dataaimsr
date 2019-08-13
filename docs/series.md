
List of Series ID and Name
==========================

When specifying a series the series Id should be used as the parameter value.  The list of series ID and name is:

<div id="series"></div>

<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script>

$.get("https://6aq0l8l806.execute-api.ap-southeast-2.amazonaws.com/prod/v1.0/10.25845/5c09bf93f315d/series")
.done(populateSeries);

function populateSeries(data) {
  console.log(data);
  $("#series").append("<h4>Series</h4>");
  $("#series").append("<table><tr><th>Series ID</th><th>Series Name</th></tr>")
  data.forEach((series) => $("#series").append("<tr><td>" + series.series_id + "</td><td>" + series.series_name + "</td></tr>"));
  $("#series").append("</table>");
}

</script>
