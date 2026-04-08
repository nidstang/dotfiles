Lee mi archivo .md que te paso donde está el PRD y compílalo en un archivo estrictamente estructurado llamado `PRD.json` (si ya existe un PRD.json preguntale al usuario que hacer)

Cada elemento de mi feature debe convertirse en un objeto JSON dentro de un array principal. Debes inferir los pasos y criterios de aceptación específicos para cada tarea.

El formato JSON estricto para CADA tarea debe ser exactamente este:
{
  "id": "Un identificador corto, ej: TASK-1",
  "category": "functional | UI | database | config | architecture",
  "description": "Descripción concisa de la funcionalidad",
  "context": "Contexto de negocio o técnico para que no pierdas la visión global al implementar esto",
  "steps": [
    "Paso de verificación 1",
    "Paso de verificación 2",
    "Paso de verificación 3"
  ],
  "passes": false
}

Reglas críticas:
1. Divide las tareas en "rebanadas verticales" (vertical slices) pequeñas y comprobables.
2. Todas las tareas nuevas deben inicializarse con `"passes": false`.
3. Sé muy específico en el array de `"steps"`, ya que serán los criterios de aceptación que tendrás que validar luego.
4. Genera el archivo `PRD.json` en la raíz de este directorio.
