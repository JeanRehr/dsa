package main

import "core:fmt"
import "core:mem"
import "core:strings"

import "dsa/list"
import "dsa/avltree"
import "input"

display_menu :: proc(menu_name: string, menu_items: []string) {
    fmt.printf(
        "--------------------------------------------------\n%s\n--------------------------------------------------\n",
        menu_name
    )
    
    for i := 0; i < len(menu_items); i += 1 {
        fmt.printf("[%1d] %s\n", i+1, menu_items[i])
    }

    fmt.printf("--------------------------------------------------\n")
}

// this proc and delete_menu has an error return value to propagate it up to the handle_list_ops, which has the loop
insert_menu :: proc(list_user: ^list.List($Data), $T: typeid) -> bool {
    insert_menu_items: []string = {
        "Insert at head.",
        "Insert at tail.",
        "Insert at.",
        "Cancel.",
    }

    display_menu("Insert Menu", insert_menu_items)

    buf: [256]byte
    mem.zero(&buf[0], len(buf))
    fmt.print("Option> ")
    opt_input := input.get_option(buf[:], 1, len(insert_menu_items)) or_return

    switch opt_input {
    case 1:
        fmt.print("Value> ")
        str_value := input.parse_buf(buf[:]) or_return
        str_value = strings.trim_space(str_value)
        fmt.println("Value after parsing buffer and trimming: %s", str_value)
        value := input.parse_string(str_value, T) or_return
        fmt.println("Value before inserting: %s", value)
        list.insert_head(list_user, value)
    case 2:
        fmt.print("Value> ")
        str_value := input.parse_buf(buf[:]) or_return
        str_value = strings.trim_space(str_value)
        value := input.parse_string(str_value, T) or_return
        list.insert_tail(list_user, value)
    case 3:
        fmt.print("Position> ")
        pos := input.getint(buf[:]) or_return
        fmt.print("Value> ")
        str_value := input.parse_buf(buf[:]) or_return
        str_value = strings.trim_space(str_value)
        value := input.parse_string(str_value, T) or_return
        list.insert_at(list_user, value, pos)
    case 4:
        return true
    case:
        fmt.println("Invalid option.")
    }

    return true
}

delete_menu :: proc(list_user: ^list.List($Data), $T: typeid) -> bool {
    delete_menu_items: []string = {
        "Delete value.",
        "Delete at head.",
        "Delete at tail.",
        "Delete at.",
        "Cancel.",
    }

    display_menu("Delete Menu", delete_menu_items)

    buf: [256]byte
    mem.zero(&buf[0], len(buf))
    fmt.print("Option> ")
    opt_input := input.get_option(buf[:], 1, len(delete_menu_items)) or_return

    switch opt_input {
    case 1:
        fmt.print("Value> ")
        str_value := input.parse_buf(buf[:]) or_return
        str_value = strings.trim_space(str_value)
        value := input.parse_string(str_value, T) or_return
        list.delete_value(list_user, value)
    case 2:
        list.delete_head(list_user)
    case 3:
        list.delete_tail(list_user)
    case 4:
        fmt.print("Position> ")
        pos := input.getint(buf[:]) or_return
        list.delete_at(list_user, pos)
    case 5:
        return true
    case:
        fmt.println("Invalid option.")
    }
    return true
}

handle_list_ops :: proc(list_user: ^list.List($Data), $T: typeid) {
    main_menu_items_list: []string = {
        "Print list.",
        "Insert.",
        "Delete.",
        "Exit.",
    }
    buf: [256]byte
    for {
        mem.zero(&buf[0], len(buf))
        display_menu("List Main Menu", main_menu_items_list)

        fmt.print("Option> ")
        opt_input := input.getint(buf[:]) or_continue

        switch opt_input {
        case 1:
            list.print_list(list_user)
        case 2:
            insert_menu(list_user, T)
        case 3:
            delete_menu(list_user, T)
        case 4:
            return
        case:
            fmt.println("Invalid option.")
        }
    }
}

handle_tree_ops :: proc(tree_user: ^avltree.Avltree($Data), $T: typeid, buf: []byte) {
    main_menu_items_tree: []string = {
        "Print tree.",
        "Insert.",
        "Delete.",
        "Delete subtree.",
        "Delete entire tree.",
        "Exit.",
    }
    //buf: [256]byte
    for {
        display_menu("Tree Main Menu", main_menu_items_tree)

        fmt.print("Option> ")
        opt_input := input.get_option(buf[:], 1, 6) or_continue

        switch opt_input {
        case 1:
            avltree.print_tree(tree_user)
        case 2:
            bufstring: [256]byte
            mem.zero(&bufstring, len(bufstring)) // Clear the buffer
            fmt.print("Value> ")
            str_value := input.parse_buf(buf[:]) or_continue
            str_value = strings.trim_space(str_value)
            fmt.println("String from user: ", str_value)
            when T == string {
                value := str_value
            } else {
                value := input.parse_string(str_value, T) or_continue
            }
            fmt.println("Value after parse_string():", value)
            avltree.insert(tree_user, value)
        case 3:
            fmt.print("Value> ")
            str_value := input.parse_buf(buf[:]) or_continue
            value := input.parse_string(str_value, T) or_continue
            avltree.remove(tree_user, value)
        case 4:
            fmt.print("Value> ")
            str_value := input.parse_buf(buf[:]) or_continue
            value := input.parse_string(str_value, T) or_continue
            avltree.remove_subtree(tree_user, value)
        case 5:
            avltree.free_tree(tree_user)
        case 6:
            return
        case:
            fmt.println("Invalid option.")
        }
    }
}

select_type :: proc() -> typeid {
    select_type_items: []string = {
        "Integer.",
        "Float",
        "String",
        "Exit",
    }

    buf: [256]byte
    
    for {
        mem.zero(&buf[0], len(buf))
        display_menu("Select Type Menu", select_type_items)

        fmt.print("Option> ")
        opt_input := input.get_option(buf[:], 1, len(select_type_items)) or_continue

        switch opt_input {
        case 1:
            return int
        case 2:
            return f64
        case 3:
            return string
        case 4:
            return nil
        case:
            fmt.println("Not an option.")
        }
    }
}

main :: proc() {
    list_int: list.List(int)
    list_float: list.List(f64)
    list_string: list.List(string)
    tree_int: avltree.Avltree(int)
    tree_float: avltree.Avltree(f64)
    tree_string: avltree.Avltree(string)
    
    defer {
        list.free_list(&list_int)
        list.free_list(&list_float)
        list.free_list(&list_string)
        avltree.free_tree(&tree_int)
        avltree.free_tree(&tree_float)
        avltree.free_tree(&tree_string)
    }

    select_dsa_menu_items: []string = {
        "Singly Linked List.",
        "AVLTree",
        "Exit",
    }

    buf: [256]byte

    for {
        mem.zero(&buf[0], len(buf))
        display_menu("Select DSA Menu", select_dsa_menu_items)
    
        fmt.print("Option> ")
        dsa_type, ok := input.get_option(buf[:], 1, len(select_dsa_menu_items))
        for !ok {
            mem.zero(&buf[0], len(buf))
            dsa_type, ok = input.get_option(buf[:], 1, len(select_dsa_menu_items))
        }

        switch dsa_type {
        case 1:
            T := select_type()
            if T == int do handle_list_ops(&list_int, int)
            else if T == f64 do handle_list_ops(&list_float, f64)
            else if T == string do handle_list_ops(&list_string, string)
        case 2:
            T := select_type()
            if T == int do handle_tree_ops(&tree_int, int, buf[:])
            else if T == f64 do handle_tree_ops(&tree_float, f64, buf[:])
            else if T == string do handle_tree_ops(&tree_string, string, buf[:])
        case 3:
            return
        case:
            fmt.println("Invalid option.")
        }
    }
}