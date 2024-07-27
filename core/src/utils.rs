use image::DynamicImage;
use inputbot::{
    KeySequence,
    KeybdKey::{self, *},
    MouseButton::*,
};
use rayon::prelude::*;
use spectrust::*;
use std::sync::{Arc, Mutex, MutexGuard};
use std::{thread::sleep, time::Duration};

#[derive(Debug, Copy, Clone)]
pub enum KeybindTypes {
    KeyQ,
    KeyE,
    KeyR,
    KeyF,
    KeyZ,
    KeyX,
    KeyC,
    KeyV,
    Key1,
    Key2,
    Key3,
    Key4,
    Key5,
    Key6,
    Key7,
    Key8,
    Key9,
    Key0,
    KeyDash,
    KeyEquals,
    KeyS1,
    KeyS2,
    KeyS3,
    KeyS4,
    KeyS5,
    KeyS6,
    KeyS7,
    KeyS8,
    KeyS9,
    KeyS0,
    KeySDash,
    KeySEquals,
}

macro_rules! create_image_refs {
    ( $( $name:ident => $file_stem:expr ),+ ) => {
        lazy_static! {
            $(
                pub static ref $name: Arc<DynamicImage> = Arc::new(
                    image::open(format!("images/{}.png", $file_stem))
                        .expect("Unable to locate file.")
                );
            )+
        }
    };
}

create_image_refs! {
    IMG_Q => "Q",
    IMG_E => "E",
    IMG_R => "R",
    IMG_F => "F",
    IMG_Z => "Z",
    IMG_X => "X",
    IMG_C => "C",
    IMG_V => "V",

    IMG_1 => "1",
    IMG_2 => "2",
    IMG_3 => "3",
    IMG_4 => "4",
    IMG_5 => "5",
    IMG_6 => "6",
    IMG_7 => "7",
    IMG_8 => "8",
    IMG_9 => "9",
    IMG_0 => "0",
    IMG_DASH => "dash",
    IMG_EQUALS => "equals",

    IMG_S1 => "S1",
    IMG_S2 => "S2",
    IMG_S3 => "S3",
    IMG_S4 => "S4",
    IMG_S5 => "S5",
    IMG_S6 => "S6",
    IMG_S7 => "S7",
    IMG_S8 => "S8",
    IMG_S9 => "S9",
    IMG_S0 => "S0",
    IMG_SDASH => "SDASH",
    IMG_SEQUALS => "SEQUALS"
}

pub(crate) fn press_key(key: KeybdKey) {
    key.press();
    sleep(Duration::from_millis(20));
    key.release();
}

pub(crate) fn press_shift_key_sequence(key: KeybdKey) {
    LShiftKey.press();
    sleep(Duration::from_millis(20));
    key.press();
    sleep(Duration::from_millis(20));
    LShiftKey.release();
    sleep(Duration::from_millis(20));
    key.release();
}
