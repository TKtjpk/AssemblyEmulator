
# `Welcome to my CPU/Assembly app help`

> Inspired by Paul Houdson from [HackingWithSwift](https://www.hackingwithswift.com), decided to move further and extend functionality of TOM application. It's purpose is to help understanding and learn in simple way about CPU register's, stack functionality and Assembly language which is direct 'translation' of CPU's instructions. Hope you'll find this app interesting.

> If you find any errors/mistakes in it, don't hesitate to contact me. I'll do my best to correct as far as applicable.

> Down below is a list with examples, so far implemented instructions possible to use. So far program is only handling numbers and operations on it. Unfortunately only Unsigned (positive) numbers untli UInt32.max are handled.

> Code execution is limited to 'only' 50k lines in order to avoid permanent looping in case of unproper instruction usage

> Stack view is very simplified and still under consideration about final implementaion of it

> Code can be executed as complete at once or step by step by increasing/decreasing number of lines to be executed

> Memory size slider is to emulate Operating System Memory stack reservation and to see the effect of Instruction Pointer (EIP) overwriting effect (more to come)
 
## `MOV` - assigns value/register to a register

| Value | Register |
| --- | --- |
| MOV 5, EAX | MOV EBX, EAX

## `ADD` - adds value/register to a register

| Value | Register |
| --- | --- |
| ADD 5, EAX | ADD EBX, EAX

## `SUB` - substracts value/register from register

| Value | Register |
| --- | --- |
| SUB 5, EAX | SUB EBX, EAX

## `AND` - binary AND operation on registers

| Register |
| --- |
| AND EBX, EAX

## `OR` - binary OR operation on registers

| Register |
| --- |
| OR EBX, EAX

## `CMP` - compare value/register with register

| Value | Register |
| --- | --- |
| CMP 5, EAX | CMP EBX, EAX

## `JEQ` - jump if equal

| To line |
| --- |
| JEQ 1

## `JNEQ` - jump if not equal

| To line |
| --- |
| JNEQ 1

## `JMP` - unconditional jump

| To line |
| --- |
| JMP 1

## `INC` - increment value of register

| Register |
| --- |
| INC EAX

## `DEC` - decrement value of register

| Register |
| --- |
| DEC EAX

## `MUL` - multiply by value/register value of register

| Value | Register |
| --- | --- |
| MUL 5, EAX | MUL EBX, EAX

## `PUSH` - pushing value of register to stack

| From register |
| --- |
| PUSH EAX

## `POP` - popping value from a stack to register

| To register |
| --- |
| POP EAX
