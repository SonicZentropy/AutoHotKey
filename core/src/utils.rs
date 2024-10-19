use crate::image_processing::*;
use derive_more::Display;
use image::{DynamicImage, Rgba};
use inputbot::{
    KeySequence,
    KeybdKey::{self, *},
    MouseButton::*,
};
use rayon::prelude::*;
use std::sync::{Arc, Mutex, MutexGuard};
use std::{thread::sleep, time::Duration};


#[macro_export]
macro_rules! profile {
    ($label:expr, $blockfn:expr) => {{
            let start = std::time::Instant::now();
            $blockfn;
            let duration = start.elapsed();
            //println!("{}: {:?}ms", $label, duration.as_millis());            
        }};
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

    IMG_Q => "Q",
    IMG_E => "E",
    IMG_R => "R",
    IMG_F => "F",
    IMG_Z => "Z",
    IMG_X => "X",
    IMG_C => "C",
    IMG_V => "V",
    IMG_SZ => "SZ",
    IMG_SX => "SX",
    IMG_SC => "SC",
    IMG_SV => "SV",

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
    IMG_SEQUALS => "SEQUALS",

    IMG_C1 => "C1",
    IMG_C2 => "C2",
    IMG_C3 => "C3",
    IMG_C4 => "C4",
    IMG_C5 => "C5",
    IMG_C6 => "C6",
    IMG_C7 => "C7",
    IMG_C8 => "C8",
    IMG_C9 => "C9",
    IMG_C0 => "C0",
    IMG_CDASH => "CDASH",
    IMG_CEQUALS => "CEQUALS"
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

pub(crate) fn press_ctrl_key_sequence(key: KeybdKey) {
    LControlKey.press();
    sleep(Duration::from_millis(20));
    key.press();
    sleep(Duration::from_millis(20));
    LControlKey.release();
    sleep(Duration::from_millis(20));
    key.release();
}

#[derive(Debug, Copy, Clone)]
pub enum KeybindTypes {
    NOKEY,
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
    KeySZ,
    KeySX,
    KeySC,
    KeySV,
    KeyC1,
    KeyC2,
    KeyC3,
    KeyC4,
    KeyC5,
    KeyC6,
    KeyC7,
    KeyC8,
    KeyC9,
    KeyC0,
    KeyCDash,
    KeyCEquals,
}

#[derive(Debug, Copy, Clone, Display)]
#[display(fmt = "r: {:.2}, g: {:.2}, b: {:.2}, a: {:.2}", r, g, b, a)]
pub struct PixelColor {
    pub r: f32,
    pub g: f32,
    pub b: f32,
    pub a: f32,
}

impl PixelColor {
    pub fn new(r: u8, g: u8, b: u8, a: u8) -> Self {
        PixelColor {
            r: r as f32 / 255.0,
            g: g as f32 / 255.0,
            b: b as f32 / 255.0,
            a: a as f32 / 255.0,
        }
    }

    pub fn distance(&self, other: &PixelColor) -> f32 {
        let dr = self.r - other.r;
        let dg = self.g - other.g;
        let db = self.b - other.b;
        let da = self.a - other.a;
        (dr * dr + dg * dg + db * db + da * da).sqrt()
    }
    
    pub fn white() -> PixelColor {
        PixelColor {
            r: 1.0,
            g: 1.0,
            b: 1.0,
            a: 1.0,
        }
    }
    
    // Key1
    pub fn dark_gray() -> PixelColor {
        PixelColor {
            r: 0.3,
            g: 0.3,
            b: 0.3,
            a: 1.0,
        }
    }
    
    // Key2
    pub fn blue() -> PixelColor {
        PixelColor {
            r: 0.0,
            g: 0.0,
            b: 1.0,
            a: 1.0,
        }
    }
    
    // Key3
    pub fn green() -> PixelColor {
        PixelColor {
            r: 0.0,
            g: 1.0,
            b: 0.0,
            a: 1.0,
        }
    }

    pub fn black() -> PixelColor {
        PixelColor {
            r: 0.0,
            g: 0.0,
            b: 0.0,
            a: 1.0,
        }
    }

    pub fn cyan() -> PixelColor {
        PixelColor {
            r: 0.0,
            g: 1.0,
            b: 1.0,
            a: 1.0,
        }
    }

    pub fn yellow() -> PixelColor {
        PixelColor {
            r: 1.0,
            g: 1.0,
            b: 0.0,
            a: 1.0,
        }
    }

    pub fn something() -> PixelColor {
        PixelColor {
            r: 1.0,
            g: 0.7,
            b: 0.3,
            a: 1.0,
        }
    }

    pub fn gray() -> PixelColor {
        PixelColor {
            r: 0.5,
            g: 0.5,
            b: 0.5,
            a: 1.0,
        }
    }

    pub fn pinkish() -> PixelColor {
        PixelColor {
            r: 0.75,
            g: 0.3,
            b: 0.5,
            a: 1.0,
        }
    }

    pub fn mint() -> PixelColor {
        PixelColor {
            r: 0.3,
            g: 0.9,
            b: 0.7,
            a: 1.0,
        }
    }

    pub fn dark_red() -> PixelColor {
        PixelColor {
            r: 0.6,
            g: 0.1,
            b: 0.1,
            a: 1.0,
        }
    }

    pub fn dark_green() -> PixelColor {
        PixelColor {
            r: 0.1,
            g: 0.6,
            b: 0.1,
            a: 1.0,
        }
    }

    pub fn dark_blue() -> PixelColor {
        PixelColor {
            r: 0.1,
            g: 0.1,
            b: 0.6,
            a: 1.0,
        }
    }

    pub fn olive() -> PixelColor {
        PixelColor {
            r: 0.6,
            g: 0.6,
            b: 0.2,
            a: 1.0,
        }
    }

    pub fn purple() -> PixelColor {
        PixelColor {
            r: 0.6,
            g: 0.2,
            b: 0.6,
            a: 1.0,
        }
    }

    pub fn teal() -> PixelColor {
        PixelColor {
            r: 0.2,
            g: 0.6,
            b: 0.6,
            a: 1.0,
        }
    }

    pub fn orange_brownish() -> PixelColor {
        PixelColor {
            r: 0.8,
            g: 0.4,
            b: 0.2,
            a: 1.0,
        }
    }

    pub fn dark_purple() -> PixelColor {
        PixelColor {
            r: 0.4,
            g: 0.2,
            b: 0.8,
            a: 1.0,
        }
    }

    pub fn light_green() -> PixelColor {
        PixelColor {
            r: 0.2,
            g: 0.8,
            b: 0.4,
            a: 1.0,
        }
    }

    pub fn light_yellow() -> PixelColor {
        PixelColor {
            r: 0.8,
            g: 0.8,
            b: 0.4,
            a: 1.0,
        }
    }

    pub fn bright_orange() -> PixelColor {
        PixelColor {
            r: 1.0,
            g: 0.5,
            b: 0.0,
            a: 1.0,
        }
    }

    pub fn light_green2() -> PixelColor {
        PixelColor {
            r: 0.5,
            g: 1.0,
            b: 0.0,
            a: 1.0,
        }
    }

    pub fn light_blue() -> PixelColor {
        PixelColor {
            r: 0.0,
            g: 0.5,
            b: 1.0,
            a: 1.0,
        }
    }

    pub fn reddish_purple() -> PixelColor {
        PixelColor {
            r: 1.0,
            g: 0.0,
            b: 0.5,
            a: 1.0,
        }
    }

    pub fn olive_drab() -> PixelColor {
        PixelColor {
            r: 0.1,
            g: 0.4,
            b: 0.0,
            a: 1.0,
        }
    }

    pub fn burnt_orange() -> PixelColor {
        PixelColor {
            r: 0.4,
            g: 0.1,
            b: 0.0,
            a: 1.0,
        }
    }

    pub fn dark_blue_violet() -> PixelColor {
        PixelColor {
            r: 0.1,
            g: 0.0,
            b: 0.4,
            a: 1.0,
        }
    }

    pub fn very_dark_blue() -> PixelColor {
        PixelColor {
            r: 0.0,
            g: 0.1,
            b: 0.4,
            a: 1.0,
        }
    }
    
    pub fn light_purple() -> PixelColor {
        PixelColor {
            r: 0.5,
            g: 0.0,
            b: 1.0,
            a: 1.0,
        }
    }

    pub fn dark_magenta() -> PixelColor {
        PixelColor {
            r: 0.4,
            g: 0.1,
            b: 0.4,
            a: 1.0,
        }
    }

    pub fn mustard_yellow() -> PixelColor {
        PixelColor {
            r: 0.4,
            g: 0.4,
            b: 0.1,
            a: 1.0,
        }
    }

    pub fn sea_green() -> PixelColor {
        PixelColor {
            r: 0.1,
            g: 0.4,
            b: 0.4,
            a: 1.0,
        }
    }
    
    // AI Generated Below
    pub fn bright_green() -> PixelColor {
        PixelColor {
            r: 0.0,
            g: 1.0,
            b: 0.5,
            a: 1.0,
        }
    }

    pub fn dark_yellow() -> PixelColor {
        PixelColor {
            r: 0.5,
            g: 0.5,
            b: 0.0,
            a: 1.0,
        }
    }

    pub fn bright_purple() -> PixelColor {
        PixelColor {
            r: 0.5,
            g: 0.0,
            b: 0.5,
            a: 1.0,
        }
    }

    pub fn bright_cyan() -> PixelColor {
        PixelColor {
            r: 0.0,
            g: 0.5,
            b: 0.5,
            a: 1.0,
        }
    }

    pub fn dark_mint() -> PixelColor {
        PixelColor {
            r: 0.0,
            g: 0.5,
            b: 0.4,
            a: 1.0,
        }
    }

    pub fn bright_blue() -> PixelColor {
        PixelColor {
            r: 0.0,
            g: 0.5,
            b: 0.75,
            a: 1.0,
        }
    }

    pub fn olive_green() -> PixelColor {
        PixelColor {
            r: 0.5,
            g: 0.75,
            b: 0.0,
            a: 1.0,
        }
    }

    pub fn light_olive() -> PixelColor {
        PixelColor {
            r: 0.75,
            g: 0.75,
            b: 0.25,
            a: 1.0,
        }
    }

    pub fn darker_red() -> PixelColor {
        PixelColor {
            r: 0.5,
            g: 0.0,
            b: 0.0,
            a: 1.0,
        }
    }

    pub fn light_brown() -> PixelColor {
        PixelColor {
            r: 0.5,
            g: 0.25,
            b: 0.0,
            a: 1.0,
        }
    }

    pub fn dark_cyan() -> PixelColor {
        PixelColor {
            r: 0.0,
            g: 0.25,
            b: 0.5,
            a: 1.0,
        }
    }

    pub fn light_pink() -> PixelColor {
        PixelColor {
            r: 1.0,
            g: 0.75,
            b: 0.75,
            a: 1.0,
        }
    }

    pub fn bright_mint() -> PixelColor {
        PixelColor {
            r: 0.0,
            g: 1.0,
            b: 0.75,
            a: 1.0,
        }
    }

    pub fn light_orange() -> PixelColor {
        PixelColor {
            r: 1.0,
            g: 0.5,
            b: 0.25,
            a: 1.0,
        }
    }

    pub fn dark_black() -> PixelColor {
        PixelColor {
            r: 0.25,
            g: 0.25,
            b: 0.25,
            a: 1.0,
        }
    }

    pub fn light_blue_green() -> PixelColor {
        PixelColor {
            r: 0.25,
            g: 1.0,
            b: 0.75,
            a: 1.0,
        }
}
}

impl From<&Rgba<u8>> for PixelColor {
    fn from(rgba: &Rgba<u8>) -> Self {
        PixelColor {
            r: rgba[0] as f32 / 255.0,
            g: rgba[1] as f32 / 255.0,
            b: rgba[2] as f32 / 255.0,
            a: rgba[3] as f32 / 255.0,
        }
    }
}

#[derive(Debug, Copy, Clone, Display)]
pub enum PixelColors {
    White,
    Green,
    DarkGray,
    Blue,
    Black,
    Cyan,
    Yellow,
    Something,
    Gray,
    Pinkish,
    Mint,
    DarkRed,
    DarkGreen,
    DarkBlue,
    Olive,
    Purple,
    LightPurple,
    Teal,
    OrangeBrownish,
    DarkPurple,
    LightGreen,
    LightYellow,
    BrightOrange,
    LightGreen2,
    LightBlue,
    ReddishPurple,
    OliveDrab,
    BurntOrange,
    DarkBlueViolet,
    VeryDarkBlue,
    DarkMagenta,
    MustardYellow,
    SeaGreen,
    // AI Generated Below
    BrightGreen,
    DarkYellow,
    BrightPurple,
    BrightCyan,
    DarkMint,
    BrightBlue,
    OliveGreen,
    LightOlive,
    DarkerRed,
    LightBrown,
    DarkCyan,
    LightPink,
    BrightMint,
    LightOrange,
    DarkBlack,
    LightBlueGreen
}
