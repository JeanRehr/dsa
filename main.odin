package main

import "core:fmt"

import "dsa/list"
import "dsa/avltree"
import "input"

display_menu :: proc(menu_name: string, menu_items: []string) {
    fmt.printf("--------------------------------------------------\n")
    fmt.printf("%s\n--------------------------------------------------\n", menu_name)

    for i := 0; i < len(menu_items); i += 1 {
        fmt.printf("[%1d] %s\n", i+1, menu_items[i])
    }

    fmt.printf("--------------------------------------------------\n")
}

// this proc and delete_menu has an error return value to propagate it up to the handle_list_ops procedure
insert_menu :: proc(list_user: ^list.List) -> input.Parse_Error {
    insert_menu_items: []string = {
        "Insert at head.",
        "Insert at tail.",
        "Insert at.",
        "Cancel.",
    }

    display_menu("Insert Menu", insert_menu_items)

    buf: [256]byte
    fmt.print("Option> ")
    opt_input := input.getint(buf[:]) or_return

    switch opt_input {
        case 1:
            fmt.print("Value> ")
            value := input.getint(buf[:]) or_return
            fmt.print(value)
            list.insert_head(list_user, value)
        case 2:
            fmt.print("Value> ")
            value := input.getint(buf[:]) or_return
            list.insert_tail(list_user, value)
        case 3:
            fmt.print("Position> ")
            pos := input.getint(buf[:]) or_return
            fmt.print("Value> ")
            value := input.getint(buf[:]) or_return
            list.insert_at(list_user, value, pos)
        case 4:
            return input.Parse_Error.None
        case:
            fmt.println("Invalid option.")
    }

    return input.Parse_Error.None
}

delete_menu :: proc(list_user: ^list.List) -> input.Parse_Error {
    delete_menu_items: []string = {
        "Delete value.",
        "Delete at head.",
        "Delete at tail.",
        "Delete at.",
        "Cancel.",
    }

    display_menu("Delete Menu", delete_menu_items)

    buf: [256]byte
    fmt.print("Option> ")
    opt_input := input.getint(buf[:]) or_return

    switch opt_input {
        case 1:
            fmt.print("Value> ")
            value := input.getint(buf[:]) or_return
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
            return input.Parse_Error.None
        case:
            fmt.println("Invalid option.")
    }

    return input.Parse_Error.None
}

handle_list_ops :: proc(list_user: ^list.List) {
    main_menu_items_list: []string = {
        "Print list.",
        "Insert.",
        "Delete.",
        "Exit.",
    }

    for {
        display_menu("Main Menu", main_menu_items_list)

        buf: [256]byte
        fmt.print("Option> ")
        opt_input := input.getint(buf[:]) or_continue

        switch opt_input {
        case 1:
            list.print_list(list_user)
        case 2:
            insert_menu(list_user)
        case 3:
            delete_menu(list_user)
        case 4:
            return
        case:
            fmt.println("Invalid option.")
        }
    }
}

handle_tree_ops :: proc(tree_user: ^avltree.Avltree) {
    main_menu_items_tree: []string = {
        "Print tree.",
        "Insert.",
        "Delete.",
        "Delete subtree.",
        "Delete entire tree.",
        "Exit.",
    }
    for {
        display_menu("Main Menu", main_menu_items_tree)

        buf: [256]byte
        fmt.print("Option> ")
        opt_input := input.getint(buf[:]) or_continue

        switch opt_input {
        case 1:
            avltree.print_tree(tree_user)
        case 2:
            fmt.print("Value> ")
            value := input.getint(buf[:]) or_continue
            avltree.insert(tree_user, value)
        case 3:
            fmt.print("Value> ")
            value := input.getint(buf[:]) or_continue
            avltree.remove(tree_user, value)
        case 4:
            fmt.print("Value> ")
            value := input.getint(buf[:]) or_continue
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

main :: proc() {
    tree_int: avltree.Avltree
    list_int: list.List

    defer {
        list.free_list(&list_int)
        avltree.free_tree(&tree_int)
    }

    select_dsa_menu_items: []string = {
        "Singly Linked List.",
        "AVLTree",
        "Exit",
    }

    for {
        display_menu("Select DSA Menu", select_dsa_menu_items)
        buf: [256]byte
        fmt.print("Option> ")
        opt_input := input.getint(buf[:]) or_continue
        switch opt_input {
        case 1:
            handle_list_ops(&list_int)
        case 2:
            handle_tree_ops(&tree_int)
        case 3:
            return
        case:
            fmt.println("Invalid option.")
        }
    }
}
