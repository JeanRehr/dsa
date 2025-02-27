package list

import "core:fmt"
import "core:mem"
import "core:os"
import "core:strconv"

Node :: struct($Data: typeid) {
    data: Data,
    next: ^Node(Data),
}

List :: struct($Data: typeid) {
    _size: int,
    head: ^Node(Data),
}

create_node :: proc(data: $Data) -> ^Node(Data) {
    new_node: ^Node(Data) = new(Node(Data))
    new_node.data = data
    new_node.next = nil
    return new_node
}

insert_head :: proc(list: ^List($Data), data: Data) {
    new_node: ^Node(Data) = create_node(data)
    new_node.next = list.head
    list.head = new_node
    list._size += 1
}

insert_tail :: proc(list: ^List($Data), data: Data) {
    new_node: ^Node(Data) = create_node(data)
    if list._size == 0 {
        list.head = new_node
        list._size += 1
        return
    }

    current: ^Node(Data) = list.head
    for current.next != nil {
        current = current.next
    }
    current.next = new_node
    list._size += 1
}

insert_at :: proc(list: ^List($Data) , data: Data, pos: int) {
    new_node: ^Node(Data) = create_node(data)
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

    current: ^Node(Data) = list.head
    for i := 0; i < pos - 1; i += 1 {
        current = current.next
    }

    tmp: ^Node(Data) = current.next
    current.next = new_node
    new_node.next = tmp
    list._size += 1
}

delete_head :: proc(list: ^List($Data) ) {
    if list._size == 0 {
        fmt.println("List is empty.")
        return
    }

    tmp: ^Node(Data) = list.head

    list.head = list.head.next

    free(tmp)
    list._size -= 1
}

delete_tail :: proc(list: ^List($Data) ) {
    if list._size == 0 {
        fmt.println("List is empty.")
        return
    }

    if list._size == 1 {
        delete_head(list)
        list._size = 0
        return
    }

    second_last: ^Node(Data) = list.head
    for i := 0; i < list._size - 2; i += 1{
        second_last = second_last.next
    }

    tmp: ^Node(Data) = second_last.next
    second_last.next = nil

    free(tmp)
    list._size -= 1
}

delete_value :: proc(list: ^List($Data) , data: Data) {
    current: ^Node(Data) = list.head
    
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

    previous: ^Node(Data)
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

delete_at :: proc(list: ^List($Data) , pos: int) {
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

    current: ^Node(Data) = list.head
    for i := 0; i < pos - 1; i += 1 {
        current = current.next
    }

    tmp: ^Node(Data) = current.next

    current.next = tmp.next

    free(tmp)

    list._size -= 1
}

free_list :: proc(list: ^List($Data) ) {
    current: ^Node(Data) = list.head
    next: ^Node(Data)
    for current != nil {
        next = current.next
        free(current)
        current = next
    }
    list._size = 0
    list.head = nil
}

print_list :: proc(list: ^List($Data) ) {
    current: ^Node(Data) = list.head
    for current != nil {
        when Data == string {
            fmt.printf("%v (len: %d) -> ", current.data, len(current.data))    
        } else {
            fmt.printf("%v -> ", current.data)
        }
        current = current.next
    }
    fmt.printfln("nil\nSize: %d", list._size)
}