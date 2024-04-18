#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use HTML::TableExtract;

# Connect to the database
my $dsn = "DBI:mysql:database=squad";
my $username = "superadmin";
my $password = "ajfshlajbfsljsdf123akndf";
my $dbh = DBI->connect($dsn, $username, $password) or die "Connection error: $DBI::errstr";

# HTML code with website information
my $html_code = <<'HTML';
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Website Info</title>
</head>
<body>

<h2>Website Information</h2>

<table>
    <thead>
        <tr>
            <th>Site</th>
            <th>Domain</th>
            <th>API Key</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Global</td>
            <td>ringteam.next</td>
            <td>qazwsxedc1234</td>
        </tr>
        <tr>
            <td>Local</td>
            <td>squad.go</td>
            <td>qazwsxedc5678</td>
        </tr>
        <tr>
            <td>Home</td>
            <td>ring.to</td>
            <td>qazwsxedc9012</td>
        </tr>
        <tr>
            <td>Back</td>
            <td>squad.net</td>
            <td>qazwsxedc3456</td>
        </tr>
    </tbody>
</table>

</body>
</html>
HTML

# Extract table data from HTML code
my $te = HTML::TableExtract->new( headers => [qw(Site Domain API_Key)] );
$te->parse($html_code);

# Insert data into the database
my $sth = $dbh->prepare("INSERT INTO api_keys (site, domain, api_key) VALUES (?, ?, ?)");

foreach my $row ($te->rows) {
    my ($site, $domain, $api_key) = @$row;
    $sth->execute($site, $domain, $api_key);
}

$sth->finish();
$dbh->disconnect();

print "Data inserted into database successfully!\n";
