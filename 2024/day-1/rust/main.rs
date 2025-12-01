use std::{env::args, fs::File, io::{BufRead, BufReader}};

fn split_line(line: String) -> Result<(i32, i32), &'static str> {
    let first_space = line.find(' ').expect("no space chars in line");
    let last_space = line.rfind(' ').expect("no space chars in line");
    let word_l = &line[..first_space];
    let word_r = &line[last_space + 1..];

    Ok((word_l.parse().expect("failed to parse word_l"), word_r.parse().expect("failed to parse word_r")))
}

fn part_a(filepath: String) -> Result<i32, &'static str> {
    let file;

    match File::open(filepath) {
        Ok(f) => file = f,
        Err(_) => return Err("failed to open file")
    }

    let reader = BufReader::new(file);
    let mut list_a: Vec<i32> = Vec::new();
    let mut list_b: Vec<i32> = Vec::new();

    for line in reader.lines() {
        let (num_l, num_r) = split_line(line.unwrap())?;
        list_a.push(num_l);
        list_b.push(num_r);
    }

    list_a.sort();
    list_b.sort();

    let mut total = 0;

    for i in 0..list_a.len() {
        total += (list_b[i] - list_a[i]).abs();
    }

    Ok(total)
}

fn main() {
    let argv = args();

    if argv.len() != 2 {
        panic!("missing filename");
    }

    match part_a(argv.last().unwrap()) {
        Ok(result) => println!("> {}", result),
        Err(e) => panic!("{}", e)
    }
}
