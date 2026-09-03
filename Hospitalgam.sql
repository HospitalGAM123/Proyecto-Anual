CREATE TABLE IF NOT EXISTS `usuario` (
	`id_usuario_pk` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
	`nombre` VARCHAR(255),
	`email` VARCHAR(255),
	`contraseña` VARCHAR(255),
	`rol` TEXT(65535),
	`cedula` VARCHAR(255),
	PRIMARY KEY(`id_usuario_pk`)
);


CREATE TABLE IF NOT EXISTS `documento` (
	`id_docuemento_pk` INTEGER UNSIGNED NOT NULL,
	`titulo` VARCHAR(255),
	`descripcion` VARCHAR(255),
	`codigo` VARCHAR(255),
	`contenido` VARCHAR(255),
	`archivo_url` VARCHAR(255),
	`usuario_id` INT COMMENT 'FK → usuario.id_usuario_pk',
	`qr_id` INT COMMENT 'FK → código_QR.id_qr_pk',
	PRIMARY KEY(`id_docuemento_pk`)
);


CREATE TABLE IF NOT EXISTS `ambulancia` (
	`id_ambulancia_pk` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
	`estado` VARCHAR(255),
	`matricula` VARCHAR(255),
	`paciente_id` INT COMMENT 'FK → paciente.id_paciente_pk',
	PRIMARY KEY(`id_ambulancia_pk`)
);


CREATE TABLE IF NOT EXISTS `paciente` (
	`id_paciente_pk` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
	`nombre` VARCHAR(255),
	`documento ` VARCHAR(255),
	`fecha_nacimiento` VARCHAR(255),
	`documento_id` INT COMMENT 'FK → documento.id_docuemento_pk',
	PRIMARY KEY(`id_paciente_pk`)
);


CREATE TABLE IF NOT EXISTS `código QR` (
	`id_qr_pk` INTEGER UNSIGNED NOT NULL,
	`codigo` VARCHAR(255),
	`fecha_generacion` VARCHAR(255),
	PRIMARY KEY(`id_qr_pk`)
);


CREATE TABLE IF NOT EXISTS `encuesta` (
	`id_encuesta_pk` INTEGER UNSIGNED NOT NULL,
	`descripcion ` VARCHAR(255),
	`respuesta` VARCHAR(255),
	`titulo` VARCHAR(255),
	`paciente_id` INT COMMENT 'FK → paciente.id_paciente_pk',
	`qr_id` INT COMMENT 'FK → código QR.id_qr_pk',
	PRIMARY KEY(`id_encuesta_pk`)
);


CREATE TABLE IF NOT EXISTS `pregunta` (
	`id_pregunta_pk` INTEGER UNSIGNED NOT NULL,
	`titulo` VARCHAR(255),
	`tipo` VARCHAR(255),
	`encuesta_id` INT COMMENT 'FK → encuesta.id_encuesta_pk',
	PRIMARY KEY(`id_pregunta_pk`)
);


CREATE TABLE IF NOT EXISTS `traslado` (
	`id_traslado_pk` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
	`hora_salida` TIME,
	`estado` VARCHAR(255),
	`hora_llegada` TIME,
	`fecha` DATE,
	`conductor_id` INT COMMENT 'FK → conductor.id_conductor_pk',
	`ruta_id` INT COMMENT 'FK → ruta.id_ruta_pk',
	`ambulancia_id` INT COMMENT 'FK → ambulancia.id_ambulancia_pk',
	PRIMARY KEY(`id_traslado_pk`)
);


CREATE TABLE IF NOT EXISTS `conductor` (
	`id_conductor_pk` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
	`nombre` VARCHAR(255),
	`telefono` VARCHAR(255),
	PRIMARY KEY(`id_conductor_pk`)
);


CREATE TABLE IF NOT EXISTS `copiloto` (
	`id_copiloto_pk` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
	`nombre` VARCHAR(255),
	`telefono` VARCHAR(255),
	`traslado_id` INT COMMENT 'FK → traslado.id_traslado_pk',
	PRIMARY KEY(`id_copiloto_pk`)
);


CREATE TABLE IF NOT EXISTS `ruta` (
	`id_ruta_pk` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
	`ditancia` INTEGER,
	PRIMARY KEY(`id_ruta_pk`)
);


ALTER TABLE `documento`
ADD FOREIGN KEY(`usuario_id`) REFERENCES `usuario`(`id_usuario_pk`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `paciente`
ADD FOREIGN KEY(`documento_id`) REFERENCES `documento`(`id_docuemento_pk`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `ambulancia`
ADD FOREIGN KEY(`paciente_id`) REFERENCES `paciente`(`id_paciente_pk`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `traslado`
ADD FOREIGN KEY(`conductor_id`) REFERENCES `conductor`(`id_conductor_pk`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `copiloto`
ADD FOREIGN KEY(`traslado_id`) REFERENCES `traslado`(`id_traslado_pk`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `traslado`
ADD FOREIGN KEY(`ruta_id`) REFERENCES `ruta`(`id_ruta_pk`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `traslado`
ADD FOREIGN KEY(`ambulancia_id`) REFERENCES `ambulancia`(`id_ambulancia_pk`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `documento`
ADD FOREIGN KEY(`qr_id`) REFERENCES `código QR`(`id_qr_pk`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `encuesta`
ADD FOREIGN KEY(`qr_id`) REFERENCES `código QR`(`id_qr_pk`)
ON UPDATE NO ACTION ON DELETE NO ACTION;