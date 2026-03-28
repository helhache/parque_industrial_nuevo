-- Migración 009: Tablas de formularios dinámicos (ministerio / empresa)
-- Ejecutar en producción si aparece: Table 'formularios_dinamicos' doesn't exist
-- Orden: esta migración sustituye crear las 3 tablas; incluye tipos de 008 (archivo, dirección, min/max).

CREATE TABLE IF NOT EXISTS formularios_dinamicos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    descripcion TEXT NULL,
    estado ENUM('borrador', 'publicado', 'archivado') NOT NULL DEFAULT 'borrador',
    creado_por INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_estado (estado),
    INDEX idx_creado_por (creado_por),
    FOREIGN KEY (creado_por) REFERENCES usuarios(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS formulario_preguntas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    formulario_id INT NOT NULL,
    tipo ENUM('texto', 'textarea', 'numero', 'fecha', 'select', 'radio', 'checkbox', 'tabla', 'archivo', 'direccion') NOT NULL,
    etiqueta VARCHAR(255) NOT NULL,
    ayuda VARCHAR(255) NULL,
    requerido TINYINT(1) DEFAULT 0,
    opciones LONGTEXT NULL,
    min_valor DECIMAL(15,2) NULL,
    max_valor DECIMAL(15,2) NULL,
    orden INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_formulario (formulario_id),
    FOREIGN KEY (formulario_id) REFERENCES formularios_dinamicos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS formulario_respuestas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    formulario_id INT NOT NULL,
    empresa_id INT NOT NULL,
    usuario_id INT NULL,
    estado ENUM('borrador', 'enviado') NOT NULL DEFAULT 'borrador',
    respuestas LONGTEXT NOT NULL,
    ip VARCHAR(45) NULL,
    enviado_at DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_formulario_empresa (formulario_id, empresa_id),
    INDEX idx_estado (estado),
    FOREIGN KEY (formulario_id) REFERENCES formularios_dinamicos(id) ON DELETE CASCADE,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
