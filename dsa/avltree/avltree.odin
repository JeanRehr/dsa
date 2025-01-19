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
}

create_node :: proc(data: int) -> ^Node {
    new_node: ^Node = new(Node)
    new_node.data = data
    new_node.height = 1
    return new_node
}

height :: proc(node: ^Node) -> int {
    return node == nil ? 0 : node.height
}

set_height :: proc(node: ^Node) {
    node.height = 1 + max(height(node.left), height(node.right))
}

balance_factor :: proc(node: ^Node) -> int {
    return node == nil ? 0 : height(node.left) - height(node.right)
}

print_tree :: proc(tree: ^Avltree) {
    _print_tree(tree.root, 0)
}

_print_tree :: proc(node: ^Node, level: int) {
    if node != nil {
        for i := 0; i < level; i += 1 {
            fmt.print("    ")
        }

        fmt.printfln("%d H: %d BF: %d", node.data, height(node), balance_factor(node))

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
    return rebalance(node)
}

remove :: proc(tree: ^Avltree, data: int) {
    tree.root = _remove(tree.root, data)
}

_remove :: proc(node: ^Node, data: int) -> ^Node {
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
            tmp: ^Node = (node.left != nil) ? node.left : node.right
            if tmp == nil { // no child case
                tmp = node
                node = nil
            } else { // one child case
                node = tmp // node to be "deleted" will be equal to either right or left
                free(tmp)
            }
        } else { // two children case
            tmp: ^Node = minimum(node.right) // the successor to right of the deleted node
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

minimum :: proc(node: ^Node) -> ^Node {
    node := node
    for node.left != nil {
        node = node^.left
    }
    return node
}

free_tree :: proc(tree: ^Avltree) {
    _free_tree(tree.root)
    tree.root = nil
}

_free_tree :: proc(node: ^Node) {
    if (node != nil) {
        _free_tree(node.left)
        _free_tree(node.right)
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

right_rotation :: proc(node: ^Node) -> ^Node {
    left_of_node: ^Node = node.left
    right_of_left_of_node: ^Node = left_of_node.right

    left_of_node.right = node
    node.left = right_of_left_of_node

    return node
}

left_rotation :: proc(node: ^Node) -> ^Node {
    right_of_node: ^Node = node.right
    left_of_right_of_node: ^Node = right_of_node.left

    right_of_node.left = node
    node.right = left_of_right_of_node
    
    return node
}

rebalance :: proc(node: ^Node) -> ^Node {
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