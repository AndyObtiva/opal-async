# Change Log

## 1.4.0

- Drop `Array#cycle` and `Array#each` overrides and re-implement as `Array#async_cycle` and `Array#async_each`
- Asynchronous `Kernel#async_loop` alternative to `Kernel#loop`

## 1.3.0

- Asynchronous `Array#each` method that is web browser event loop friendly
- `Thread#kill` and `Thread#stop` for partial-compatibility with Ruby `Thread`

## 1.2.0

- Asynchronous `Array#cycle` method that is web browser event loop friendly

## 1.1.1

- Added `Thread` class extension to enable using `Async::Task` as `Thread` in Opal

## 1.1.0

- Initial version
