package avltree

import "core:fmt"

Node :: struct($Data: typeid) {
    data: Data,
    height: int,
    left: ^Node(Data),
    right: ^Node(Data),
}

Avltree :: struct($Data: typeid) {
    root: ^Node(Data),
}

create_node :: proc(data: $Data) -> ^Node(Data) {
    new_node: ^Node(Data) = new(Node(Data))
    new_node.data = data
    new_node.height = 1
    return new_node
}

height :: proc(node: ^Node($Data)) -> int {
    return node == nil ? 0 : node.height
}

set_height :: proc(node: ^Node($Data)) {
    node.height = 1 + max(height(node.left), height(node.right))
}

balance_factor :: proc(node: ^Node($Data)) -> int {
    return node == nil ? 0 : height(node.left) - height(node.right)
}

print_tree :: proc(tree: ^Avltree($Data)) {
    _print_tree(tree.root, 0)
}

_print_tree :: proc(node: ^Node($Data), level: int) {
    if node != nil {
        for i := 0; i < level; i += 1 {
            fmt.print("    ")
        }

        when Data == string {
            fmt.printfln("%v (len: %d)", node.data, len(node.data))
        } else {
            fmt.printfln("%v", node.data)
        }
        
        next_level := level + 1

        if node.left != nil {
            _print_tree(node.left, next_level)
        } else { // node is nil, print a _ in its place
            for i := 0; i < next_level; i += 1 {
                fmt.print("    ")
            }
            fmt.println("_")
        }

        if node.right != nil {
            _print_tree(node.right, next_level)
        } else { // node is nil, print a _ in its place
            for i := 0; i < next_level; i += 1 {
                fmt.print("    ")
            }
            fmt.println("_")
        }
    }
}

insert :: proc(tree: ^Avltree($Data), data: Data) {
    fmt.printfln("inserting %v", data)
    tree.root = _insert(tree.root, data)
}

_insert :: proc(node: ^Node($Data), data: Data) -> ^Node(Data) {
    if node == nil {
        new_node: ^Node(Data) = create_node(data)
        fmt.printfln("Creating new node with data: %v", data)
        return new_node
    }

    if node.data == data {
        fmt.printfln("Duplicates not allowed: %v", node.data)
        return node
    }

    if data < node.data {
        fmt.printfln("Inserting %v to the left of %v", data, node.data)
        node.left = _insert(node.left, data)
    } else {
        fmt.printfln("Inserting %v to the right of %v", data, node.data)
        node.right = _insert(node.right, data)

    }

    set_height(node)
    return rebalance(node)
}

remove :: proc(tree: ^Avltree($Data), data: Data) {
    tree.root = _remove(tree.root, data)
}

_remove :: proc(node: ^Node($Data), data: Data) -> ^Node(Data) {
    node := node
    if node == nil {
        fmt.println("Value not found.")
        return node
    }

    if data < node.data {
        node.left = _remove(node.left, data)
    } else if data > node.data {
        node.right = _remove(node.right, data)
    } else { // node found
        if (node.right == nil) || (node.left == nil) { // check if node has only one or no child
            tmp: ^Node(Data) = (node.left != nil) ? node.left : node.right
            if tmp == nil { // no child case
                tmp = node
                node = nil
            } else { // one child case
                node^ = tmp^
            }
            free(tmp)
        } else { // two children case
            tmp: ^Node(Data) = minimum(node.right) // the successor to right of the deleted node
            node.data = tmp.data // assign the data in the temp to the node to be "deleted"
            node.right = _remove(node.right, tmp.data) // remove the successor of the node
        }
    }

    if node == nil {
        return node
    }

    set_height(node)
    return rebalance(node)
}

remove_subtree :: proc(tree: ^Avltree($Data), data: Data) {
    tree.root = _remove_subtree(tree.root, data)
}

_remove_subtree :: proc(node: ^Node($Data), data: Data) -> ^Node(Data) {
    node := node
    if node == nil {
        fmt.println("Value not found.")
        return node
    }

    if data < node.data {
        node.left = _remove_subtree(node.left, data)
    } else if data > node.data {
        node.right = _remove_subtree(node.right, data)
    } else { // node found
        free_subtree(node)
        node = nil
        return node
    }

    set_height(node)
    return rebalance(node)
}

minimum :: proc(node: ^Node($Data)) -> ^Node(Data) {
    node := node
    for node.left != nil {
        node = node^.left
    }
    return node
}

free_tree :: proc(tree: ^Avltree($Data)) {
    free_subtree(tree.root)
    tree.root = nil
}

free_subtree :: proc(node: ^Node($Data)) {
    if node != nil {
        free_subtree(node.left)
        free_subtree(node.right)
        free(node)
    }
}

/*
           4                        2
          / \                      / \
         2   6                    1   4
        / \           =>         /   / \
       1   3                   -1   3   6
      /
    -1
*/

/*

     3          2
    /          / \
   2       => 1   3
  /
 1
*/

right_rotation :: proc(node: ^Node($Data)) -> ^Node(Data) {
    left_of_node: ^Node(Data) = node.left
    right_of_left_of_node: ^Node(Data) = left_of_node.right

    left_of_node.right = node
    node.left = right_of_left_of_node

    set_height(node)
    set_height(left_of_node)
    return left_of_node
}

left_rotation :: proc(node: ^Node($Data)) -> ^Node(Data) {
    right_of_node: ^Node(Data) = node.right
    left_of_right_of_node: ^Node(Data) = right_of_node.left

    right_of_node.left = node
    node.right = left_of_right_of_node
    
    set_height(node)
    set_height(right_of_node)
    return right_of_node
}

rebalance :: proc(node: ^Node($Data)) -> ^Node(Data) {
    balance: int = balance_factor(node)
    
    if balance > 1 && balance_factor(node.left) >= 0 {
        return right_rotation(node)
    }

    if balance < -1 && balance_factor(node.right) <= 0 {
        return left_rotation(node)
    }

    if balance > 1 && balance_factor(node.left) <= 0 {
        node.left = left_rotation(node.left)
        return right_rotation(node)
    }

    if balance < -1 && balance_factor(node.right) >= 0 {
        node.right = right_rotation(node.right)
        return left_rotation(node)
    }

    return node
}