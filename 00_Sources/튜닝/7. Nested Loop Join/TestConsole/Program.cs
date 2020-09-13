using System;
using System.Collections.Generic;

namespace TestConsole
{
    class Player
    {
        public int playerId;
        //..
    }

    class Salary
    {
        public int PlayerId;
        //..
    }

    class Program
    {
        static void Main(string[] args)
        {
            Random rand = new Random();

            List<Player> players = new List<Player>();
            for (int i = 0; i < 1000; i++)
            {
                if (rand.Next(0, 2) == 0)
                    continue;
                
                players.Add(new Player() { playerId = i });
            }

            //List<Salary> salaries = new List<Salary>();
            Dictionary<int, Salary> salaries = new Dictionary<int, Salary>();
            for (int i = 0; i < 1000; i++)
            {
                if (rand.Next(0, 2) == 0)
                    continue;

                salaries.Add(i, new Salary() { PlayerId = i });
            }

            // Q) ID가 players에도 있고 salaries에도 존재하는 정보 추출?

            // Nested(내포하는)
            List<int> result = new List<int>();
            // result를 최대 5개만 찾는다면?


            // O(N^2) -> O(N)
            foreach (Player p in players)
            {
                /* foreach (Salary s in salaries)
                {
                    if (s.PlayerId == p.playerId)
                        result.Add(p.playerId);

                        break;
                } */

                Salary s = null;
                if (salaries.TryGetValue(p.playerId, out s))
                {
                    result.Add(p.playerId);
                    if (result.Count == 5)
                        break;
                }
                    
            }
        }
    }
}
