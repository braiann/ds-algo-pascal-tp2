{Trabajo Práctico 2 - Jonatan Rosales, Rafael Verde, Braian Villasanti}

program tp2;
uses wincrt, windows, sysutils, graph;
type
    tabla = array[1..10, 1..10] of integer;
    Smallint = -32768..32767;
var
    tablero, tableroOponente: tabla;
    Driver, Modo: Smallint;
    restantes1, restantes2, restantes3, restantes4, jugTurn, pieza, DigVer, InitPointX, InitPointY, i, color, patron, codigo: integer;
    salir, orientacion, selecValida: boolean;
    codigoNum: array[1..8] of integer;
    BinNum: array[1..8] of string;
    importe: string;

// Incrementa un valor que rota entre 1 y 4
function Inc4(n: integer): integer;
begin
    if n < 4 then // Si el numero es menor a 4, se incrementa en 1
        Inc4 := n + 1
    else          // Si el numero es 4, vuelve a ser 1
        Inc4 := 1;
end;

// Resta 1 de un valor que rota entre 1 y 4
function Dec4(n: integer): integer;
begin
    if n > 1 then // Si el numero es mayor a 1, se resta 1
        Dec4 := n - 1
    else          // Si el numero es 1, vuelve a ser 4
        Dec4 := 4;
end;

// Mueve el cursor hacia abajo en el menu principal
function PressedDown(seleccion: integer): integer;
begin
    // Incrementa en 1 el contador de la seleccion actual
    PressedDown := Inc4(seleccion);
    // Muestra el cambio en pantalla
    //MostrarMenu(PressedDown);
end;

// Mueve el cursor hacia arriba
function PressedUp(seleccion: integer): integer;
begin
    // Contador de la seleccion actual - 1
    PressedUp := Dec4(seleccion);
    // Muestra el cambio en la pantalla
    //MostrarMenu(PressedUp);
end;

{****1. BATALLA NAVAL****}

// Recibe un numero y devuelve string "restante" si el numero es 1, y "restantes" si el numero es distinto de 1 (Para indicar piezas restantes en Batalla Naval)
function RestantesPoS(n: integer): string;
begin
    if n = 1 then
        RestantesPoS := 'restante'
    else
        RestantesPoS := 'restantes';
end;

// Muestra los barcos en la pantalla
procedure MostrarBarcos;
var
    i, j, x, y: integer;
begin
    x := 115; // Coordenada inicial x en pixeles del primer lugar del tablero (1,1)
    y := 240; // Coordenada inicial x en pixeles del primer lugar del tablero (1,1)
    for i := 1 to 10 do
    begin
        for j := 1 to 10 do
        begin
            if (tablero[i, j] = 1) then // Colocar x color verde en tablero si es = 1 (colocacion temporal)
                OutTextXY(x, y, 'X')
            else if (tablero[i, j] = 2) then // Colocar x color blanco en tablero si es = 1 (colocacion permanente)
            begin
                SetColor(White);
                OutTextXY(x, y, 'X');
                SetColor(LightGreen);
            end;
            x := x + 40; // Se incrementa el valor en x por 40 pixeles (es decir, se "salta" al siguiente cuadro del tablero para colocar lo que corresponda ahi)
        end;
        y := y + 40; // Se incrementa el valor en y por 40 pixeles una vez que se termina con todos los cuadros de la fila
        x := 115; // Se vuelve al principio de las columnas para hacer la siguiente fila
    end;
end;

// Muestra el tablero
procedure MostrarTablero;
var
    i, j, x0, y0, x, y: integer;
begin
    ClearDevice;
    OutTextXY(80, 100, '-----------------------------Turno del jugador                              ');
    OutTextXY(830, 100, IntToStr(jugTurn));
    OutTextXY(80, 100, '                                                ----------------------------');
    OutTextXY(80, 140, 'Coloca las piezas en el tablero elijiendo el tamano, orientacion y posicion.');
    // Muestra coordenadas eje x
    SetTextStyle(10, HorizDir, 2);
    OutTextXY(70, 200, '0');
    OutTextXY(115, 200, '1');
    OutTextXY(155, 200, '2');
    OutTextXY(195, 200, '3');
    OutTextXY(235, 200, '4');
    OutTextXY(275, 200, '5');
    OutTextXY(315, 200, '6');
    OutTextXY(355, 200, '7');
    OutTextXY(395, 200, '8');
    OutTextXY(435, 200, '9');
    OutTextXY(465, 200, '10');
    // Muestra coordenadas eje y
    SetTextStyle(10, HorizDir, 2);
    OutTextXY(70, 240, '1');
    OutTextXY(70, 280, '2');
    OutTextXY(70, 320, '3');
    OutTextXY(70, 360, '4');
    OutTextXY(70, 400, '5');
    OutTextXY(70, 440, '6');
    OutTextXY(70, 480, '7');
    OutTextXY(70, 520, '8');
    OutTextXY(70, 560, '9');
    OutTextXY(60, 600, '10');
    SetColor(LightBlue);
    SetFillStyle(SolidFill, Blue);
    // Dibujar fondo azul del tablero
    Bar(100, 230, 500, 630);
    // Dibujar cuadricula del tablero
    y0 := 230;
    y := 270;
    for j := 1 to 10 do
    begin
        x0 := 100;
        x := 140;
        for i := 1 to 10 do
        begin
            Rectangle(x0, y0, x, y);
            x := x + 40;
            x0 := x0 + 40;
        end;
        y0 := y0 + 40;
        y := y + 40;
    end;
    // Muestra cantidad de barcos restantes
    SetTextStyle(10, HorizDir, 3);
    SetColor(LightGreen);
    OutTextXY(550, 200, 'Tamano del barco');
    SetTextStyle(10, HorizDir, 2);
    SetColor(White);
    OutTextXY(580, 250, '   X');
    SetColor(LightGreen);
    OutTextXY(660, 250, IntToStr(restantes1));
    OutTextXY(690, 250, RestantesPoS(restantes1));
    SetColor(White);
    OutTextXY(580, 290, '  XX');
    SetColor(LightGreen);
    OutTextXY(660, 290, IntToStr(restantes2));
    OutTextXY(690, 290, RestantesPoS(restantes2));
    SetColor(White);
    OutTextXY(580, 330, ' XXX');
    SetColor(LightGreen);
    OutTextXY(660, 330, IntToStr(restantes3));
    OutTextXY(690, 330, RestantesPoS(restantes3));
    SetColor(White);
    OutTextXY(580, 370, 'XXXX');
    SetColor(LightGreen);
    OutTextXY(660, 370, IntToStr(restantes4));
    OutTextXY(690, 370, RestantesPoS(restantes4));
    // Muestra menu de seleccion de orientacion
    SetTextStyle(10, HorizDir, 3);
    SetColor(LightGreen);
    OutTextXY(550, 430, 'Orientacion');
    SetTextStyle(10, HorizDir, 2);
    OutTextXY(580, 480, 'Horizontal     Vertical');
    MostrarBarcos; // Muestra los barcos
end;

// Genera y limpia un array de 10x10 (coloca 0s en cada valor de la matriz)
function GenerarTablero(): tabla;
var
    i, j: integer;
begin
    for i := 1 to 10 do
    begin
        for j := 1 to 10 do
            GenerarTablero[i, j] := 0;
    end;
end;

// Recibe un valor y verifica si es mayor a 0, devuelve true o false (boolean)
function EsPositivo(n: integer): boolean;
begin
    if n > 0 then
        EsPositivo := true
    else
        EsPositivo := false;
end;

// Seleccion de tamaño de barco
procedure SPieza;
var
    keyPressed: char;
    selecValida: boolean;
begin
    // Inicializa la seleccion en la primera pieza
    pieza := 1;
    ClearDevice;
    MostrarTablero;
    Rectangle(564, 238, 870, 278);
    // Lee una tecla hasta que se valide el fin de datos
    keyPressed := readkey;
    selecValida := false;
    while NOT(selecValida) do
    begin
        if keyPressed = #72 then // Si se presiona la flecha arriba, se sube en el menu
            pieza := PressedUp(pieza)
        else if keyPressed = #80 then
            pieza := PressedDown(pieza) // Si se presiona la flecha abajo, se baja en el menu
        else if keyPressed = #13 then  // Si se presiona Enter, se verifica que la pieza este disponible y se selecciona y se sale del bucle, verificando el fin de datos
        begin
            case pieza of                                  // Se verifica si el tamaño deseado está
                1: selecValida := EsPositivo(restantes1);  // disponible (si la variable que contiene
                2: selecValida := EsPositivo(restantes2);  // la cantidad de piezas restantes en dicho
                3: selecValida := EsPositivo(restantes3);  // tamaño es mayor a 0). Si es mayor a 0 (cosa
                4: selecValida := EsPositivo(restantes4);  // que se verifica con la funcion EsPositivo),
            end;
            if NOT(selecValida) then // Si el fin de datos aún es false, quiere decir que el tamaño de barco deseado está agotado, y se pide elegir otro con un mensaje, y se repite el bucle.
                begin
                    SetColor(Red);
                    OutTextXY(880, 310, '! Pieza agotada, elegir otra.');
                    SetColor(LightGreen);
                    Delay(700);
                end
        end;
        ClearDevice;
        MostrarTablero;
        case pieza of
            1: Rectangle(564, 238, 870, 278);
            2: Rectangle(564, 278, 870, 318);
            3: Rectangle(564, 318, 870, 358);
            4: Rectangle(564, 358, 870, 398);
        end;
        if NOT(selecValida) then
            keyPressed := readkey;
    end;
    case pieza of
        1: restantes1 := restantes1 - 1;
        2: restantes2 := restantes2 - 1;
        3: restantes3 := restantes3 - 1;
        4: restantes4 := restantes4 - 1;
    end;
end;

// Seleccionar orientacion del barco
procedure SOrientacion;
var
    keyPressed: char;
begin
    ClearDevice;
    MostrarTablero;
    Rectangle(564, 464, 780, 504);
    orientacion := true; // Orientacion true = horizontal, false = vertical
    keyPressed := readkey;
    while keyPressed <> #13 do
    begin
        if (keyPressed = #75) OR (keyPressed = #77) then
            orientacion := NOT(orientacion);
        if orientacion then
            Rectangle(564, 464, 780, 510)
        else
            Rectangle(790, 464, 1006, 510);
        keyPressed := readkey;
        ClearDevice;
        MostrarTablero;
    end;
    ClearDevice;
    MostrarTablero;
end;

// Incrementa un valor que rota entre 1 y un entero tam
function IncLoop(n, tam: integer): integer;
begin
    if n < tam then // Si el numero es menor a tam, se incrementa en 1
        IncLoop := n + 1
    else          // Si el numero es tam, vuelve a ser 1
        IncLoop := 1;
end;

// Resta 1 de un valor que rota entre 1 y un entero tam
function DecLoop(n, tam: integer): integer;
begin
    if n > 1 then // Si el numero es mayor a 1, se resta 1
        DecLoop := n - 1
    else          // Si el numero es 1, vuelve a ser tam
        DecLoop := tam;
end;

// Si se presiona Enter
procedure PressedEnter(selX, selY: integer);
var
i: integer;
posValida: boolean;
begin
    posValida := false;
    // Si es un barco de una pieza, no importa la orientacion, y se coloca si el lugar elegido esta disponible
    if pieza = 1 then
    begin
        if tablero[selY, selX] <> 2 then // Verifica que no haya barcos colocados en el lugar elegido
        begin
            tablero[selY, selX] := 2; // Coloca el barco
            selecValida := true; // Valida el fin de datos para salir del bucle
        end
        else
        begin // Mensaje de error si la zona esta ocupada
            SetColor(Red);
            OutTextXY(880, 310, '! Zona ocupada');
            SetColor(LightGreen);
            Delay(700);
        end;
    end
    else // Si el barco es un barco de mas de una pieza...
    begin
        posValida := true;
        if orientacion then // Si la orientacion es horizontal...
        begin
            for i := selX to (selX + pieza - 1) do // Verifica que no haya piezas colocadas en el lugar donde se va a colocar la nueva
            begin
                if NOT(tablero[selY, i] <> 2) then // Si existe una pieza colocada en el lugar, se pone la variable que guarda si la posicion es valida o no en false
                    posValida := false;
            end;
            if NOT(posValida) then // Si al terminar de revisar la validez de la posicion esta es invalida, se muestra un mensaje de error
            begin
                // Muestra el mensaje de error
                SetColor(Red);
                OutTextXY(880, 310, '! Zona ocupada');
                SetColor(LightGreen);
                Delay(700);
                selecValida := false;
            end
            else // Si todo esta bien, se coloca la pieza y se valida el fin de datos para salir del bucle de colocamiento de pieza
            begin
                for i := selX to (selX + pieza - 1) do
                    tablero[selY, i] := 2;
                selecValida := true;
            end;
        end
        else // Si la orientacion en vertical...
        begin
            for i := selY to (selY + pieza - 1) do // Verifica que no haya piezas colocadas en el lugar
            begin
                if NOT(tablero[i, selX] <> 2) then // Si existe una pieza colocada en el lugar, se pone la variable que guarda si la posicion es valida o no en false
                    posValida := false;
            end;
            if NOT(posValida) then // Si al terminar de revisar la validez de la posicion esta es invalida, se muestra un mensaje de error
            begin
                // Muestra el mensaje de error
                SetColor(Red);
                OutTextXY(880, 310, '! Zona ocupada');
                SetColor(LightGreen);
                Delay(700);
                selecValida := false;
            end
            else // Si todo esta bien, se coloca la pieza y se valida el fin de datos para salir del bucle de colocamiento de pieza
            begin
                for i := selY to (selY + pieza - 1) do
                    tablero[i, selX] := 2;
                selecValida := true;
            end;
        end;
    end;
end;

// Se encarga de las operaciones a realizar con un array del 1 al 10 al presionar las flechas para moverlo
function Pressed10(key: char; selX, selY: integer): integer;
begin
    if key = 'D' then
        // Pressed10 := Inc10(selY);
        case pieza of
            1: Pressed10 := IncLoop(selY, 10);
            2: Pressed10 := IncLoop(selY, 9);
            3: Pressed10 := IncLoop(selY, 8);
            4: Pressed10 := IncLoop(selY, 7);
        end;
    if key = 'U' then
        // Pressed10 := Dec10(selY);
        case pieza of
            1: Pressed10 := DecLoop(selY, 10);
            2: Pressed10 := DecLoop(selY, 9);
            3: Pressed10 := DecLoop(selY, 8);
            4: Pressed10 := DecLoop(selY, 7);
        end;
    if key = 'L' then
        // Pressed10 := Dec10(selX);
        case pieza of
            1: Pressed10 := DecLoop(selX, 10);
            2: Pressed10 := DecLoop(selX, 9);
            3: Pressed10 := DecLoop(selX, 8);
            4: Pressed10 := DecLoop(selX, 7);
        end;
    if key = 'R' then
        // Pressed10 := Inc10(selX);
        case pieza of
            1: Pressed10 := IncLoop(selX, 10);
            2: Pressed10 := IncLoop(selX, 9);
            3: Pressed10 := IncLoop(selX, 8);
            4: Pressed10 := IncLoop(selX, 7);
        end;
end;

// Seleccionar coordenadas donde colocar el barco
procedure SCoordenadas;
var
coordX, coordY, i, j: integer;
pressedKey: char;
begin
    coordX := 1;             // En el tablero, "1" representa el lugar temporario donde se esta por poner la pieza,
    coordY := 1;             // "0" es un lugar vacio, y "2" es una pieaza colocada definitivamente
    // Dibuja la pieza inicial temporal en el tablero
    OutTextXY(115, 240, 'X');
    pressedKey := readkey;
    ClearDevice;
    MostrarTablero;
    selecValida := false;
    while NOT(selecValida) do // Se repite el bucle hasta que se valide el fin de datos
    begin
        case pressedKey of // Navegacion. Se navega con las flechas y se selecciona con Enter.
            #13: PressedEnter(coordX, coordY);
            #80: coordY := Pressed10('D', coordX, coordY);
            #72: coordY := Pressed10('U', coordX, coordY);
            #75: coordX := Pressed10('L', coordX, coordY);
            #77: coordX := Pressed10('R', coordX, coordY);
        end;
        // Se limpian los barcos temporales del tablero y se dejan los permanentes
        for i := 1 to 10 do
        begin
            for j := 1 to 10 do
            begin
                if (tablero[i, j] = 1) then
                    tablero[i, j] := 0;
            end;
        end;
        // Se muestra el lugar actual de la pieza temporal
        if tablero[coordY, coordX] <> 2 then
            tablero[coordY, coordX] := 1;
        ClearDevice;
        MostrarTablero;
        if NOT(selecValida) then // Se lee una tecla nuevamente si no se valido el fin de datos
            pressedKey := readkey;
    end;
end;

// Procedimiento para colocamiento de barcos en el tablero
procedure Colocar;
var
    i: integer;
begin
    for i := 1 to 10 do // Repetir 10 veces (son 10 varcos a colocar)
    begin
        SPieza;
        if pieza > 1 then
            SOrientacion;
        SCoordenadas;
    end;
end;

// Oponete intenta hundir barco. Devuelve cantidad de intentos que le toma
function Hundir(): integer;
var
x, y, barcosHundidos: integer;
selecValida: boolean;
begin
    barcosHundidos := 0;
    Hundir := 0;
    writeln('----------------------------------Turno del jugador ', jugTurn, '---------------------------------');
    writeln;
    writeln('Intenta hundir todos los barcos del jugador 1 en la menor cantidad de intentos posible');
    repeat // Repetir hasta que se hundan todos los barcos
        repeat // Repetir hasta que se elijan coordenadas validas
            selecValida := false;
            // Se pide coordenada X (nro del 1 al 10)
            repeat
                write('X: ');
                readln(x);
                if (x < 1) OR (x > 10) then
                    writeln('Escribir un numero del 1 al 10: ');
            until (x >= 1) AND (x <= 10);
            // Se pide la coordenada Y (nro del 1 al 10)
            repeat
                write('Y: ');
                readln(y);
                if (x < 1) OR (x > 10) then
                    writeln('Escribir un numero del 1 al 10: ');
            until (y >= 1) AND (y <= 10);
            if (tableroOponente[y, x] = 1) OR (tableroOponente[y, x] = 2) then
                writeln('Ya se disparo en esas coordenadas.')
            else
                selecValida := true;
        until selecValida;
        if tablero[y, x] = 2 then // Si hay un barco en (X, Y)...
        begin
            tableroOponente[y, x] := 1;           // Se indica en el tablero
            windows.Beep(523,100);
            windows.Beep(523,100);
            barcosHundidos := barcosHundidos + 1; // y se suma al contador de barcos hundidos
            writeln('Hundido!');
        end
        else
        begin
            tableroOponente[y, x] := 2; // Si no, se indica en el tablero como "agua"
            windows.Beep(146,100);
            writeln('Agua...');
        end;
        Hundir := Hundir + 1;
        writeln;
        writeln;
    until barcosHundidos = 20 // Si se hunden los 10 barcos, se termina el bucle
end;

// Turno del jugador. Un jugador coloca los barcos en el tablero y el oponente intenta hundirlos. La funcion devuelve cantidad de intentos del oponente en hundir el barco (integer)
function Turno(n: integer): integer;
begin
    Colocar;
    tableroOponente := GenerarTablero;
    jugTurn := 2;
    CloseGraph;
    Turno := Hundir;
end;

// Calcula y muestra el ganador de la partida
procedure Ganador(j1, j2: integer);
begin
    if j1 < j2 then
    begin
        writeln(' El jugador 1 es el ganador, felicidades!');
        windows.Beep(440,100);
        windows.Beep(523,100);
        windows.Beep(659,100);
    end
    else
    begin
        if j2 < j1 then
        begin
            writeln(' El jugador 2 es el ganador, felicidades!');
            windows.Beep(440,100);
            windows.Beep(523,100);
            windows.Beep(659,100);
        end
        else
        begin
            writeln(' Hubo un empate!');
            windows.Beep(440,100);
            windows.Beep(523,100);
            windows.Beep(659,100);
        end;
    end;
    // Muestra una tabla con los resultados
    writeln(' +--------------+--------------+');
    writeln(' |  Jugador 1   |  Jugador 2   |');
    writeln(' |--------------+--------------+');
    if j1 < 100 then
        write(' | ', j1, ' intentos  | ')
    else
        write(' | ', j1, ' intentos | ');
    if j2 < 100 then
        writeln(j2, ' intentos  |')
    else
        writeln(j2, ' intentos |');
    writeln(' +--------------+--------------+');
    readln;
end;

// Batalla Naval (procedimiento principal)
procedure Juegos;
var
    intentos1, intentos2: integer;
begin
    // Limpia la pantalla y muestra el titulo y las instrucciones
    ClearDevice;
    SetTextStyle(114, HorizDir, 115);
    OutTextXY(480, 100, 'BATALLA NAVAL');
    SetTextStyle(1, HorizDir, 2);
    OutTextXY(100, 200, 'En este juego, cada jugador debera colocar barcos en un tablero de 10x10');
    OutTextXY(100, 230, 'que el otro jugador debera intentar hundir.  El jugador que logre hundir');
    OutTextXY(300, 260, 'todos los barcos del otro en menos intentos gana.');
    OutTextXY(350, 320, '- Presiona cualquier tecla para comenzar -');
    readkey;
    // Limpia la pantalla y comienza el turno del jugador 1
    jugTurn := 1;
    // Establece cantidad maxima inicial de cada tipo de pieza restantes
    restantes1 := 4;
    restantes2 := 3;
    restantes3 := 2;
    restantes4 := 1;
    tablero := GenerarTablero;  // Genera el tablero en un array bidimensional
    MostrarTablero; // Muestra el tablero
    intentos1 := Turno(1); // Jugador 1 coloca las piezas, jugador 2 intenta hundirlas
    InitGraph(Driver, Modo, '');
    // Limpia la pantalla y comienza el turno del jugador 2
    jugTurn := 2;
    // Establece cantidad maxima inicial de cada tipo de pieza restantes
    restantes1 := 4;
    restantes2 := 3;
    restantes3 := 2;
    restantes4 := 1;
    tablero := GenerarTablero;  // Genera el tablero en un array bidimensional
    MostrarTablero; // Muestra el tablero
    intentos2 := Turno(2); // Jugador 1 coloca las piezas, jugador 2 intenta hundirlas
    Ganador(intentos1, intentos2);
end;


{ *****2. PROTECTOR DE PANTALLA***** }
procedure Punto;
begin
  Randomize;
  InitPointX := Random(800);
  InitPointY := Random(600);
end;

procedure FormaPatron;
begin
  Randomize;
  patron := Random(4);
    case patron of
    1: SetFillStyle(EmptyFill, color);
    2: SetFillStyle(SolidFill, color);
    3: SetFillStyle(LineFill, color);
    end;
end;

procedure Protector;
begin
  SetTextStyle(10, HorizDir, 2);
  ClearDevice;
  OutTextXY(80, 140, 'Presione Espacio repetidamente cuando desee salir del programa.');
  Delay(800);
  repeat
    Punto;
    for i := 1 to 150 do
    begin
      FillEllipse(InitPointX, InitPointY, i, i);
    end;
      ClearDevice;
    Randomize;
    color := Random(100);
    SetColor(color);
    FormaPatron;
  until KeyPressed;
  SetColor(LightGreen);
end;


{ *****3. CODIGO DE BARRAS***** }
// Convierte char a integer
function CharToInt(num: char): integer;
begin
    CharToInt := Ord(num) - 48;
end;

// Lee y verifica importe
procedure LeerImporte;
var
    selecValida: boolean;
    i: integer;
begin
    write(#13+#10+'Importe: $');
    // Lee el importe (nro de 4 cifras o char '*')
    selecValida := false;
    while NOT(selecValida) do
    begin
        readln(importe);
        if importe <> '*' then // Si la entrada no es "*", se verifica que cada char del string sea un numero del 0 al 9
        begin
            for i := 1 to Length(importe) do
            begin
                if (Ord(importe[i]) >= 48) AND (Ord(importe[i]) <= 57) then // Verifica que cada char del string importe sea un numero
                begin
                    if (StrToInt(importe) >= 1) AND (StrToInt(importe) <= 9999) then // Si importe es un numero del 1 al 9999, se sale del bucle
                        selecValida := true;
                end;
            end;
            if NOT(selecValida) then // Si lo ingresado es invalido, se pide de nuevo
                write('Ingrese un numero del 1 al 9999: ');
        end
        else
            selecValida := true; // Si el caracter ingresado es "*", se sale del bucle
    end;
end;

procedure Binario;//Convierte los nros. del array a binario y luego a código de barras
var
i, j: integer;
b, n: Smallint;
begin
     for i := 1 to 8 do
     begin
          case codigoNum[i] of
          0: BinNum[i] := '0000';
          1: BinNum[i] := '0001';
          2: BinNum[i] := '0010';
          3: BinNum[i] := '0011';
          4: BinNum[i] := '0100';
          5: BinNum[i] := '0101';
          6: BinNum[i] := '0110';
          7: BinNum[i] := '0111';
          8: BinNum[i] := '1000';
          9: BinNum[i] := '1001';
          end;
     end;
     b := detect;
     n := 0;
     InitGraph(b, n,'');
     SetFillStyle(SolidFill, White);
     SetColor(White);
     Bar(GetMaxX-1320, GetMaxY-660, GetMaxX-50, GetMaxY-50);
     SetColor(Black);
     SetTextStyle(DefaultFont, HorizDir, 5);
     OutTextXY(GetMaxX-1270, GetMaxY-640, 'Codigo de la empresa:'+IntToStr(codigo));
     OutTextXY(GetMaxX-1270, GetMaxY-540, 'Importe: $'+importe);
     OutTextXY(GetMaxX-1270, GetMaxY-440, 'Digito verificador:'+IntToStr(DigVer));
     OutTextXY(GetMaxX-1270, GetMaxY-340, 'Codigo de barras:');
     MoveTo(GetMaxX-550, GetMaxY-340);
     SetLineStyle(Solidln, 0,ThickWidth);
     for i := 1 to 8 do
     begin
          for j := 1 to 4 do
          begin
               if BinNum[i,j] = '1' then
               begin
                  SetColor(Black);
                  Line(GetX, GetMaxY-340, GetX, GetY+80);
                  Line(GetX+3, GetMaxY-340, GetX+3, GetY+80);
                  MoveTo(GetX+6, GetMaxY-340);
               end
               else
               begin
                  SetColor(White);
                  Line(GetX, GetMaxY-340, GetX, GetY+80);
                  Line(GetX+3, GetMaxY-340, GetX+3, GetY+80);
                  MoveTo(GetX+6, GetMaxY-340);
               end;
          end;
     end;
     readkey;
     CloseGraph;
end;
// Lee importes y muestra sus codigos de barras hasta que se proporcione el fin de datos
procedure MostrarCod;
var
    i, j, ultLugar: integer;
begin
    LeerImporte; // lee el primer importe
    while importe <> '*' do // Se repite el bucle, pidiendo importes hasta que se escribe "*"
    begin
        ultLugar := 3;
        if Length(importe) < 4 then // Si el numero es de menos de 4 cifras, se agregan 0s al inicio para volverlo de 4 cifras (ej, 48 => 0048; 156 => 0156)
        begin
            for i := 1 to (4 - Length(importe)) do
            begin
                codigoNum[i + 3] := 0;
                ultLugar := i + 3;
            end;
        end;
        j := 1;
        for i := (ultLugar + 1) to (ultLugar + Length(importe)) do // Añade los valores del importe al array codigoNum
        begin
            codigoNum[i] := CharToInt(importe[j]);
            j := j + 1;
        end;
        DigVer := abs((codigoNum[2]+codigoNum[4]+codigoNum[6])-(codigoNum[1]+codigoNum[3]+codigoNum[5]+codigoNum[7])) mod 10; // Se añade el digito verificador al final de los 7 digitos generados
        codigoNum[8] := DigVer;
        Binario;
        LeerImporte;
        CloseGraph;
    end;
    InitGraph(Driver, Modo, '');
end;
// Codigo de Barras (Procedimiento principal)
procedure CodBarras;
var
    i: integer;
    codigoString: string;
begin
    CloseGraph;
    writeln;
    writeln(' - CODIGO DE BARRAS -');
    writeln;
    write('Codigo de la empresa: ');
    // Lee codigo de la empresa (verifica que sea un nro de 3 cifras)
    repeat
        readln(codigo);
        if (codigo < 100) OR (codigo > 999) then
            write('Ingrese un numero de tres cifras: ');
    until (codigo >= 100) AND (codigo <= 999);  //
    codigoString := IntToStr(codigo); // Convierte codigo de la empresa (int) en string
    for i := 1 to 3 do // Convierte codigo de la empresa (string) en array
        codigoNum[i] := CharToInt(codigoString[i]);
    MostrarCod;
end;


{****MENU PRINCIPAL****}
// Muestra la instancia del menu acorde
procedure MostrarMenu(selActual: integer);
begin
    SetTextStyle(3, HorizDir, 4);
    SetColor(LightGreen);
    ClearDevice;
    OutTextXY(250, 100, 'Juegos');
    OutTextXY(250, 200, 'Calculos');
    OutTextXY(250, 300, 'Codigo de Barras');
    OutTextXY(250, 400, 'Salir');
    case selActual of
        1: Rectangle(234, 84, 950, 150);
        2: Rectangle(234, 184, 950, 250);
        3: Rectangle(234, 284, 950, 350);
        4: Rectangle(234, 384, 950, 450);
    end;

end;

// Ejecuta la opcion seleccionada cuando se presiona Enter*********
procedure PressedEnter(selected: integer);
begin
    case selected of
        1: Juegos;
        2: Protector;
        3: CodBarras;
        4: salir := true;
    end;
end;

// Muestra el menu principal y permite interaccion
procedure MenuPrincipal;
var
selActual: integer;
seleccion: char;
begin
    ClearDevice;
    SetTextStyle(3, HorizDir, 4);
    salir := false;
    selActual := 1;
    // Dibuja la instancia inicial del menu
    OutTextXY(250, 100, 'Juegos');
    OutTextXY(250, 200, 'Calculos');
    OutTextXY(250, 300, 'Codigo de Barras');
    OutTextXY(250, 400, 'Salir');
    Rectangle(234, 84, 950, 150);
    while NOT(salir) do // Se repite hasta que se elija la opcion de salir
    begin
        MostrarMenu(selActual);
        if NOT(salir) then
            seleccion := readkey;
        case seleccion of
            #13: PressedEnter(selActual); // Si se presiona Enter, se elige la opcion seleccionada actualmente
            #80: selActual := PressedDown(selActual); // Si se presiona el boton abajo, se baja la seleccion en el menu
            #72: selActual := PressedUp(selActual);
        end;
    end;
end;

// Programa Principal
begin
    Driver := detect;
    Modo := 0;
    InitGraph(Driver, Modo, '');
    // SplashScreen
    SetColor(LightGreen);
    SetTextStyle(3, HorizDir, 3);
    Delay(500);
    OutTextXY(250, 100, 'Algoritmos y Estructuras de Datos');
    SetTextStyle(1, HorizDir, 10);
    Delay(300);
    OutTextXY(250, 150, 'Trabajo');
    Delay(300);
    OutTextXY(250, 250, 'Practico');
    Delay(300);
    SetTextStyle(3, HorizDir, 30);
    OutTextXY(900, 170, '2');
    Delay(300);
    SetTextStyle(3, HorizDir, 3);
    OutTextXY(250, 355, 'Rosales, Verde, Villasanti');
    Delay(1100);
    windows.Beep(440,300);
    windows.Beep(349,300);
    windows.Beep(392,300);
    windows.Beep(349,300);
    MenuPrincipal;
    readkey;
    CloseGraph;
end.
