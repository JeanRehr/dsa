package input

import "core:fmt"
import "core:strconv"
import "core:os"

Parse_Error_Code :: enum {
    None,
    Not_Number,
    No_Input,
    Err_Reading,
}

Parse_Error :: struct {
    message: string,
    code: Parse_Error_Code,
}

parse_buf :: proc(buf: []byte) -> (string, Parse_Error) {
    num_bytes, err := os.read(os.stdin, buf[:])

    input_str := string(buf[:num_bytes])
    
    if err != nil {
        fmt.println("Error reading input: ", err)
        return input_str, Parse_Error {
            message = "Error reading input.",
            code = .Err_Reading,
        }
    }

    if buf[0] == 13 || buf[0] == 10 { // ascii values for carriage return or newline
        return input_str, Parse_Error {
            message = "Empty input.",
            code = .No_Input,
        }
    }

    if buf[0] < 48 || buf[0] > 57 { // ascii value for 0 and 9, value for negative (-) is 45
        return input_str, Parse_Error {
            message = "Input not a number.",
            code = .Not_Number,
        }
    }

    return input_str, Parse_Error{code = .None}
}

getint :: proc(buf: []byte) -> int {
    str, err := parse_buf(buf[:])

    if err.code != .None {
        fmt.println(err.message)
        return 0
    }
    
    return strconv.atoi(str)
}