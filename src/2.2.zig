const std = @import("std");

pub fn main() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var file = std.fs.cwd().openFile("input.txt", .{}) catch unreachable;

    var buffer: [100000]u8 = undefined;
    const size = file.readAll(&buffer) catch unreachable;
    const input = buffer[0..size];

    var line_iter = std.mem.splitSequence(u8, input, "\n");

    var safe_count: usize = 0;
    var count: usize = 0;

    while (line_iter.next()) |line| {
        var num_iter = std.mem.splitSequence(u8, line, " ");
        // std.debug.print("parsing line \"{s}\"\n", .{line});
        if (isSafe(&num_iter)) {
            safe_count += 1;
            std.debug.print("safe: {d} | {s}\n", .{ count, line });
        } else {
            std.debug.print("unsafe: \"{s}\"\n", .{line});
        }

        count += 1;
    }

    std.io.getStdOut().writer().print("{}", .{safe_count}) catch unreachable;
}

pub fn isSafe(iter: *std.mem.SplitIterator(u8, .sequence)) bool {
    var increasing_removes: usize = 0;
    var decreasing_removes: usize = 0;

    var increasing_prev = std.fmt.parseInt(i32, iter.next() orelse return false, 10) catch return false;
    var increasing_prev_prev = increasing_prev;
    var decreasing_prev = increasing_prev;
    var decreasing_prev_prev = increasing_prev;

    var increasing_found_valid_first = false;
    var decreasing_found_valid_first = false;

    while (iter.next()) |num_string| {
        const num = std.fmt.parseInt(i32, num_string, 10) catch {
            continue;
        };

        if (increasing_prev <= num and (1 <= @abs(increasing_prev - num)) and (@abs(increasing_prev - num) <= 3)) {
            increasing_prev_prev = increasing_prev;
            increasing_prev = num;
            increasing_found_valid_first = true;
        } else {
            // if (!increasing_found_valid_first) {
            increasing_prev = num;
            increasing_prev_prev = num;
            // }
            increasing_removes += 1;
        }

        if (decreasing_prev >= num and (1 <= @abs(decreasing_prev - num)) and (@abs(decreasing_prev - num) <= 3)) {
            decreasing_prev_prev = decreasing_prev;
            decreasing_prev = num;
            decreasing_found_valid_first = true;
        } else {
            // if (!decreasing_found_valid_first) {
            decreasing_prev = num;
            decreasing_prev_prev = num;
            // }
            decreasing_removes += 1;
        }
    }

    std.debug.print("{}", .{increasing_removes});
    std.debug.print(" {} | ", .{decreasing_removes});
    return (increasing_removes <= 1 or decreasing_removes <= 1);
}
