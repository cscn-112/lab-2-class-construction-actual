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
                var path_vec = std.ArrayList(u8).init(b.allocator);
                defer path_vec.deinit();

                try path_vec.appendSlice(base_path);
                try path_vec.append('/');
                try path_vec.appendSlice(entry.path);

                const full_path = b.dupe(path_vec.items);

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
    exe.addCSourceFiles(sources.items, &.{});
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
