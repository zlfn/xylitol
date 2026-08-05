

# XYLITOL
Añade **limpieza** y **frescura** a tus scripts de shell.

XYLITOL desempeña un papel similar al de [gum](https://github.com/charmbracelet/gum), pero al estar escrito en [Amber](https://amber-lang.com/),  
no depende de binarios externos y se mantiene completamente portátil.

## Ejecución

Simplemente descarga y ejecuta el script `xylitol.sh`. (Se requiere Bash 4.0 o superior.)  
Es necesario que la terminal tenga soporte ANSI.

o utiliza [Amber](https://amber-lang.com/) para compilar un script Bash a partir de código Amber.

```
bash <(curl -s "https://raw.githubusercontent.com/amber-lang/amber/master/setup/install.sh")
amber build src/main.ab xylitol.sh
```

## Comandos
* [`choose`](#choose): Elige una opción de una lista de opciones.
* [`input`](#input): Solicita una entrada al usuario.
* [`confirm`](#confirm): Solicita confirmación al usuario (sí/no).
* [`file`](#file): Selecciona un archivo del sistema.

## Choose
Elige una opción de una lista de opciones.

<img width="1200" height="381" alt="image" src="https://github.com/user-attachments/assets/dca320f6-6bdd-4fa1-abe2-b97a6f7a4cde" />


```bash
cat songs.txt | ./xylitol.sh choose
cat foods.txt | ./xylitol.sh choose --header="Grocery Shopping"
```


## Input
Solicita una entrada mediante un comando simple.

<img width="1200" height="151" alt="image" src="https://github.com/user-attachments/assets/8ffcd022-a55c-4614-aa6a-5b2783c7ea71" />



```bash
./xylitol.sh input > answer.txt
./xylitol.sh input --prompt="Enter password: " --password > password.txt
```


## Confirm
Solicita confirmación al usuario (sí/no).

<img width="1200" height="184" alt="image" src="https://github.com/user-attachments/assets/2eb07a60-eae6-44e6-aa36-a28c4e33c720" />


```bash
./xylitol.sh confirm && rm file.txt || echo "File not removed"
```

## File
Solicita al usuario que seleccione un archivo del árbol de directorios.

<img width="1200" height="449" alt="image" src="https://github.com/user-attachments/assets/94d44b95-7be6-48e6-9ddf-6588bb787b91" />

```bash
./xylitol.sh file ~/.config
```

### Probado en
```
- macOS 15+ / iTerm2 3.6.2+ / GNU bash 5.3.3+
- macOS 15+ / iTerm2 3.6.2+ / Bash subshell in nushell 0.101.0+
- Arch Linux ARM / Wezterm 20240203+ / GNU bash 5.3.3+
```
