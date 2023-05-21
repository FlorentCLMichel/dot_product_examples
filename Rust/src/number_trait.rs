use std::ops::{AddAssign, Add, Mul};
use std::convert::From;

pub trait Number : AddAssign + Add<Output=Self> + Mul<Output=Self> + From<u8> 
                   + std::iter::Sum + Copy + Send + Sync {}

impl Number for i16 {}
impl Number for i32 {}
impl Number for i64 {}
impl Number for i128 {}
impl Number for u8 {}
impl Number for u16 {}
impl Number for u32 {}
impl Number for u64 {}
impl Number for u128 {}
