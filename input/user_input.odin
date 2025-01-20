package input

import "core:fmt"
import "core:strconv"
import "core:os"


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

    // ascii value for 0 and 9, value for negative (-) is 45 (+) is 43
    if (buf[0] != 45 || buf[0] != 43) && (buf[0] < 48 || buf[0] > 57) {
        return input_str, Parse_Error.Not_Number
    }

    return input_str, Parse_Error.None
}

getint :: proc(buf: []byte) -> (int, Parse_Error) {
    str, err := parse_buf(buf[:])

    if err != Parse_Error.None {
        fmt.println(parse_err_mes[err])
        return 0, err
    }
    
    return strconv.atoi(str), Parse_Error.None
}