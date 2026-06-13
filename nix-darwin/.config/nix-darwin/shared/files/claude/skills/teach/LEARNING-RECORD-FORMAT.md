# Formato de los Registros de Aprendizaje
Los registros de aprendizaje viven en `./learning-records/` y usan numeración secuencial: `0001-slug.md`, `0002-slug.md`, etc. Crea el directorio de forma perezosa — solo cuando se escriba el primer registro.
Son el equivalente educativo de los ADRs: capturan lecciones no obvias, insights clave y conocimiento previo declarado que guiarán sesiones futuras. Se usan para calcular la zona de desarrollo próximo.
## Plantilla
```md
# {Título corto de lo que se aprendió o estableció}
{1-3 frases: qué se aprendió (o qué conocimiento previo se estableció), y por qué importa para sesiones futuras.}
```
Ese es todo el formato. Un registro de aprendizaje puede ser un único párrafo. El valor está en registrar _que_ esto ahora se sabe y _por qué_ cambia lo que hay que enseñar a continuación — no en rellenar secciones.
## Secciones opcionales
Inclúyelas solo cuando aporten un valor genuino. La mayoría de los registros no las necesitarán.
- **Status** en frontmatter (`active | superseded by LR-NNNN`) — útil cuando un entendimiento anterior resulta ser incorrecto y es reemplazado.
- **Evidencia** — cómo demostró el usuario el entendimiento (una pregunta respondida, un ejercicio completado, experiencia previa citada). Útil cuando la afirmación podría revisitarse.
- **Implicaciones** — qué desbloquea o descarta esto para sesiones futuras. Vale la pena registrarlo cuando no es obvio.
## Numeración
Escanea `./learning-records/` buscando el número más alto existente e incrementa en uno.
## Cuándo escribir un registro de aprendizaje
Escribe uno cuando se cumpla alguna de estas:
1. **El usuario demostró un entendimiento genuino de algo no trivial** — no solo exposición, sino evidencia de que puede usar el concepto correctamente. Esto establece un nuevo suelo para lo que hay que enseñar a continuación.
2. **El usuario reveló conocimiento previo** — "Ya sé X." Regístralo para que las sesiones futuras no lo vuelvan a enseñar. Registra también la _profundidad_ declarada.
3. **Se corrigió un concepto erróneo** — el usuario creía algo incorrecto antes y ahora ve por qué. Estos son de alto valor: predicen futuros tropiezos en temas relacionados.
4. **La misión cambió como respuesta al aprendizaje** — el usuario descubrió que le importaba algo distinto de lo que pensaba. Enlaza con [[MISSION.md]] y actualízalo.
### Qué _no_ cualifica
- Material que simplemente se cubrió. Cubrir no es aprender. Espera a la evidencia.
- Cualquier cosa ya capturada de forma escueta en [[GLOSSARY.md]] como definición de un término. No dupliques.
- Registros de actividad sesión por sesión. Los registros de aprendizaje no son un diario — son insights de calibre de decisión.
## Supersesión
Cuando un registro posterior contradiga uno anterior (el entendimiento del usuario se profundizó o corrigió), marca el registro antiguo como `Status: superseded by LR-NNNN` en vez de borrarlo. La historia de cómo evolucionó el entendimiento es en sí misma señal útil.
