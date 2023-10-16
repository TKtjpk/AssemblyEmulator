# ``TOM``

CPU instruction interpereter

> Inspired by Paul Houdson from [HackingWithSwift](https://www.hackingwithswift.com), decided to move further and extend functionality of TOM application. It's purpose is to help understanding and learn in simple way about CPU register's, stack functionality and Assembly language which is direct 'translation' of CPU's instructions. Hope you'll find this app interesting. If you find any errors/mistakes in it, don't hesitate to contact me. I'll do my best to correct as far as applicable. Down below is a list with examples, so far implemented instructions possible to use. So far program is only handling numbers and operations on it. Unfortunately only Unsigned (positive) numbers untli UInt32.max are handled. Code execution is limited to 'only' 50k lines in order to avoid permanent looping in case of unproper instruction usage. Stack view is very simplified and still under consideration about final implementaion of it. Code can be executed as complete at once or step by step by increasing/decreasing number of lines to be executed. Memory size slider is to emulate Operating System Memory stack reservation and to see the effect of Instruction Pointer (EIP) overwriting effect (more to come)

@Metadata {
    @DisplayName("Assembly emulator")
}

## Overview

## MOV - assigns value/register to a register

@Row {
    @Column {
        Value
    }
    @Column {
        Register
    }
}
@Row {
    @Column {
        ```h
        MOV 5, EAX
        ```
    }
    @Column {
        ```h
        MOV EBX, EAX
        ```
    }
}

## ADD - adds value/register to a register

@Row {
    @Column {
        Value
    }
    @Column {
        Register
    }
}
@Row {
    @Column {
        ```h
        ADD 5, EAX
        ```
    }
    @Column {
        ```h
        ADD EBX, EAX
        ```
    }
}

## SUB - substracts value/register from register

@Row {
    @Column {
        Value
    }
    @Column {
        Register
    }
}
@Row {
    @Column {
        ```h
        SUB 5, EAX
        ```
        }
    @Column {
        ```h
        SUB EBX, EAX
        ```
    }
}

## AND - binary AND operation on registers

@Row {
    @Column {
        Register
    }
}
@Row {
    @Column {
        ```h
        AND EBX, EAX
        ```
    }
}

## OR - binary OR operation on registers

@Row {
    @Column {
        Register
    }
}
@Row {
    @Column {
        ```h
        OR EBX, EAX
        ```
    }
}

## CMP - compare value/register with register

@Row {
    @Column {
        Value
    }
    @Column {
        Register
    }
}
@Row {
    @Column {
        ```h
        CMP 5, EAX
        ```
    }
    @Column {
        ```h
        CMP EBX, EAX
        ```
    }
}

## JEQ - jump if equal

@Row {
    @Column {
        To line
    }
}
@Row {
    @Column {
        ```h
        JEQ 1
        ```
    }
}

## JNEQ - jump if not equal

@Row {
    @Column {
        To line
    }
}
@Row {
    @Column {
        ```h
        JNEQ 1
        ```
    }
}

## JMP - unconditional jump

@Row {
    @Column {
        To line
    }
}
@Row {
    @Column {
        ```h
        JMP 1
        ```
    }
}

## INC - increment value of register

@Row {
    @Column {
        Register
    }
}
@Row {
    @Column {
        ```h
        INC EAX
        ```
    }
}

## DEC - decrement value of register

@Row {
    @Column {
        Register
    }
}
@Row {
    @Column {
        ```h
        DEC EAX
        ```
    }
}

## MUL - multiply by value/register value of register

@Row {
    @Column {
        Value
    }
    @Column {
        Register
    }
}
@Row {
    @Column {
        ```h
        MUL 5, EAX
        ```
    }
    @Column {
        ```h
        MUL EBX, EAX
        ```
    }
}

## PUSH - pushing value of register to stack

@Row {
    @Column {
        From Register
    }
}
@Row {
    @Column {
        ```h
        PUSH EAX
        ```
    }
}

## POP - popping value from a stack to register

@Row {
    @Column {
        To Register
    }
}
@Row {
    @Column {
        ```h
        POP EAX
        ```
    }
}


## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
