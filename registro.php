<?php
session_start();
require_once 'conexion.php';

// Capturamos los campos enviados desde el formulario
$usuario = $_POST['username'] ?? '';
$contrasenia = $_POST['password'] ?? '';

// Validación de campos vacíos
if (empty($usuario) || empty($contrasenia)) {
    header("Location: index.php?error=vacios");
    exit;
}

// Consulta a la tabla 'usuario' buscando por el campo 'nombre'
$stmt = $con->prepare("SELECT id_usuario_pk, nombre, contraseña, rol FROM usuario WHERE nombre = ?");
$stmt->bind_param("s", $usuario);
$stmt->execute();

$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();

    // Verificación de la contraseña (soporta hash o texto plano)
    if (password_verify($contrasenia, $row['contraseña']) || $contrasenia === $row['contraseña']) {
        $_SESSION['user_id'] = $row['id_usuario_pk'];
        $_SESSION['usuario'] = $row['nombre'];
        $_SESSION['rol'] = $row['rol'];

        header("Location: panel.php");
        exit;
    } else {
        header("Location: index.php?error=incorrecto");
        exit;
    }
} else {
    header("Location: index.php?error=incorrecto");
    exit;
}

$stmt->close();
$con->close();
?> 