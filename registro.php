<?php
session_start();
require_once 'conexion.php';


$usuario = $_POST['username'] ?? '';
$contrasenia = $_POST['password'] ?? '';

/
if (empty($usuario) || empty($contrasenia)) {
    echo "Por favor complete todos los campos.";
    exit;
}


$stmt = $con->prepare("SELECT * FROM funcionarios WHERE usuario = ?");
$stmt->bind_param("s", $usuario);
$stmt->execute();

$result = $stmt->get_result();


if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();

    /
    if (password_verify($contrasenia, $row['contrasenia'])) {
        $_SESSION['usuario'] = $row['usuario'];
        header("Location: panel.php"); 
        exit;
    } 
    
    else if ($contrasenia === $row['contrasenia']) {
        $_SESSION['usuario'] = $row['usuario'];
        header("Location: panel.php"); 
        exit;
    } 
    else {
        echo "Contraseña incorrecta.";
    }
} else {
    echo "El usuario no existe.";
}

$stmt->close();
$con->close();
?>