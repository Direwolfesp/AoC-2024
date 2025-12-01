use std::cmp::Ordering;
use std::error::Error;
use std::fs::File;
use std::io::{self, BufRead, BufReader};

fn main() -> Result<(), Box<dyn Error>> {
    let path = std::env::args().nth(1).expect("Usage: day1 <file>");
    let file = File::open(path)?;
    let reader = BufReader::new(file);

    let mut lefts = Vec::new();
    let mut rights = Vec::new();

    for line in reader.lines() {
        let line = line?;
        let mut parts = line.split_whitespace();
        let left: i64 = parts.next().ok_or("missing left number")?.parse()?;
        let right: i64 = parts.next().ok_or("missing right number")?.parse()?;
        lefts.push(left);
        rights.push(right);
    }

    lefts.sort_unstable();
    rights.sort_unstable();

    let total: i64 = lefts
        .iter()
        .zip(rights.iter())
        .map(|(l, r)| (l - r).abs())
        .sum();

    println!("{total}");
    Ok(())
}
