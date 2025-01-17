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
    tree.root = _remove(tree.root, data)
}

_remove :: proc(node: ^Node, data: int) -> ^Node {
    if node == nil {
        fmt.println("Value not found.")
        return node
    }

    if data < node.data {
        node.left = _remove(node.left, data)
    } else if data > node.data {
        node.right = _remove(node.right, data)
    } else { // node found
        if node.right == nil || node.left == nil { // check if node has only one or no child
            tmp: ^Node = (node.left != nil) ? node.left : node.right
            if tmp == nil { // no child case
                free(node)
                node = nil
            } else { // one child case
                node.data = tmp.data; // node to be "deleted" will be equal to either right or left
                node.left = tmp.left
                node.right = tmp.right
                free(node)
            }
            free(tmp)
        } else { // two children case
            tmp: ^Node = minimum(node.right) // the successor to right of the deleted node
            node.data = tmp.data // assign the data in the temp to the node to be "deleted"
            node.right = _remove(node.right, tmp.data) // remove the successor of the node
        }
    }

    set_height(node)
    return node
}

minimum :: proc(node: ^Node) -> ^Node {
    current: ^Node = node
    for current.left != nil {
        current = current.left
    }
    return current
}