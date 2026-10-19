<?php
header('Content-Type: application/json');

include 'Connect.php';

if ($conn->connect_error) {
    echo json_encode(['success' => false, 'error' => "Connection failed: " . $conn->connect_error]);
    exit();
}

if (isset($_POST["action"])) {
    $action = $_POST["action"];

    switch ($action) {

        case "newPlayer":
            $name = $_POST['p_name'];
            $country = $_POST['p_country'];
            $age = $_POST['p_age'];
            $gender = $_POST['p_gender'];
            $date = $_POST['p_date'];

            $stmt = $conn->prepare("INSERT INTO Players (Name, Country, Age, Gender, CreateDate) VALUES (?, ?, ?, ?, ?)");
            $stmt->bind_param("ssids", $name, $country, $age, $gender, $date);

            if ($stmt->execute() === TRUE) {
                $last_id = $conn->insert_id;
                echo json_encode(['success' => true, 'id' => $last_id]);
            } else {
                echo json_encode(['success' => false, 'error' => $stmt->error]);
            }
            $stmt->close();
            break;

        case "newSession":
            $player_id = $_POST['p_id'];
            $start_date = $_POST['s_date'];

            $stmt = $conn->prepare("INSERT INTO Sessions (PlayerID, StartTime) VALUES (?, ?)");
            $stmt->bind_param("is", $player_id, $start_date);

            if ($stmt->execute() === TRUE) {
                $last_id = $conn->insert_id;
                echo json_encode(['success' => true, 'id' => $last_id]);
            } else {
                echo json_encode(['success' => false, 'error' => $stmt->error]);
            }
            $stmt->close();
            break;

        case "endSession":
            $session_id = $_POST['s_id'];
            $end_date = $_POST['s_date'];

            $stmt = $conn->prepare("UPDATE Sessions 
                                    SET EndTime = ?, 
                                        SessionLengthSeconds = TIMESTAMPDIFF(SECOND, StartTime, ?)
                                    WHERE SessionID = ?");
            $stmt->bind_param("ssi", $end_date, $end_date, $session_id);

            if ($stmt->execute() === TRUE) {
                echo json_encode(['success' => true, 'id' => $session_id]);
            } else {
                echo json_encode(['success' => false, 'error' => $stmt->error]);
            }
            $stmt->close();
            break;

        case "buyItem":
            $session_id = $_POST['s_id'];
            $item_id = $_POST['item_id'];
            $date = $_POST['b_date'];

            $stmt = $conn->prepare("INSERT INTO Purchases (SessionID, ItemID, PurchaseDate) VALUES (?, ?, ?)");
            $stmt->bind_param("iis", $session_id, $item_id, $date);
            
            if ($stmt->execute() === TRUE) {
                $last_id = $conn->insert_id;
                echo json_encode(['success' => true, 'id' => $last_id]);
            } else {
                echo json_encode(['success' => false, 'error' => $stmt->error]);
            }
            $stmt->close();
            break;
            
        default:
            echo json_encode(['success' => false, 'error' => 'Invalid action specified.']);
            break;
    }
} else {
    echo json_encode(['success' => false, 'error' => 'No action specified.']);
}
 
$conn->close();
?>