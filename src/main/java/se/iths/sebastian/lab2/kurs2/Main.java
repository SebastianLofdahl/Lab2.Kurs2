package se.iths.sebastian.lab2.kurs2;

import se.iths.sebastian.lab2.kurs2.model.Anstalld;
import se.iths.sebastian.lab2.kurs2.model.Avdelning;
import se.iths.sebastian.lab2.kurs2.model.Kompetens;
import se.iths.sebastian.lab2.kurs2.model.Passerkort;

import java.time.LocalDate;
import java.util.List;

public class Main {

    public static void main(String[] args) {

        Avdelning it = new Avdelning("IT", "Stockholm");
        Avdelning ekonomi = new Avdelning("Ekonomi", "Göteborg");
        Avdelning forsaljning = new Avdelning("Försäljning", "Malmö");
        Avdelning inkop = new Avdelning("Inköp", "Uppsala");

        Kompetens java = new Kompetens("Java", "Objektorienterad programmering i Java");
        Kompetens sql = new Kompetens("SQL", "Databasfrågor och datamodellering");
        Kompetens projektledning = new Kompetens("Projektledning", "Planering och ledning av projekt");
        Kompetens python = new Kompetens("Python", "Skriptning och dataanalys");

        Anstalld anna = new Anstalld("Anna", "Svensson", "anna.svensson@foretaget.se", LocalDate.of(2021, 3, 15), it);
        Anstalld erik = new Anstalld("Erik", "Johansson", "erik.johansson@foretaget.se", LocalDate.of(2019, 8, 1), it);
        Anstalld maria = new Anstalld("Maria", "Lindberg", "maria.lindberg@foretaget.se", LocalDate.of(2022, 1, 10), ekonomi);
        Anstalld johan = new Anstalld("Johan", "Karlsson", "johan.karlsson@foretaget.se", LocalDate.of(2020, 5, 20), ekonomi);
        Anstalld sara = new Anstalld("Sara", "Nilsson", "sara.nilsson@foretaget.se", LocalDate.of(2023, 9, 4), forsaljning);

        anna.setPasserkort(new Passerkort("K-1001", LocalDate.of(2024, 1, 10), LocalDate.of(2027, 1, 10)));
        erik.setPasserkort(new Passerkort("K-1002", LocalDate.of(2024, 1, 10), LocalDate.of(2027, 1, 10)));
        maria.setPasserkort(new Passerkort("K-1003", LocalDate.of(2024, 3, 1), LocalDate.of(2027, 3, 1)));

        anna.laggTillKompetens(java);
        anna.laggTillKompetens(sql);
        anna.laggTillKompetens(projektledning);
        erik.laggTillKompetens(java);
        erik.laggTillKompetens(sql);
        maria.laggTillKompetens(projektledning);
        johan.laggTillKompetens(sql);

        List<Anstalld> anstallda = List.of(anna, erik, maria, johan, sara);
        List<Kompetens> kompetenser = List.of(java, sql, projektledning, python);
        List<Avdelning> avdelningar = List.of(it, ekonomi, forsaljning, inkop);

        IO.println("=== Anställda ===");
        for (Anstalld a : anstallda) {
            IO.println(a);
            IO.println();
        }

        IO.println("=== Vem har vilken kompetens? ===");
        for (Kompetens k : kompetenser) {
            IO.print(k.getNamn() + ": ");
            boolean nagon = false;
            for (Anstalld a : anstallda) {
                if (a.getKompetenser().contains(k)) {
                    IO.print(a.getNamn() + "  ");
                    nagon = true;
                }
            }
            if (!nagon) {
                IO.print("(ingen ännu)");
            }
            IO.println();
        }

        IO.println();
        IO.println("=== Avdelningar ===");
        for (Avdelning av : avdelningar) {
            IO.println(av);
        }
    }
}