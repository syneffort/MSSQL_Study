using System;
using System.Collections.Generic;

namespace _9._Hash_Join
{
    class Player
    {
        public int playerId;
    }

    class Salary
    {
        public int playerId;
    }

    // HashTable
    // 공간을 내주고 속도를 얻는다
    // 특정 해시 알고리즘을 적용하여 값을 키로 전환하여 해당 키값의 버킷(리스트)에 저장함
    // 동일한 값 => 동일한 버킷 (Y)
    // 동일한 버킷 => 동일한 값 (N)
    class HashTable
    {
        int _bucketCount;
        List<int>[] _buckets;

        public HashTable(int bucketCount = 100)
        {
            _bucketCount = bucketCount;
            _buckets = new List<int>[_bucketCount];
            for (int i = 0; i < _bucketCount; i++)
                _buckets[i] = new List<int>();
        }

        public void Add(int value)
        {
            int key = value % _bucketCount;
            _buckets[key].Add(value);
        }

        public bool Find(int value)
        {
            int key = value % _bucketCount;
            foreach (int v in _buckets[key])
            {
                if (v == value)
                    return true;
            }

            return false;
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            Random rand = new Random();

            List<Player> players = new List<Player>();
            for (int i = 0; i < 10000; i++)
            {
                if (rand.Next(0, 2) == 0)
                    continue;

                players.Add(new Player() { playerId = i });
            }

            List<Salary> salaries = new List<Salary>();
            for (int i = 0; i < 10000; i++)
            {
                if (rand.Next(0, 2) == 0)
                    continue;

                salaries.Add(new Salary() { playerId = i });
            }

            // Temp Hash Table
            //Dictionary<int, Salary> hash = new Dictionary<int, Salary>();
            HashTable hash = new HashTable();
            foreach (Salary s in salaries)
                hash.Add(s.playerId);

            List<int> result = new List<int>();
            foreach (Player p in players)
            {
                if (hash.Find(p.playerId))
                    result.Add(p.playerId);
            }
        }
    }
}
