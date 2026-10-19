<?php
$servername = "localhost";
$username = "migueltg6";
$password = "grSETDFHyppR";
$database = "migueltg6";
$conn = new mysqli($servername,$username,$password,$database);

if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

?>