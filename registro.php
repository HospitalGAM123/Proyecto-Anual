<?php
session_start();
require_once 'conexion.php';

// Capturamos las variables coincidiendo con el name del HTML
$usuario = $_POST['username'] ?? '';
$contrasenia = $_POST['password'] ?? '';

if (empty($usuario) || empty($contrasenia)) {
    echo "Por favor complete todos los campos.";
    exit;
}

// Preparamos la consulta para buscar el usuario
$stmt = $con->prepare("SELECT * FROM funcionarios WHERE usuario = ?");
$stmt->bind_param("s", $usuario);
$stmt->execute();

$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();

    // Verificamos si la contraseña coincide
    // Si en tu BD usas password_hash():
    if (password_verify($contrasenia, $row['contrasenia'])) {
        $_SESSION['usuario'] = $row['usuario'];
        echo "¡Inicio de sesión exitoso! Bienvenido, " . htmlspecialchars($row['usuario']);
        // Podés redirigir a un panel con: header("Location: panel.php");
    } 
    // Si tus contraseñas aún están en texto plano (solo para pruebas):
    else if ($contrasenia === $row['contrasenia']) {
        $_SESSION['usuario'] = $row['usuario'];
        echo "¡Inicio de sesión exitoso!";
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