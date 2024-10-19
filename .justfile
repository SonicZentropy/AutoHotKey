build:
    cd core && cargo build --profile releaselto
run:
    cd core && cargo run --profile releaselto
default:
    @just --list