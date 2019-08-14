


function populateSeries(data) {
  console.log(data);
  $("#series").append("<h4>Series</h4>");
  $("#series").append("<table><tr><th>Series ID</th><th>Series Name</th></tr>")
  data.forEach((series) => $("#series").append("<tr><td>" + series.series_id + "</td><td>" + series.series_name + "</td></tr>"));
  $("#series").append("</table>");
}

function populateSites(data) { populate("Sites", "sites", data); }

function populateParameters(data) { populate("Parameters", "parameters", data); }

function populate(title, divId, data) {
  console.log(data);
  $("#" + divId).append("<h4>" + title + "</h4>");
  data.forEach(item => $("#" + divId).append("<p>" + item + "</p>"));
}

