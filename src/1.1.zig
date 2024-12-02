const std = @import("std");

pub fn main() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var file = std.fs.cwd().openFile("input.txt", .{}) catch unreachable;

    var buffer: [100000]u8 = undefined;
    const size = file.readAll(&buffer) catch unreachable;
    const input = buffer[0..size];

    var left = std.ArrayList(i32).init(gpa.allocator());
    var right = std.ArrayList(i32).init(gpa.allocator());

    defer left.deinit();
    defer right.deinit();

    var line_iter = std.mem.splitSequence(u8, input, "\n");

    var distance: usize = 0;

    while (line_iter.next()) |line| {
        var num_iter = std.mem.splitSequence(u8, line, "   ");

        const l = num_iter.next() orelse continue;
        const r = num_iter.next() orelse continue;

        left.append(std.fmt.parseInt(i32, l, 10) catch unreachable) catch unreachable;
        right.append(std.fmt.parseInt(i32, r, 10) catch unreachable) catch unreachable;
    }

    const sorting_fn = std.sort.asc(i32);
    std.mem.sort(i32, left.items, {}, sorting_fn);
    std.mem.sort(i32, right.items, {}, sorting_fn);

    for (0..left.items.len) |i| {
        distance += @abs(left.items[i] - right.items[i]);
    }

    std.io.getStdOut().writer().print("{}", .{distance}) catch unreachable;
}
