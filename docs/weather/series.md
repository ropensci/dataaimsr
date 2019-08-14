
List of Series ID and Name
==========================

When specifying a series the series Id should be used as the parameter value.  The list of series ID and name is:

<div id="series"></div>

<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script src="../js/script.js"></script>
<script>

$.get("https://api.aims.gov.au/data/v1.0/10.25845/5c09bf93f315d/series")
.done(populateSeries);

</script>
