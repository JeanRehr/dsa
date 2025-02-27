package input

import "core:fmt"
import "core:strconv"
import "core:os"

/*
Parse_Error :: enum {
    None = 0,
    Not_Number,
    No_Input,
    Err_Reading,
}

parse_err_mes := [Parse_Error]string {
    .None = "ok",
    .Not_Number = "Input not a number.",
    .No_Input = "Empty input.",
    .Err_Reading = "Error reading input.",
}

parse_buf :: proc(buf: []byte) -> (string,  Parse_Error) {
    num_bytes, err := os.read(os.stdin, buf[:])

    input_str := string(buf[:num_bytes])
    
    if err != nil {
        fmt.println("Error reading input: ", err)
        return input_str, Parse_Error.Err_Reading
    }

    // ascii values for carriage return or newline
    if buf[0] == 13 || buf[0] == 10 {
        return input_str, Parse_Error.No_Input
    }

    // ascii values for 0-9 and signs (+, -)
    if !(buf[0] == 45 || buf[0] == 43 || (buf[0] >= 48 && buf[0] <= 57)) {
        return input_str, Parse_Error.Not_Number
    }

    return input_str, Parse_Error.None
}

getfloat :: proc(buf: []byte) -> (f64, Parse_Error) {
    str, err := parse_buf(buf[:])

    if err != Parse_Error.None {
        fmt.println(parse_err_mes[err])
        return 0, err
    }

    return strconv.atof(str), Parse_Error.None
}

getint :: proc(buf: []byte) -> (int, Parse_Error) {
    str, err := parse_buf(buf[:])

    if err != Parse_Error.None {
        fmt.println(parse_err_mes[err])
        return 0, err
    }
    
    return strconv.atoi(str), Parse_Error.None
}
*/

parse_buf :: proc(buf: []byte) -> (string,  bool) {
    num_bytes, err := os.read(os.stdin, buf[:])

    input_str := string(buf[:num_bytes])
    
    if err != nil {
        fmt.eprintln("Error reading input: ", err)
        return input_str, false
    }

    // ascii values for carriage return or newline
    if buf[0] == 13 || buf[0] == 10 {
        fmt.eprintln("Empty input.")
        return input_str, false
    }

    return input_str, true
}

getint :: proc(buf: []byte) -> (int, bool) {
    str, ok := parse_buf(buf[:])

    if !(buf[0] == 45 || buf[0] == 43 || (buf[0] >= 48 && buf[0] <= 57)) {
        fmt.println("Input not a number.")
        return 0, false
    }
    
    return strconv.atoi(str), true
}

get_option :: proc(buf: []byte, low, high: int) -> (int, bool) {
    opt, ok := getint(buf)
    
    for !ok || (opt < low || opt > high) {
        fmt.println("Not an option.")
        fmt.print("Option> ")
        opt, ok = getint(buf)
    }

    return opt, ok
}

parse_string :: proc(s: string, $T: typeid) -> (T, bool) {
    when T == int {
        return strconv.atoi(s), true
    } else when T == f64 {
        return strconv.atof(s), true
    } else when T == string {
        fmt.printfln("Value before returning: %s", s)
        return s, true
    } else {
        panic("Unsupported type at compile time!")
    }
    return {}, false
}

