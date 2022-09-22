#bin/bash

touch tmp.pl
cat shakespeare.ged | dotnet fsi fs_parsing.fsx | cat > tmp.pl
touch out.pl
sort -o out.pl tmp.pl
rm tmp.pl
