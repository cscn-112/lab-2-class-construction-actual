const std = @import("std");

pub fn build(b: *std.Build) !void {
    var sources = std.ArrayList([]const u8).init(b.allocator);

    // Search for all C/C++ files in `src/lib` and add them
    {
        const base_path: []const u8 = "src/lib";
        const allowed_exts = [_][]const u8{ ".c", ".cpp", ".cxx", ".c++", ".cc" };

        var dir = try std.fs.cwd().openIterableDir(base_path, .{});

        var walker = try dir.walk(b.allocator);
        defer walker.deinit();

        while (try walker.next()) |entry| {
            const ext = std.fs.path.extension(entry.basename);
            const include_file = for (allowed_exts) |e| {
                if (std.mem.eql(u8, ext, e))
                    break true;
            } else false;

            if (include_file) {
                var large_buffer: [100]u8 = undefined;
                const large_buffer_slice = large_buffer[0..];

                // we have to clone the path as walker.next() or walker.deinit() will override/kill it
                const full_path = try std.fmt.bufPrint(large_buffer_slice, "{s}/{s}", .{ base_path, b.dupe(entry.path) });

                try sources.append(full_path);
            }
        }
    }

    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "lab-2-class-construction",
        .root_source_file = .{ .path = "src/main.cpp" },
        .target = target,
        .optimize = optimize,
    });
    exe.addCSourceFiles(sources.items, &[_][]const u8{});
    exe.linkLibCpp();
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
