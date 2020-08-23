<?php
$servername = "localhost";
$username = "newuser";
$password = "asdf";
$database = "db";


$conn = mysqli_connect($servername, $username, $password, $database);

if ($conn->connect_error) {
    die("ERROR: Could not connect. " . $conn->connect_error);
}

?>
