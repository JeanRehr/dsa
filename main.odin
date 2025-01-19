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

insert_menu :: proc(list_user: ^list.List) {
    insert_menu_items: []string = {
        "Insert at head.",
        "Insert at tail.",
        "Insert at.",
        "Cancel.",
    }

    display_menu("Insert Menu", insert_menu_items)

    buf: [256]byte
    fmt.print("Option> ")
    opt_input, err := input.getint(buf[:])

    switch opt_input {
        case 1:
            fmt.print("Value> ")
            value, err := input.getint(buf[:])
            list.insert_head(list_user, value)
        case 2:
            fmt.print("Value> ")
            value, err := input.getint(buf[:])
            list.insert_tail(list_user, value)
        case 3:
            fmt.print("Position> ")
            pos, err := input.getint(buf[:])
            fmt.print("Value> ")
            value, err2 := input.getint(buf[:])
            list.insert_at(list_user, value, pos)
        case 4:
            return
        case:
            fmt.println("Invalid option.")
    }
}

delete_menu :: proc(list_user: ^list.List) {
    delete_menu_items: []string = {
        "Delete value.",
        "Delete at head.",
        "Delete at tail.",
        "Delete at.",
        "Cancel.",
    }

    display_menu("Deete Menu", delete_menu_items)

    buf: [256]byte
    fmt.print("Option> ")
    opt_input, err := input.getint(buf[:])

    switch opt_input {
        case 1:
            fmt.print("Value> ")
            value, err := input.getint(buf[:])
            fmt.printfln("Deleting value %d", value)
            list.delete_value(list_user, value)
        case 2:
            list.delete_head(list_user)
        case 3:
            list.delete_tail(list_user)
        case 4:
            fmt.print("Position> ")
            pos, err := input.getint(buf[:])
            list.delete_at(list_user, pos)
        case 5:
            return
        case:
            fmt.println("Invalid option.")
    }
}

main :: proc() {
    tree_int: avltree.Avltree
    defer {
        avltree.free_tree(&tree_int)
    }

    avltree.insert(&tree_int, 1)
    avltree.insert(&tree_int, 2)
    avltree.insert(&tree_int, 3)
    avltree.insert(&tree_int, 4)
    avltree.insert(&tree_int, 5)
    avltree.insert(&tree_int, 6)
    avltree.insert(&tree_int, 7)
    avltree.insert(&tree_int, 8)
    avltree.insert(&tree_int, 9)
    avltree.insert(&tree_int, 10)
    avltree.print_tree(&tree_int)
    avltree.remove_subtree(&tree_int, 6)
    avltree.print_tree(&tree_int)
    

    main_menu_items: []string = {
        "Print tree.",
        "Insert.",
        "Delete.",
        "Delete subtree.",
        "Delete entire tree.",
        "Exit.",
    }

    for {
        display_menu("Main Menu", main_menu_items)

        buf: [256]byte
        fmt.print("Option> ")
        opt_input, err := input.getint(buf[:])

        switch opt_input {
        case 1:
            avltree.print_tree(&tree_int)
        case 2:
            fmt.print("Value> ")
            value := input.getint(buf[:]) or_continue
            avltree.insert(&tree_int, value)
        case 3:
            fmt.print("Value> ")
            value := input.getint(buf[:]) or_continue
            avltree.remove(&tree_int, value)
        case 4:
            fmt.print("Value> ")
            value := input.getint(buf[:]) or_continue
            avltree.remove_subtree(&tree_int, value)
        case 5:
            avltree.free_tree(&tree_int)
        case 6:
            return
        case:
            fmt.println("Invalid option.")
        }
    }
    
    /*
    list_int: list.List
    defer {
        list.free_list(&list_int)
    }

    main_menu_items: []string = {
        "Print list.",
        "Insert.",
        "Delete.",
        "Exit.",
    }

    for {
        display_menu("Main Menu", main_menu_items)

        buf: [256]byte
        fmt.print("Option> ")
        opt_input := input.getint(buf[:])

        switch opt_input {
        case 1:
            list.print_list(&list_int)
        case 2:
            insert_menu(&list_int)
        case 3:
            delete_menu(&list_int)
        case 4:
            return
        case:
            fmt.println("Invalid option.")
        }
    }
    */
}
