const std = @import("std");

pub fn main() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var file = std.fs.cwd().openFile("input.txt", .{}) catch unreachable;

    var buffer: [100000]u8 = undefined;
    const size = file.readAll(&buffer) catch unreachable;
    const input = buffer[0..size];

    var left = std.ArrayList(i32).init(gpa.allocator());
    var right = std.AutoHashMap(i32, i32).init(gpa.allocator());

    defer left.deinit();
    defer right.deinit();

    var line_iter = std.mem.splitSequence(u8, input, "\n");

    while (line_iter.next()) |line| {
        var num_iter = std.mem.splitSequence(u8, line, "   ");

        const l = num_iter.next() orelse continue;
        const r = num_iter.next() orelse continue;

        left.append(std.fmt.parseInt(i32, l, 10) catch unreachable) catch unreachable;

        const parsed_r = std.fmt.parseInt(i32, r, 10) catch unreachable;
        const prev_null = right.fetchRemove(parsed_r);
        right.put(parsed_r, if (prev_null) |prev| prev.value + 1 else 1) catch unreachable;
    }

    var sum: i128 = 0;
    for (0..left.items.len) |i| sum += left.items[i] * (right.get(left.items[i]) orelse 0);

    std.io.getStdOut().writer().print("{}", .{sum}) catch unreachable;
}
