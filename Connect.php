<?php
$servername = "localhost";
$username = "oscaref1";
$password = "agVYc0LwpU4FNC2";
$database = "oscaref1";
$conn = new mysqli($servername,$username,$password,$database);

if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

?>