using DelimitedFiles

s = readlines(ARGS[1])
wout = open(ARGS[2], "w")

for line in s
    if length(line) < 15
        line *= "\n"
        write(wout, line)
        continue
    end
    element = strip(line[13:14])

    while length(line) < 80
        line *= " "
    end
    linea = line[1:77]
    linea *= element[1]
    linea *= "\n"
    write(wout, linea)
end
write(wout, "END")
close(wout)
