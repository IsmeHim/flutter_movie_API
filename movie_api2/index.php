<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE'); //ระบุว่า API รองรับวิธี GET, POST, PUT, DELETE
header('Access-Control-Allow-Headers: Content-Type'); 

//เชื่อมต่อฐานข้อมูล
$conn = new mysqli('localhost', 'root', '', 'movie_collection');

if ($conn->connect_error) {
    die(json_encode(['error' => 'Connection failed']));
}
//รับค่าประเภทของ HTTP request ที่ถูกส่งเข้ามา
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET': // ดึงข้อมูลจากฐานข้อมูล
        $result = $conn->query('SELECT * FROM movies');
        $movies = [];
        while ($row = $result->fetch_assoc()) {
            $movies[] = $row;
        }
        echo json_encode($movies);
        break;

    case 'POST': // เพิ่มข้อมูลใหม่ลงในฐานข้อมูล
        $data = json_decode(file_get_contents('php://input'), true);
        $stmt = $conn->prepare('INSERT INTO movies (title, director, year, genre, image_url) VALUES (?, ?, ?, ?, ?)');
        $stmt->bind_param('sssss', $data['title'], $data['director'], $data['year'], $data['genre'], $data['image_url']);
        $stmt->execute();
        echo json_encode(['id' => $conn->insert_id]);
        break;

    case 'PUT': // อัปเดตข้อมูลในฐานข้อมูล
        $data = json_decode(file_get_contents('php://input'), true);
        $stmt = $conn->prepare('UPDATE movies SET title=?, director=?, year=?, genre=?, image_url=? WHERE id=?');
        $stmt->bind_param('sssssi', $data['title'], $data['director'], $data['year'], $data['genre'], $data['image_url'], $data['id']);
        $stmt->execute();
        echo json_encode(['success' => true]);
        break;

    case 'DELETE': // ลบข้อมูลจากฐานข้อมูล
        $id = $_GET['id'];
        $stmt = $conn->prepare('DELETE FROM movies WHERE id=?');
        $stmt->bind_param('i', $id);
        $stmt->execute();
        echo json_encode(['success' => true]);
        break;
}

$conn->close();
?>