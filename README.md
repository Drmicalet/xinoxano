
> *Xino xano* — Valencià per a alguna cosa petita, àgil i discret.

Imatge base de **Arch Linux privilegiada** amb **uv** per a experiments, proves i desenvolupament dins de K3s. 

## Per què xinoxano?

El nom ve de l'expressió valenciana *"xino xano"*, que descriu alguna cosa menuda, ràpida i que passa desapercebuda. Exactament el que necessitem per a un sandbox lleuger però potent:

- **Xino** = àgil, lleuger, ràpid
- **Xano** = diminutiu, discret, que no ocupa lloc

Un contenidor que fa el seu treball sense cridar l'atenció.

## Què inclou?

### Base heretada (arch-base-privileged)

| Component | Descripció |
|-----------|------------|
| Arch Linux | Última versió estable, rolling release |
| Contingut privilegiat | Necessari per a certs tools de seguretat i auditoria |
| Usuari `builder` | Per a instal·lar paquets AUR amb `yay` |
| `systemd` init | Completament funcional dins del contenidor |

### Afegits de xinoxano

| Eina | Versió | Propòsit |
|------|--------|----------|
| `uv` | pacman | Gestor de paquets Python ultraràpid (substitueix pip/venv) |
| `python` | 3.x | Intèrpret Python |
| `git` | pacman | Control de versions |
| `vim` | pacman | Editor de text |
| `curl` / `wget` | pacman | Transferències HTTP |
| `jq` | pacman | Processament JSON |

### Estructura de directoris

```
/opt/sandbox/
├── projects/      # Projectes i experiments
├── venvs/         # Entorns virtuals Python (gestionats per uv)
├── logs/          # Logs del sandbox
└── bin/           # Scripts personalitzats
```



### Contenidors del projecte

| Contenidor | Imatge base | Funció | Estat |
|------------|-------------|--------|-------|
| **xinoxano** | arch-base-privileged | Sandbox + uv | Actiu |
| **espardenyesbenlligades** | xinoxano | Seguretat perimetral + ENS | v19 |
| **melderomer** | arch-base-privileged | Honeypot | Acabat |


## Ús

### Construir

```bash
podman build --network=host -t xinoxano:latest .
```

### Executar com a sandbox

```bash
# Bash interactiva
podman run -it --rm xinoxano:latest

# Amb volum per a projectes
podman run -it --rm \
    -v /casa/v1-mlai/xinoxano/projects:/opt/sandbox/projects \
    xinoxano:latest
```

### Executar dins de K3s

```bash
# Accés al sandbox
kubectl -n mlai exec -it mlai05-xinoxano -- bash

# Executar una comanda
kubectl -n mlai exec mlai05-xinoxano -- uv run python script.py
```

## Python i uv

uv resol el problema clàssic dels entorns virtuals trencats per les actualitzacions de Python. Quan Arch actualitza de 3.12 a 3.13, els venvs creats amb `python -m venv` deixen de funcionar. Amb uv, això no passa.

```bash
# Crear un projecte nou
cd /opt/sandbox/projects
uv init meu-projecte

# Afegir dependències
cd meu-projecte
uv add requests fastapi

# Executar
uv run python main.py

# Entorn virtual explícit
uv venv .venv
source .venv/bin/activate
```

### Quan usar uv vs pip?

| Situació | Eina |
|----------|------|
| Projecte nou des de zero | `uv init` + `uv add` |
| Afegir una dependència ràpida | `uv add <paquet>` |
| Requisits d'un projecte existent | `uv pip install -r requirements.txt` |
| Instal·lar eines CLI globals | `uv tool install <paquet>` |
| Scripts del sistema (pip legacy) | `pip install --user` |

## Descàrrega

```bash
podman pull ghcr.io/drmicalet/xinoxano:latest
```

## Llicència

Projecte personal. Lliure ús amb menció.

---

*Drmicalet — [GitHub](https://github.com/Drmicalet)*
