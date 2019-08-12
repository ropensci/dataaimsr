AIMS DataPlatform R Client
==========================

The list of sites is:

<div id="sites"></div>

<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script>

$.get("https://b5ms5dkmia.execute-api.ap-southeast-2.amazonaws.com/test/data-by-doi/10.25845/5c09bf93f315d/sites")
.done(populate);


function populate(data) {
  console.log(data);
  //var sites = JSON.parse(data);
  data.forEach(site => $("#sites").append("<p>" + site + "</p>"));
}

</script>
