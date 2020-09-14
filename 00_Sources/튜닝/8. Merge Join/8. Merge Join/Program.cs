using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;

namespace _8._Merge_Join
{
    class Player : IComparable<Player>
    {
        public int playerId;

        public int CompareTo(Player other)
        {
            if (playerId == other.playerId)
                return 0;

            return playerId > other.playerId ? 1 : -1;
        }
    }

    class Salary : IComparable<Salary>
    {
        public int playerId;

        public int CompareTo(Salary other)
        {
            if (playerId == other.playerId)
                return 0;

            return playerId > other.playerId ? 1 : -1;
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            List<Player> players = new List<Player>();
            players.Add(new Player() { playerId = 0 });
            players.Add(new Player() { playerId = 9 });
            players.Add(new Player() { playerId = 1 });
            players.Add(new Player() { playerId = 3 });
            players.Add(new Player() { playerId = 4 });

            List<Salary> salaries = new List<Salary>();
            salaries.Add(new Salary() { playerId = 0 });
            salaries.Add(new Salary() { playerId = 5 });
            salaries.Add(new Salary() { playerId = 0 });
            salaries.Add(new Salary() { playerId = 2 });
            salaries.Add(new Salary() { playerId = 9 });

            // 1단계 : Sort (정렬 되어있으면 Skip)
            // Sorting 복잡도 O(N * Log(N))
            players.Sort();
            salaries.Sort();

            // One-to-Many (Players는 중복이 없음)
            // 2단계 : Merge
            // Outer [0 1 3 4 9] -> N
            // Inner [0 0 2 5 9] -> M

            int p = 0;
            int s = 0;

            // O(N + M)
            List<int> result = new List<int>();
            while (p < players.Count && s < salaries.Count)
            {
                if (players[p].playerId == salaries[s].playerId)
                {
                    result.Add(players[p].playerId);
                    s++;
                }
                else if (players[p].playerId < salaries[s].playerId)
                {
                    p++;
                }
                else
                {
                    s++;
                }
            }

            // Many-to-Many
            // Outer [0 0 0 0 0] -> N
            // Inner [0 0 0 0 0] -> M
            // O(N * M)
        }
    }
}
