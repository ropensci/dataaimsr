// load sites

$.get("https://b5ms5dkmia.execute-api.ap-southeast-2.amazonaws.com/prod/data-by-doi/10.25845/5c09bf93f315d/sites", populate)

function populate(data) {

  var sites = JSON.parse(data);
  sites.forEach(site => $("sites").append(site));
  console.log(sites);
}
