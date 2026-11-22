-- Script SQL Obligatorio SIMTELE-RISK (Semana 2)
-- Compatible con SQLite / PostgreSQL

CREATE TABLE caso_estudio (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nombre VARCHAR(100) NOT NULL,
  modelo_version VARCHAR(20) NOT NULL
);

CREATE TABLE escenario (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  caso_id INTEGER NOT NULL REFERENCES caso_estudio(id),
  tipo VARCHAR(30) CHECK (tipo IN ('NORMAL','ESTRES','MAL_CONDICIONADO')),
  parametros_json TEXT NOT NULL,
  fuente_datos VARCHAR(120) NOT NULL
);

CREATE TABLE simulacion (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  escenario_id INTEGER NOT NULL REFERENCES escenario(id),
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  usuario_equipo VARCHAR(80),
  estado VARCHAR(30) DEFAULT 'COMPLETADO'
);

CREATE TABLE ejecucion_metodo (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  simulacion_id INTEGER NOT NULL REFERENCES simulacion(id),
  metodo VARCHAR(60) NOT NULL,
  tolerancia REAL,
  paso REAL,
  max_iter INTEGER,
  convergio BOOLEAN NOT NULL,
  tiempo_ms REAL NOT NULL
);

CREATE TABLE iteracion_resultado (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ejecucion_id INTEGER NOT NULL REFERENCES ejecucion_metodo(id),
  numero INTEGER NOT NULL,
  aproximacion_json TEXT NOT NULL,
  residual REAL,
  error_abs REAL,
  error_rel REAL
);

CREATE TABLE resultado_resumen (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ejecucion_id INTEGER NOT NULL REFERENCES ejecucion_metodo(id),
  referencia TEXT,
  valor_json TEXT NOT NULL,
  metrica_error_json TEXT NOT NULL,
  interpretacion TEXT
);

INSERT INTO caso_estudio (nombre, modelo_version) VALUES
('Detención de emergencia de cabinas', 'v2.0'),
('Deterioro mecánico y mantenimiento', 'v2.0'),
('Oscilaciones transversales por viento', 'v2.0'),
('Reconstrucción de señales de sensores', 'v2.0');
