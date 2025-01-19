package list

import "core:fmt"
import "core:mem"
import "core:os"
import "core:strconv"

Node :: struct {
    data: int,
    next: ^Node,
}

List :: struct {
    _size: int,
    head: ^Node,
}

create_node :: proc(data: int) -> ^Node {
    new_node: ^Node = new(Node)
    new_node.data = data
    new_node.next = nil
    return new_node
}

insert_head :: proc(list: ^List, data: int) {
    new_node: ^Node = create_node(data)
    new_node.next = list.head
    list.head = new_node
    list._size += 1
}

insert_tail :: proc(list: ^List, data: int) {
    new_node: ^Node = create_node(data)
    if list._size == 0 {
        list.head = new_node
        list._size += 1
        return
    }

    current: ^Node = list.head
    for current.next != nil {
        current = current.next
    }
    current.next = new_node
    list._size += 1
}

insert_at :: proc(list: ^List, data: int, pos: int) {
    new_node: ^Node = create_node(data)
    if list._size == 0 {
        list.head = new_node
        list._size += 1
        return
    }

    if pos <= 0 {
        insert_head(list, data)
        return
    }

    if pos >= list._size {
        insert_tail(list, data)
        return
    }

    current: ^Node = list.head
    for i := 0; i < pos - 1; i += 1 {
        current = current.next
    }

    tmp: ^Node = current.next
    current.next = new_node
    new_node.next = tmp
    list._size += 1
}

delete_head :: proc(list: ^List) {
    if list._size == 0 {
        fmt.println("List is empty.")
        return
    }

    tmp: ^Node = list.head

    list.head = list.head.next

    free(tmp)
    list._size -= 1
}

delete_tail :: proc(list: ^List) {
    if list._size == 0 {
        fmt.println("List is empty.")
        return
    }

    if list._size == 1 {
        delete_head(list)
        list._size = 0
        return
    }

    second_last: ^Node = list.head
    for i := 0; i < list._size - 2; i += 1{
        second_last = second_last.next
    }

    tmp: ^Node = second_last.next
    second_last.next = nil

    free(tmp)
    list._size -= 1
}

delete_value :: proc(list: ^List, data: int) {
    current: ^Node = list.head
    
    if current == nil {
        fmt.println("List is empty.")
        return
    }

    if current.data == data {
        list.head = current.next
        free(current)
        list._size -= 1
        return
    }

    previous: ^Node
    for current != nil && current.data != data {
        previous = current
        current = current.next
    }

    if current == nil {
        fmt.println("Value was not found.")
        return
    }

    previous.next = current.next
    free(current)
    list._size -= 1
}

delete_at :: proc(list: ^List, pos: int) {
    if list._size == 0 {
        fmt.println("List is empty.")
        return
    }

    if pos <= 0 {
        delete_head(list)
        return
    }

    if pos >= list._size {
        delete_tail(list)
        return
    }

    current: ^Node = list.head
    for i := 0; i < pos - 1; i += 1 {
        current = current.next
    }

    tmp: ^Node = current.next

    current.next = tmp.next

    free(tmp)

    list._size -= 1
}

free_list :: proc(list: ^List) {
    current: ^Node = list.head
    next: ^Node
    for current != nil {
        next = current.next
        free(current)
        current = next
    }
    list._size = 0
    list.head = nil
}

print_list :: proc(list: ^List) {
    current: ^Node = list.head
    for current != nil {
        fmt.printf("%d -> ", current.data)
        current = current.next
    }
    fmt.printfln("nil\nSize: %d", list._size)
}