open System

let mutable Pro="" // переменная для входного текста

type person = // запись для члена семьи
        {name: string
         surname: string}
let mutable Pos=0 // начало слова
let mutable EPo=0 // конец слова
let Len() = // установить границы на слове
            let mutable ch=true
            while  EPo+2<String.length Pro && ch do
                    if Pro.[EPo+1]=' ' then ch<-false   
                    else EPo<-EPo+1 
            if EPo+2=String.length Pro then EPo<-EPo+1
            EPo
let Next() = Pos<-EPo+2;EPo<-Pos; // перейти к следующему слову
let mutable family = Map.empty // мапа для всего древа

let main() =
    let mutable cur_id="" // текущий ключ в мапе
    let mutable cur_name="" 
    let mutable cur_surname="" 
    let mutable father_key="" // ключи для установления отношений родства
    let mutable mother_key="" 
    let mutable flag = 0
    while Pro<>"0 TRLR" do
        Pro<-Console.ReadLine()
        if Pro<>"0 TRLR" then
            while String.length Pro <> EPo-1 do
                Len()
                if Pro.[Pos..Pos+1] = "@I" then // парсинг ключа
                    cur_id<-Pro.[Pos..EPo]
                if Pro.[Pos..EPo]="GIVN" then 
                    Next()
                    Len()
                    cur_name<-Pro.[Pos..EPo]
                if Pro.[Pos..EPo]="SURN" then
                    Next()
                    Len()
                    cur_surname<-Pro.[Pos..EPo]
                if Pro.[Pos..EPo]="SEX" then 
                    Next()
                    Len()
                    if Pro.[Pos..EPo]="M" then
                        printfn "male('%s %s')." cur_name cur_surname
                    else printfn "female('%s %s')." cur_name cur_surname
                    let person = {name=cur_name; surname=cur_surname}
                    family<-family.Add(cur_id, (cur_name+" "+cur_surname))
                if Pro.[Pos..EPo] = "FAM" then
                    mother_key <- ""
                    father_key <- ""
                    flag <- 1
                if Pro.[Pos..EPo]="HUSB" then // парсинг ключей супругов
                    Next()
                    Len()
                    father_key<-Pro.[Pos..EPo]
                if Pro.[Pos..EPo]="WIFE" then
                    Next()
                    Len()
                    mother_key<-Pro.[Pos..EPo]
                if father_key <> "" && mother_key <> "" && flag = 1 then
                    printfn "marriage('%s', '%s')." (family.Item father_key) (family.Item mother_key)
                    flag <- 0
                if Pro.[Pos..EPo]="CHIL" then // парсниг детей
                    Next()
                    Len()
                    if father_key <> "" then
                        printfn "father('%s', '%s')." (family.Item father_key) (family.Item Pro.[Pos..EPo])
                    if mother_key <> "" then 
                        printfn "mother('%s', '%s')." (family.Item mother_key) (family.Item Pro.[Pos..EPo])
                Next()
            Pos <- 0
            EPo <- 0
main()
