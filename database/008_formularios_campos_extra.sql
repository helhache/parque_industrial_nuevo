-- Migración 008: Nuevos tipos de campo y límites numéricos en formularios dinámicos

ALTER TABLE formulario_preguntas
    MODIFY COLUMN tipo ENUM('texto','textarea','numero','fecha','select','radio','checkbox','tabla','archivo','direccion') NOT NULL,
    ADD COLUMN IF NOT EXISTS min_valor DECIMAL(15,2) NULL AFTER opciones,
    ADD COLUMN IF NOT EXISTS max_valor DECIMAL(15,2) NULL AFTER min_valor;
