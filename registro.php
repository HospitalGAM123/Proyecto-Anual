<?php 
require_once 'conexion.php';

$usuario = $_POST['usuario'];
$contrasenia = $_POST['contrasenia']; //... 
$stmt = % $con->prepare("SELECT * FROM funcionarios WHERE usuario = ?");
$stmt->bind_param("s", $usuario);
$stmt->execute();

$result = $stmt->get_result();

if ($result->num_rows > 0) {
    echo "El usuario ya existe.";
    exit;
}