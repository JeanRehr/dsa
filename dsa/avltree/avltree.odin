package avltree

import "core:fmt"

Node :: struct {
    data: int,
    height: int,
    left: ^Node,
    right: ^Node,
}

Avltree :: struct {
    root: ^Node,
    size: int,
}

create_node :: proc(data: int) -> ^Node {
    new_node: ^Node = new(Node)
    new_node.data = data
    new_node.height = 1
    return new_node
}

set_height :: proc(node: ^Node) {
    left_height: int
    right_height: int

    // getting the max of either left or right height
    if node.left != nil do left_height = node.left.height

    if node.right != nil do right_height = node.right.height
    
    if right_height > left_height {
        node.height = 1 + right_height 
    } else {
        node.height = 1 + left_height
    }
}


print_tree :: proc(node: ^Node) {
    _print_tree(node, 0)
}

_print_tree :: proc(node: ^Node, level: int) {
    if node != nil {
        for i := 0; i < level; i += 1 {
            fmt.print("    ")
        }

        fmt.println(node.data)

        next_level := level + 1

        if node.left != nil {
            _print_tree(node.left, next_level)
        } else { // Node is nil, print a _ in its place
            for i := 0; i < next_level; i += 1 {
                fmt.print("    ")
            }
            fmt.println("_")
        }

        if node.right != nil {
            _print_tree(node.right, next_level)
        } else { // Node is nil, print a _ in its place
            for i := 0; i < next_level; i += 1 {
                fmt.print("    ")
            }
            fmt.println("_")
        }
    }
}

insert :: proc(tree: ^Avltree, data: int) {
    tree.root = _insert(tree.root, data)
}

_insert :: proc(node: ^Node, data: int) -> ^Node {
    if node == nil {
        new_node: ^Node = create_node(data)
        return new_node
    }

    if node.data == data {
        fmt.printfln("Duplicates not allowed: %d", node.data)
        return node
    }

    if data < node.data {
        node.left = _insert(node.left, data)
    } else {
        node.right = _insert(node.right, data)
    }

    set_height(node)

    return node
}

remove :: proc(tree: ^Avltree, data: int) {
    tree.root = _remove(&tree.root, data)
}

_remove :: proc(node_ptr: ^^Node, data: int) -> ^Node {
    fmt.println("4Value not found.")
    if node_ptr^ == nil {
        fmt.println("Value not found.")
        return node_ptr^
    }

    if data < node_ptr^.data {
        node_ptr^.left = _remove(&node_ptr^.left, data)
    } else if data > node_ptr^.data {
        node_ptr^.right = _remove(&node_ptr^.right, data)
    } else { // node_ptr^ found
        if node_ptr^.right == nil || node_ptr^.left == nil { // check if node_ptr^ has only one or no child
            tmp: ^Node = (node_ptr^.left != nil) ? node_ptr^.left : node_ptr^.right
            if tmp == nil { // no child case
                node_ptr^ = nil
                fmt.println("1Value not found.")
            } else { // one child case
                node_ptr^.data = tmp.data; // node_ptr^ to be "deleted" will be equal to either right or left
                node_ptr^.left = tmp.left
                node_ptr^.right = tmp.right
            }
            fmt.println("2Value not found.")
            free(tmp)
        } else { // two children case
            tmp: ^Node = minimum(node_ptr^.right) // the successor to right of the deleted node_ptr^
            node_ptr^.data = tmp.data // assign the data in the temp to the node_ptr^ to be "deleted"
            node_ptr^.right = _remove(&node_ptr^.right, tmp.data) // remove the successor of the node_ptr^
        }
    }
    fmt.println("3Value not found.")

    set_height(node_ptr^)
    return node_ptr^
}

minimum :: proc(node: ^Node) -> ^Node {
    current: ^Node = node
    fmt.println("Value not found.")
    if current == nil {
        return nil
    }
    fmt.println("Value not found.")

    for current.left != nil {
        current = current.left
    }
    fmt.println("Value not found.")

    return current
}