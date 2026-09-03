CREATE TABLE IF NOT EXISTS `usuario` (
    `id_usuario_pk` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(255) NOT NULL,
    `email` VARCHAR(255) NOT NULL UNIQUE,
    `contraseña` VARCHAR(255) NOT NULL,
    `rol` VARCHAR(50) NOT NULL DEFAULT 'usuario',
    `cedula` VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY(`id_usuario_pk`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `codigo_qr` (
    `id_qr_pk` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `codigo` VARCHAR(255) NOT NULL,
    `fecha_generacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(`id_qr_pk`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `documento` (
    `id_documento_pk` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `titulo` VARCHAR(255) NOT NULL,
    `descripcion` VARCHAR(255),
    `codigo` VARCHAR(255),
    `contenido` TEXT,
    `archivo_url` VARCHAR(255),
    `usuario_id` INTEGER UNSIGNED NOT NULL,
    `qr_id` INTEGER UNSIGNED NULL,
    PRIMARY KEY(`id_documento_pk`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `paciente` (
    `id_paciente_pk` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(255) NOT NULL,
    `documento` VARCHAR(50) NOT NULL UNIQUE,
    `fecha_nacimiento` DATE NOT NULL,
    `documento_id` INTEGER UNSIGNED NULL,
    PRIMARY KEY(`id_paciente_pk`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `ambulancia` (
    `id_ambulancia_pk` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `estado` VARCHAR(50) NOT NULL,
    `matricula` VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY(`id_ambulancia_pk`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `ruta` (
    `id_ruta_pk` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `distancia_km` DECIMAL(6,2),
    PRIMARY KEY(`id_ruta_pk`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `conductor` (
    `id_conductor_pk` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(255) NOT NULL,
    `telefono` VARCHAR(50),
    PRIMARY KEY(`id_conductor_pk`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `traslado` (
    `id_traslado_pk` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `fecha` DATE NOT NULL,
    `hora_salida` TIME,
    `hora_llegada` TIME,
    `estado` VARCHAR(50) NOT NULL,
    `conductor_id` INTEGER UNSIGNED NOT NULL,
    `ruta_id` INTEGER UNSIGNED NOT NULL,
    `ambulancia_id` INTEGER UNSIGNED NOT NULL,
    `paciente_id` INTEGER UNSIGNED NOT NULL,
    PRIMARY KEY(`id_traslado_pk`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `copiloto` (
    `id_copiloto_pk` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(255) NOT NULL,
    `telefono` VARCHAR(50),
    `traslado_id` INTEGER UNSIGNED NOT NULL,
    PRIMARY KEY(`id_copiloto_pk`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `encuesta` (
    `id_encuesta_pk` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `titulo` VARCHAR(255) NOT NULL,
    `descripcion` VARCHAR(255),
    `respuesta` VARCHAR(255),
    `paciente_id` INTEGER UNSIGNED NOT NULL,
    `qr_id` INTEGER UNSIGNED NULL,
    PRIMARY KEY(`id_encuesta_pk`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `pregunta` (
    `id_pregunta_pk` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `titulo` VARCHAR(255) NOT NULL,
    `tipo` VARCHAR(50) NOT NULL,
    `encuesta_id` INTEGER UNSIGNED NOT NULL,
    PRIMARY KEY(`id_pregunta_pk`)
) ENGINE=InnoDB;

-- RELACIONES (LLAVES FORÁNEAS)
ALTER TABLE `documento`
    ADD CONSTRAINT `fk_doc_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuario`(`id_usuario_pk`) ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT `fk_doc_qr` FOREIGN KEY (`qr_id`) REFERENCES `codigo_qr`(`id_qr_pk`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `paciente`
    ADD CONSTRAINT `fk_paciente_doc` FOREIGN KEY (`documento_id`) REFERENCES `documento`(`id_documento_pk`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `traslado`
    ADD CONSTRAINT `fk_traslado_conductor` FOREIGN KEY (`conductor_id`) REFERENCES `conductor`(`id_conductor_pk`) ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT `fk_traslado_ruta` FOREIGN KEY (`ruta_id`) REFERENCES `ruta`(`id_ruta_pk`) ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT `fk_traslado_ambulancia` FOREIGN KEY (`ambulancia_id`) REFERENCES `ambulancia`(`id_ambulancia_pk`) ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT `fk_traslado_paciente` FOREIGN KEY (`paciente_id`) REFERENCES `paciente`(`id_paciente_pk`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `copiloto`
    ADD CONSTRAINT `fk_copiloto_traslado` FOREIGN KEY (`traslado_id`) REFERENCES `traslado`(`id_traslado_pk`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `encuesta`
    ADD CONSTRAINT `fk_encuesta_paciente` FOREIGN KEY (`paciente_id`) REFERENCES `paciente`(`id_paciente_pk`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `fk_encuesta_qr` FOREIGN KEY (`qr_id`) REFERENCES `codigo_qr`(`id_qr_pk`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `pregunta`
    ADD CONSTRAINT `fk_pregunta_encuesta` FOREIGN KEY (`encuesta_id`) REFERENCES `encuesta`(`id_encuesta_pk`) ON DELETE CASCADE ON UPDATE CASCADE;